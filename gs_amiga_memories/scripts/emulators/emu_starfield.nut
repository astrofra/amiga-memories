/*
	File: scripts/emu_startfield.nut
	Author: Astrofra
*/

/*!
	@short	EmuStarfield
	@author	Astrofra
*/
class	EmuStarfield
{
	scene					=	0
	main_camera				=	0
	starfield				=	0
	startfield_bbox_size	=	Mtr(50.0)
	z_scale					=	2.5
	max_star				=	1500
	star_z_offset			=	0
	render_mode				=	0
	color					=	0
	p_size					=	0.05

	/*!
		@short	OnUpdate
		Called each frame.
	*/
	function	Update()
	{
		foreach(star in starfield)
		{
			star.position += Vector(0,0,-1).Scale(g_dt_frame * 30.0 * star.speed)
			if (star.position.z < Mtr(0.0))
				star.position.z += (Mtr(startfield_bbox_size) * z_scale)
		}
	}

	function	RenderUser()
	{
		RendererSetIdentityWorldMatrix (g_render)

		foreach(star in starfield)
			DrawStar(star.position)
	}

	function	SetRenderMode(_mode)
	{
		switch(_mode)
		{
			case "line":
				render_mode = RenderLine
				break
			case "polygon":
				render_mode = RenderPolygon
				break
		}
	}

	function	DrawStar(pos)
	{
		render_mode(pos)
	}

	function	RenderLine(pos)
	{
		RendererDrawLine(g_render, pos, pos + star_z_offset)
	}

	function	RenderPolygon(pos)
	{
		RendererDrawTriangle(g_render, pos + Vector(-p_size,p_size,0.0), pos + Vector(p_size,p_size,0.0),  pos + Vector(0.0,-p_size,0.0), color, color, color, MaterialBlendNone, MaterialRenderUnlit)
	}

	/*!
		@short	OnSetup
		Called when the scene is about to be setup.
	*/
	function	Setup(create_camera = true)
	{
		main_camera = {camera = 0, item = 0}

		if (create_camera)
		{
			main_camera.camera = SceneAddCamera(scene, "main_camera")
			main_camera.item = CameraGetItem(main_camera.camera)
			SceneSetCurrentCamera(scene, main_camera.camera)
		}
		else
		{
			main_camera.camera = SceneGetCurrentCamera(scene)
			main_camera.item = CameraGetItem(main_camera.camera)
		}

		starfield = []
		for(local n = 0; n < max_star; n++)
		{
			local	pos = Vector()
			pos.x = Rand(-1000.0, 1000.0); pos.y = Rand(-1000.0, 1000.0); pos.z = Rand(-1000.0, 1000.0)
			pos = pos.Normalize()
			pos = pos.Scale(Rand(0.1,1.0))
			pos = pos.Scale(startfield_bbox_size)
			pos.z += Mtr(startfield_bbox_size)
			pos.z *= z_scale
			starfield.append({position = pos, scale = 1.0, speed = Rand(0.5,1.5)})
		}

		star_z_offset = Vector(0,0,1)

		render_mode = RenderLine
	}

	constructor(_scene)
	{
		scene = _scene
		color = Vector(1,1,1,1)
	}
}
