# /*
# 	File: scripts/video_tracker.nut
# 	Author: Astrofra
# */

# /*!
# 	@short	RenderToTextureTracker
# 	@author	Astrofra
# */
# class	RenderToTextureTracker
# {
# 	screen_material		=	0

# 	current_clip		=	0
# 	scene_path			=	0
# 	duration			=	0.0
# 	emu_clock			=	0.0

# 	main_camera			=	0
# 	rt_camera			=	0
# 	render_picture		=	0
# 	render_texture		=	0

# 	emulator_assets		=	0
# 	emulator_manager	=	0

# 	all_done			=	false

# 	function	Update()
# 	{
# 		SceneRegisterAsPropertyCallback(g_scene, g_render)

# 		//	Main Render
# 		RendererClearClippingPlane(g_render)
# 		RendererClearFrame(g_render, 0, 0, 0)

# 		//	Send the scene geometry into the pipeline
# 		ScenePushRenderable(g_scene, g_render)

# 		//	In case of an "emulator" scene, render it to a texture
# 		if ((g_clock - emu_clock) < duration)
# 			UpdateEmulatorScreen()
# 		else
# 		{
# 			if (emulator_manager != 0)	ItemGetScriptInstance(emulator_manager).Pause()
# 			all_done = true
# 		}

# 		// Restore the main camera, output buffer and viewport.	
# 		main_camera = SceneGetScriptInstance(g_scene).camera_tracker.camera_item
# 		SceneSetCurrentCamera(g_scene, ItemCastToCamera(main_camera))
# 		RendererSetViewItemAndApplyView(g_render, main_camera)

# 		RendererSetViewport(g_render, 0.0, 0.0, 1.0, 1.0)

# 		RendererRenderQueue(g_render)
# 		RendererRenderQueueReset(g_render)
# 	}

# 	function	UpdateEmulatorScreen()
# 	{
# 		if (scene_path != 0)
# 		{
# 			rt_camera = GroupFindItem(emulator_assets[current_clip.emulator.name], "emulator_camera")

# 			SceneSetCurrentCamera(g_scene, ItemCastToCamera(rt_camera))
# 			RendererSetViewItemAndApplyView(g_render, rt_camera)
# 			RendererClearFrame(g_render, 0, 0, 0)
# 			local	viewport = RendererGetOutputDimensions(g_render)	//	RendererGetViewport(g_render)	
# 			RendererSetViewport(g_render, 0.0, 0.0, TextureGetWidth(render_texture).tofloat()/viewport.x.tofloat(), TextureGetHeight(render_texture).tofloat()/viewport.y.tofloat())
# 			RendererRenderQueue(g_render)
# 			RendererGrabDisplayToTexture(g_render, render_texture)
# //			RendererGrabDisplayToPicture(g_render, render_picture)
# //			RendererTextureUpdate(render_texture, render_picture)
# 			MaterialSetTexture(screen_material, 0, render_texture)
# 		}
# 	}

# 	function	Feed(_current_clip, _emulator_groups)
# 	{
# 		print("RenderToTextureTracker::Feed()")

# 		current_clip = _current_clip
# 		emulator_assets = _emulator_groups
# 		emulator_manager = 0
# 		duration = -1.0
# 		all_done = false

# 		if (("emulator" in _current_clip) && (_current_clip.emulator.name in emulator_assets))
# 		{
# //			render_texture = ResourceFactoryLoadTexture(g_factory, "assets/blank_screen.png")

# 			scene_path = _current_clip.emulator.name

# 			if ("duration" in _current_clip)
# 				duration =  SecToTick(Sec(_current_clip.duration))
# 			else
# 				duration = SceneGetScriptInstance(g_scene).current_clip_duration

# 			emulator_manager = GroupFindItem(emulator_assets[current_clip.emulator.name], "scene_manager")
# 			ItemGetScriptInstance(emulator_manager).Unpause()
			
# 			if ("narrator_command" in _current_clip.emulator)
# 				ItemGetScriptInstance(emulator_manager)[_current_clip.emulator.narrator_command]()

# 			print("RenderToTextureTracker::Feed() scene_path = " + scene_path + " , duration = " + duration)
# 		}
# 		else
# 		{
# 			scene_path = 0
# 			all_done = true
# 		}
			
# 		emu_clock = g_clock
# 	}

# 	constructor()
# 	{
# 		print("RenderToTextureTracker::constructor()")

# 		local	geo, mat
# 		geo = ItemGetGeometry(SceneFindItem(g_scene, "monitor_screen"))
# 		screen_material = GeometryGetMaterialFromIndex(geo, 0)

# 		render_texture = NewTexture()
# 		local	_res = RendererGetOutputDimensions(g_render)

# 		/*
# 			Patch when the demo is running inside GSedit.
# 			RendererGetOutputDimensions() returns (64, 64).
# 		*/
# 		if (_res.x < 128.0)	_res.x = 1280.0
# 		if (_res.y < 128.0)	_res.y = 720.0

# 		local	pic = NewPicture(_res.x, _res.y)
# 		TextureUpdate(render_texture, pic)
# 	}

# }
