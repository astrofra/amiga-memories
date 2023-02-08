/*
	File: scripts/utils/rendering_stats.nut
	Author: Astrofra
*/

/*!
	@short	RenderingStats
	@author	Astrofra
*/
class	RenderingStats
{
	current_fps			=	30.0
	fps_history			=	0
	label				=	""
	fps_widget			=	0

	update_timeout		=	0.0

	raster_font			=	0

	function	RenderUser()
	{
/*
		RendererSetIdentityWorldMatrix (g_render)

		if (g_display_fps)
		{
			RendererWrite(g_render, raster_font, label, 0.435, 0.425, 0.2, false, WriterAlignMiddle, Vector(1, 1, 1))
			//	print(label)
		}
*/
	}


	function	Update()
	{
		//	Get current FPS
		current_fps = Clamp(1.0 / g_dt_frame, 0.5, 120.0)
		fps_history.append(current_fps)
		if (fps_history.len() > 120)
			fps_history.remove(0)

		//	Compute average FPS
		local	avg_fps = 0.0

		foreach(_fps in fps_history)
			avg_fps += _fps
		avg_fps /= (fps_history.len().tofloat())

		local fps_int, fps_floating_part
		fps_int = avg_fps.tointeger()
		fps_floating_part = avg_fps - fps_int
		fps_floating_part = ((fps_floating_part * 10.0).tointeger() / 10.0)

		avg_fps = fps_int + fps_floating_part

		label = avg_fps.tostring() 
		if (fps_floating_part == 0.0)
			label += ".0"
		label += " frames/sec."

		if (g_display_fps)
		{
			if (!fps_widget.is_shown)
				fps_widget.Show()
		}
		else
		{
			if (fps_widget != 0 && fps_widget.is_shown)
			{
				fps_widget.Hide()
				fps_widget.RefreshValueText(" ")
			}
		}

		if (update_timeout > Sec(0.25) && g_display_fps && fps_widget != 0)
		{
			update_timeout = 0.0
			fps_widget.RefreshValueText(label)
		}


		update_timeout += g_dt_frame
	}

	constructor()
	{
		// Load the raster font from core resources.
//		raster_font = LoadRasterFont(g_factory, "@core/fonts/profiler_base.nml", "@core/fonts/profiler_base")

		fps_history = []
		fps_history.append(current_fps)
		if (g_WindowsManager != 0)
		{
			fps_widget = g_WindowsManager.CreateClickButton(0, "30.0 frames/sec.")
			fps_widget.SetSkin("orange_skin")
			fps_widget.SetPos(Vector(16,24,0))
//			g_WindowsManager.PushInFront(fps_widget)
//			fps_widget.SetZOrder(-1.0)
			fps_widget.Hide(true)
			fps_widget.RefreshValueText(" ")
		}
	}
}
