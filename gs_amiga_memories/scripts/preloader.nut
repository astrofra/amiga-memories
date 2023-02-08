/*
	File: scripts/preloader.nut
	Author: Astrofra
*/

/*!
	@short	Preload
	@author	Astrofra
*/
class	Preload
{
	
	object_list = [
"a500_cpu_lowpoly.nmg"
"amiga_Down.nmg"
"Amiga_up.nmg"
"basile_toy.nmg"
"basketball.nmg"
"bike_body.nmg"
"bike_seat.nmg"
"bike_steering.nmg"
"bike_wheel_rear.nmg"
"bik_wheel_front.nmg"
"boing_ball-realistic.nmg"
"boing_ball.nmg"
"boing_wall.nmg"
"box_baal.nmg"
"box_ballistix.nmg"
"box_bloodmoney.nmg"
"box_dune.nmg"
"box_fireandforget.nmg"
"box_flashback.nmg"
"box_fs2.nmg"
"box_jet.nmg"
"box_jinxter.nmg"
"box_menace.nmg"
"box_pawn.nmg"
"box_starglider.nmg"
"box_theplague.nmg"
"caps_led.nmg"
"cap_lock.nmg"
"cpu_small_Logo.nmg"
"Drive_text.nmg"
"EL_dome.nmg"
"floppy-body.nmg"
"floppy-cover.nmg"
"floppy-label-centurion.nmg"
"floppy-label-dune.nmg"
"floppy-label-falcon.nmg"
"floppy-label-maniac_mansion.nmg"
"floppy-label-robocop.nmg"
"floppy-label.nmg"
"ground.nmg"
"harlock_ship.nmg"
"joy_button_l.nmg"
"joy_button_r.nmg"
"joy_cord_input.nmg"
"joy_main_body.nmg"
"joy_square.nmg"
"joy_stick.nmg"
"joy_wire.nmg"
"Keyboard_dark.nmg"
"Keyboard_light.nmg"
"Keyboard_NUM.nmg"
"KeyB_Side_Dark.nmg"
"lamp_arm_0.nmg"
"lamp_arm_1.nmg"
"lamp_bulb.nmg"
"lamp_elbow.nmg"
"lamp_head.nmg"
"lamp_pod.nmg"
"lamp_wire.nmg"
"library.nmg"
"long-lamp_arm.nmg"
"long-lamp_feet.nmg"
"long-lamp_head.nmg"
"magazine_ces_1985.nmg"
"magazine_dune.nmg"
"mag_tilt_44.nmg"
"mag_tilt_52.nmg"
"mag_tilt_55.nmg"
"mag_tilt_67.nmg"
"Matt_1.nmg"
"Matt_2.nmg"
"monitor.nmg"
"monitor_frame.nmg"
"monitor_front.nmg"
"monitor_front_branding.nmg"
"monitor_lowpoly.nmg"
"monitor_screen.nmg"
"mouse.nmg"
"mouse_buttons.nmg"
"mouse_to_cord.nmg"
"mouse_wire.nmg"
"narrator_plane.nmg"
"night-pan.nmg"
"num1.nmg"
"num2.nmg"
"num3.nmg"
"num4.nmg"
"Num_2.nmg"
"Num_8.nmg"
"Num_Enter.nmg"
"Num_minus.nmg"
"Num_plus.nmg"
"portrait_frame.nmg"
"portrait_photo_dale-luck.nmg"
"poster_blue-velvet.nmg"
"poster_dune.nmg"
"poster_eraserhead.nmg"
"poster_ghostbusters.nmg"
"poster_gremlins.nmg"
"poster_karate-kid.nmg"
"poster_scanners.nmg"
"Power_Drive_Lamp.nmg"
"power_text.nmg"
"psu_body_bottom.nmg"
"psu_body_top.nmg"
"psu_inside.nmg"
"psu_label.nmg"
"psu_switch.nmg"
"psu_wire_connector.nmg"
"psu_wire_in.nmg"
"psu_wire_out.nmg"
"table.nmg"
"table_basket.nmg"
"table_foot.nmg"
"table_paper_sheets.nmg"
"tennis_ball.nmg"
"toy_grendizer.nmg"
"toy_harlock_cara_00.nmg"
"toy_harlock_cara_01.nmg"
"toy_harlock_cara_02.nmg"
"toy_harlock_cara_03.nmg"
"toy_harlock_cara_04.nmg"
"toy_harlock_cara_05.nmg"
"toy_harlock_cara_06.nmg"
"toy_harlock_cara_07.nmg"
"toy_harlock_cara_08.nmg"
"toy_harlock_cara_09.nmg"
"toy_harlock_cara_10.nmg"
"toy_harlock_cara_11.nmg"
"toy_harlock_cara_12.nmg"
"wall.nmg"
"wall_window.nmg"
"wall_wipe.nmg"
	]

