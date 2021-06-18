$input v_viewRay

#include <forward_pipeline.sh>

SAMPLER2D(u_color, 0);
SAMPLER2D(u_attr0, 1);
SAMPLER2D(u_attr1, 2);
SAMPLER2D(u_noise, 3);
SAMPLERCUBE(u_probe, 4);
SAMPLER2D(u_depthTex, 5);           // input: minimum depth pyramid

#define sample_count uAAAParams[1].z

#define uv_ratio vec2_splat(uAAAParams[0].y)

#include <aaa_utils.sh>
#include <hiz_trace.sh>


void main() {
	vec4 jitter = texture2D(u_noise, mod(gl_FragCoord.xy, vec2(64, 64)) / vec2(64, 64));

	// sample normal/depth
	vec2 uv = gl_FragCoord.xy * uv_ratio / uResolution.xy;
	vec4 attr0 = texture2D(u_attr0, uv);

	vec3 n = attr0.xyz;

	// compute ray origin & direction
	float near = -uMainProjection[2].w / uMainProjection[2].z;
	float far  = -near * uMainProjection[2].z / (1.0 - uMainProjection[2].z);
	float z = (attr0.w * (far - near) + near*far) / far;
	vec3 ray_o = v_viewRay * z;
	vec3 ray_d = reflect(normalize(ray_o), n);

	// roughness
	float roughness = texture2D(u_attr1, uv).z;

	vec3 right = cross(ray_d, vec3(0, 0, 1));
	vec3 up = cross(ray_d, right);

	//
	vec4 color = vec4_splat(0.);
	for (int i = 0; i < int(sample_count); ++i) {
		float r = roughness * (float(i) + jitter.y) / sample_count;
		float spread = r * 3.141592 * 0.5 * 0.99;
		float cos_spread = cos(spread), sin_spread = sin(spread);

		for (int j = 0; j < int(sample_count); ++j) {
			float angle = float(j + jitter.w) / sample_count * 2. * 3.141592;
			vec3 ray_d_spread = (right * cos(angle) + up * sin(angle)) * sin_spread + ray_d * cos_spread;

			vec2 hit_pixel;
			vec3 hit_point;
			if (TraceScreenRay(ray_o - v_viewRay * 0.05, ray_d_spread, uMainProjection, 0.1, /*jitter.z,*/ 64, hit_pixel, hit_point)) {
				// use hit pixel velocity to compensate the fact that we are sampling the previous frame
				vec2 uv = hit_pixel * uv_ratio / uResolution.xy;
				vec2 vel = GetVelocityVector(uv);
				
				vec4 attr0 = texelFetch(u_attr0, ivec2(hit_pixel), 0);

				if (dot(attr0.xyz, ray_d_spread) < 0.0) {
					color += vec4(texture2D(u_color, uv - vel * uv_ratio).xyz, 0.);
				} else {
					color += vec4(0.0, 0.0, 0.0, 0.0); // backface hit
				}
			} else {
				vec3 world_ray_d_spread = mul(uMainInvView, vec4(ray_d_spread, 0.0)).xyz;
				color += vec4(textureCubeLod(u_probe, world_ray_d_spread, 0).xyz, 1.);
			}
		}
	}

#if 1
	if (isNan(color.x) || isNan(color.y) || isNan(color.z))
		color = vec4(1., 0., 0., 1.);
#endif

	gl_FragColor = color / (sample_count * sample_count);
}
