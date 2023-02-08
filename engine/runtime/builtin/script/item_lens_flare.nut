flare_config	<-
{
	parts =
	[
		[UV(0, 0), UV(0.5, 0.5)],
		[UV(0.5, 0), UV(1, 0.5)],
		[UV(0, 0.5), UV(0.5, 1)],
		[UV(0.5, 0.5), UV(1, 1)]
	]

	flare =
	[
		{	index = 0, t = 0.0, scale = 0.25, alpha = 0.5	},
		{	index = 2, t = 0.0, scale = 0.25, alpha = 0.5	}
		{	index = 0, t = 0.005, scale = 0.1, alpha = 0.75	}
	]

	reflection =
	[
		{	index = 1, t = 0.05, scale = 0.1, alpha = 0.4	}
		{	index = 3, t = 0.3, scale = 0.075, alpha = 0.15	}
		{	index = 3, t = 0.9, scale = 0.4, alpha = 0.025	}
		{	index = 3, t = 0.95, scale = 0.025, alpha = 0.025	}
		{	index = 3, t = 1.3, scale = 0.075, alpha = 0.1	}
		{	index = 3, t = 1.5, scale = 0.05, alpha = 0.15	}
		{	index = 3, t = 1.85, scale = 0.025, alpha = 0.1	}
		{	index = 1, t = 2, scale = 0.5, alpha = 0.05	}
		{	index = 3, t = 2.5, scale = 0.15, alpha = 0.05	}
	]
}

class	BuiltinLensFlare
{
/*<
	<Script =
		<Name = "Lens Flare">
		<Author = "Emmanuel Julien">
		<Description = "Draw a lens flare at an item location.">
		<Category = "FX">
		<Compatibility = <Item>>
	>
	<Parameter =
		<strength = <Name = "Strength"> <Type = "Float"> <Default = 1.0>>
		<flicker = <Name = "Flicker."> <Type = "Bool"> <Default = False>>
		<draw_flare = <Name = "Draw flare && streaks."> <Type = "Bool"> <Default = True>>
		<draw_reflection = <Name = "Draw lens reflections."> <Type = "Bool"> <Default = True>>
		<test_occlusion = <Name = "Test occlusion."> <Type = "Bool"> <Default = True>>
		<scale_flare = <Name = "Flare size"> <Type = "Float"> <Default = 1.0>>
		<scale_flare_d = <Name = "Scale with distance."> <Type = "Bool"> <Default = False>>
		<scale_lens = <Name = "Lens size"> <Type = "Float"> <Default = 1.0>>
		<scale_lens_d = <Name = "Scale with distance."> <Type = "Bool"> <Default = False>>
	>
>
*/
	color			=	Vector(1, 1, 1)
	alpha			=	0.0

	//----------------------------------------------
	scale_flare		=	1.0
	scale_flare_d	=	true
	scale_lens		=	1.0
	scale_lens_d	=	true

	strength		=	1.0
	flicker			=	false
	draw_flare		=	true
	draw_reflection	=	true
	test_occlusion	=	true
	//----------------------------------------------

	scale			=	1.0

	flare_texture	=	0
	distance		=	0.5
	dt_len			=	0.0

	light			=	0

	identity_matrix	=	0

	function	OnUpdate(item)
	{
		if	(light != 0)
			color = LightGetDiffuseColor(light)
	}

	function	OnSetup(item)
	{
		flare_texture = EngineLoadTexture(g_engine, "builtin/maps/flare.png")
		try {	light = ItemCastToLight(item)	} catch (e) {}

		identity_matrix = Matrix4()
	}

	function	ProjectToCameraPlane(position, camera_m, distance)
	{
		return camera_m.GetPosition() + (position - camera_m.GetPosition()).Normalize() * distance
	}

	function	DrawPart(part, camera_m, origin, delta, scale_distance)
	{
		local	u = flare_config.parts[part.index],
				p = origin + delta * part.t,
				s = scale * part.scale,
				a = alpha * part.alpha * strength

		if	(scale_distance)
			s /= dt_len

		local	c = Vector(color.x, color.y, color.z, a)
		DrawBillboardQuadTextured(camera_m, p, s, flare_texture, u[0], u[1], c, MaterialBlendAdd, MaterialRenderNoDepthTest | MaterialRenderNoDepthWrite)
	}

	function	OnRenderUser(item)
	{
		if 	(!ItemIsActive(item))
			return

		if	(!draw_flare && !draw_reflection)
			return

		/*
			Direct drawing to screen must be done here to ensure proper operation with
			renderers like the OpenGL3 deferred renderer.
		*/
		local	camera = SceneGetCurrentCamera(g_scene),
				camera_i = CameraGetItem(camera),
				camera_m = ItemGetMatrix(camera_i)

		local	item_m = ItemGetMatrix(item)

		// Determine flare occlusion.
		local	dt = item_m.GetPosition() - camera_m.GetPosition()
		dt_len = dt.Len()

		local	target_alpha = flicker ? Rand(0.6, 1.0) : 1

		if	(camera_m.GetFront().Dot(dt) < 0)
			target_alpha = 0		// Flare is in camera back.
		else
			if	(test_occlusion && SceneCollisionRaytrace(g_scene, camera_m.GetPosition(), dt / dt_len, ~0, CollisionTraceAll, dt_len).hit)
				target_alpha = 0	// Flare is occluded.
		else
			if	(CameraCullPosition(camera, item_m.GetPosition()) == VisibilityOutside)
				target_alpha = 0	// Flare is outside of the screen.

		alpha += (target_alpha - alpha) * pow(0.985, 1.0 / g_dt_frame)
		if	(alpha < 0.01)
			return

		// Draw.
		local	origin = ProjectToCameraPlane(item_m.GetPosition(), camera_m, distance),
				center = camera_m.GetFront().Normalize() * distance + camera_m.GetPosition(),
				delta = center - origin

		RendererSetWorldMatrix(g_render, identity_matrix)

		scale = scale_flare
		if	(draw_flare)
			foreach (part in flare_config.flare)
				DrawPart(part, camera_m, origin, delta, scale_flare_d)

		scale = scale_lens
		if	(draw_reflection)
			foreach (part in flare_config.reflection)
				DrawPart(part, camera_m, origin, delta, scale_lens_d)
	}
}