	current_object		=	0
	progress			=	0
	preloading			=	true
	ui					=	0
	bar					=	0

	raster_tex			=	0
	raster_spr			=	0

	toggle				=	false

//object_list = []

	function	OnSetup(scene)
	{
		print("Preload::OnSetup()")
		current_object	=	0
		ui	=	SceneGetUI(scene)

		CreateLoaderRaster()
		
		local	_preloader_back_texture, _preloader_bar_texture, _w, _h, _wb, _hb
		_preloader_back_texture = EngineLoadTexture(g_engine, "ui/loader_back.png")
		_preloader_bar_texture = EngineLoadTexture(g_engine, "ui/loader_bar.png")

		_w = TextureGetWidth(_preloader_back_texture)
		_h = TextureGetHeight(_preloader_back_texture)
		_wb = TextureGetWidth(_preloader_bar_texture)
		_hb = TextureGetHeight(_preloader_bar_texture)

		local	_back = UIAddSprite(ui, -1, _preloader_back_texture, 1280 * 0.5 - _w * 0.5, 960 - _h * 2.0, _w, _h)
		bar = UIAddSprite(ui, -1, _preloader_bar_texture, 16, 32, 481, 21)
		WindowSetParent(bar, _back)
	}

	function	CreateLoaderRaster()
	{
		raster_tex = []
		raster_spr = []

		local	n
		for(n = 0; n < 64; n++)
		{
			local	new_tex = NewTexture()
			local	new_pic = NewPicture(16,16)
			local	new_color = Vector(0,0,0,1)
			new_color.x = Rand(0.0, 1.0)
			new_color.y = Rand(0.0, 1.0)
			new_color.z = Rand(0.0, 1.0)
			PictureFill(new_pic, new_color)
			TextureUpdate(new_tex, new_pic)
			raster_tex.append(new_tex)
		}

		local	y
		for(y = 0; y < 960.0; y += 16)
		{
			local	spr = UIAddSprite(ui, -1, raster_tex[Irand(0,63)], 640, y, 16, 16)
			SpriteSetPivot(spr, 8, 8)
			SpriteSetScale(spr, 1280.0 / 16.0 * 2.0, 1.0)
			raster_spr.append(spr)
		}
	}

	function	UpdateLoaderRaster()
	{
		foreach(spr in raster_spr)
		{
			SpriteSetTexture(spr, raster_tex[Irand(0,63)])
			SpriteSetScale(spr, 1280.0 / 16.0 * 2.0, Rand(1.0,2.5))
		}
	}

	function	OnUpdate(scene)
	{
		UpdateLoaderRaster()

		if (object_list.len() > 0)
			progress	=	(((object_list.len() - current_object) * 100.0) / object_list.len()).tointeger()

		progress = Clamp(100 - progress, 0.0, 100)
		//progress = (Pow(progress / 100.0, 2.0) * 100.0).tointeger()

		WindowSetScale(bar, Clamp((progress / 100.0), 0.01, 1.0), 1.0)

		print("Preload::OnUpdate() progress = " + progress)

		toggle != toggle

		if (toggle)
			return

		if (preloading && UIIsCommandListDone(ui))
		{
			if (current_object < object_list.len())
			{
				EngineLoadGeometry(g_engine, "assets/" + object_list[current_object])
			}
			else
			{
				ProjectGetScriptInstance(g_project).PlayStory()
				preloading = false
			}

			current_object++
		}
	}

}
