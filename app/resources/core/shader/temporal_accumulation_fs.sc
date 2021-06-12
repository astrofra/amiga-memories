#include <forward_pipeline.sh>

SAMPLER2D(u_current, 0);
SAMPLER2D(u_previous, 1);
SAMPLER2D(u_attr1, 2);

#define uv_ratio vec2_splat(uAAAParams[0].x)

#include <aaa_utils.sh>

void main() {
    vec2 coord = gl_FragCoord.xy;

    vec2 uv = coord / floor(uResolution.xy / uv_ratio);
    vec2 dt = GetVelocityVector(uv);

    vec4 current = texture2D(u_current, uv, 0);
 
    vec4 c0 = texture2DLodOffset(u_current, uv, 0, ivec2( 0, 1));
    vec4 c1 = texture2DLodOffset(u_current, uv, 0, ivec2( 0,-1));
    vec4 c2 = texture2DLodOffset(u_current, uv, 0, ivec2( 1, 0));
    vec4 c3 = texture2DLodOffset(u_current, uv, 0, ivec2(-1, 0));
    vec4 neighbour_min = min(min(c0, c1), min(c2, c3));
    vec4 neighbour_max = max(max(c0, c1), max(c2, c3));

    vec4 previous = clamp(texture2D(u_previous, uv - dt * uv_ratio, 0), neighbour_min, neighbour_max);
    gl_FragColor = mix(previous, current, uAAAParams[0].z);
}
