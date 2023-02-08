/*
	File: scripts/main_menu_screen.nut
	Author: Astrofra
*/

Include("scripts/utils/scene_game_base.nut")
Include("scripts/emulators/emu_starfield.nut")
Include("scripts/emulators/emu_scrolltext.nut")

g_language_names <-	{	fr = {	key = "fr", name = "French   "		},
						en = {	key = "en", name = "English   "	},
						jp = {	key = "jp", name = "Japanese"	},
					}

/*!
	@short	MainMenuScreen
	@author	Astrofra
*/
class	MainMenuScreen	extends SceneGameBase
{
	menu_table			=	0
	starfield_handler	=	0
	scrolltext_handler	=	0
	ui					=	0

	start_bt_back		=	0
	start_bt_bg_tex		=	0
	start_bt_bg_pic		=	0
	start_bt_color		=	0
	current_component	=	0

	render_stats		=	0

	language_selection	=	0

	music_channel		=	0

	keyboard_device		=	0

	function	OnSetup(scene)
	{
		if ("OnSetup" in base)	base.OnSetup(scene)

		keyboard_device = GetInputDevice("keyboard")

		starfield_handler = EmuStarfield(scene)
		starfield_handler.max_star = 500
		starfield_handler.Setup()
		starfield_handler.SetRenderMode("polygon")

		//	Main Title
		ui = SceneGetUI(scene)
		local	raster_tex = ResourceFactoryLoadTexture(g_factory, "assets/pink_bg_gradient.png")
		local	blue_raster_tex = ResourceFactoryLoadTexture(g_factory, "assets/blue_bg_gradient.png")

		local	title_scale = 1.5
		local	title_tex = ResourceFactoryLoadTexture(g_factory, "assets/amiga_memories-title.png")

		for(local n = 0; n < 4; n++)
		{
			local	raster_spr = UIAddSprite(ui, -1, raster_tex, 1280 * 0.5, TextureGetHeight(raster_tex) * 0.6 + n * TextureGetHeight(raster_tex) * 0.65 + 12, TextureGetWidth(raster_tex), TextureGetHeight(raster_tex))
			SpriteSetPivot(raster_spr, TextureGetWidth(raster_tex) * 0.5, TextureGetHeight(raster_tex) * 0.5)
			SpriteSetScale(raster_spr, 100, 0.5)
			SpriteSetOpacity(raster_spr, 0.8)
		}

		local	title_spr = UIAddSprite(ui, -1, title_tex, 1280 * 0.5, TextureGetHeight(title_tex) * 0.6, TextureGetWidth(title_tex), TextureGetHeight(title_tex))
		SpriteSetPivot(title_spr, TextureGetWidth(title_tex) * 0.5, TextureGetHeight(title_tex) * 0.5 / title_scale)
		SpriteSetScale(title_spr, title_scale, title_scale)
		local	h = TextureGetHeight(title_tex) * 1.15 * title_scale

		//	"Start button" rasters
		local	raster_spr = UIAddSprite(ui, -1, blue_raster_tex, 1280 * 0.5, 800 + 24, TextureGetWidth(blue_raster_tex), TextureGetHeight(blue_raster_tex))
		SpriteSetPivot(raster_spr, TextureGetWidth(blue_raster_tex) * 0.5, TextureGetHeight(blue_raster_tex) * 0.5)
		SpriteSetScale(raster_spr, 100, 1.0)
		SpriteSetOpacity(raster_spr, 0.75)


		//	Scroll text
		scrolltext_handler = EmuScrollText(scene)
		scrolltext_handler.text = ""
		scrolltext_handler.text += " ... Hello girls and boys, this is the year 2013 and Mandarine is proud to present : amiga memories !!"
		scrolltext_handler.text += " this whole demo was setup as a tribute by a collective of former unconsolable users of the Amiga computer ... "
		scrolltext_handler.text += " the Amiga 500 itself was modeled by Hitbit911 from Dubai !"
 		scrolltext_handler.text += " Code by Astrofra using the GameStart3D framework, ", 
		scrolltext_handler.text += " Robotic face made by Ptoing,"
		scrolltext_handler.text += " music credits goes to Lluvia, Radix, AudioBank.FM"
		scrolltext_handler.text += " ... and Edwin van Santen for his SID song [Blue Monday]."
		scrolltext_handler.text += " The speech synthesis is an audio miracle produced by the MaryTTS package from the dfki.de University."
		scrolltext_handler.text += " thanks to scorpheus for helping me with the lipsync technique in the first place ... :]"
		scrolltext_handler.text += " and to James N. Anderson for it's Quick N Dirty phoneme extractor!"
		scrolltext_handler.text += " Thanks to Adoru for the helping hand with the Amiga historical resources"
		scrolltext_handler.text += " ... and finally, the bitmap font of this very scrolltext was borrowed to the Amiga Karate Engine by Krabob/Mankind ..."

		scrolltext_handler.Setup()

		//	Main Menu
		menu_table = {	stories	= [ {	name = "Episode 0 - Dune            ", 	key_name = "dune",	button = 0},
									{	name = "Episode 1 - the Boing Ball",	key_name = "boing",	button = 0},
									],

						flags	= [	
								{	name = "Enable Audio Output",		key_name = "g_enable_audio_output",		button = 0	},
//								{	name = "Demo Mode              ",	key_name = "g_demo_mode",				button = 0	},
//								{	name = "Save Enabled           ",	key_name = "g_save_enabled",			button = 0	},
//								{	name = "Skip Rendered Frames",		key_name = "g_skip_rendered_frames",	button = 0	},
								{	name = "Fixed Step Enabled",		key_name = "g_fixed_step_enabled", 		button = 0	},
								{	name = "Enable Subtitles",			key_name = "g_enable_subtitles", 		button = 0	},
								{	name = "Enable FPS Display",		key_name = "g_display_fps", 		button = 0	}
							]
				}

		language_selection	=	[]

		//	Story selection
//		g_story = menu_table.stories[0].key_name

		local	story_window = g_WindowsManager.CreateVerticalSizer(0, 1000)
		story_window.SetPos(Vector(500, 8 + h, 0))

		foreach(story in menu_table.stories)
		{
			local	_bt
 			_bt = g_WindowsManager.CreateCheckButton(story_window, story.name, story.key_name == g_story ? true:false , this, "ClickOnStory")
			_bt.authorize_resize = false
			_bt.authorize_move = false
			_bt.authorize_folded = false
			story.button = _bt
		}

		//	Option selection
		local	flag_window = g_WindowsManager.CreateVerticalSizer(0, 1000)
		flag_window.SetPos(Vector(8, 8 + h, 0))
		foreach(flag in menu_table.flags)
		{
			local	_bt, default_mode
			default_mode = getroottable()[flag.key_name]
 			_bt = g_WindowsManager.CreateCheckButton(flag_window, flag.name, default_mode, this, "ClickOnFlag")
			_bt.authorize_resize = false
			_bt.authorize_move = false
			_bt.authorize_folded = false
			flag.button = _bt
		}

		//	Language selection
		local	language_window = g_WindowsManager.CreateVerticalSizer(0, 1000)
		language_window.SetPos(Vector(1120, 8 + h, 0))
		foreach(_key, _lang in g_language_names)
		{
			local	_bt
 			_bt = g_WindowsManager.CreateCheckButton(language_window, _lang.name, (g_current_language == _key?true:false), this, "ClickOnLanguage")
			_bt.authorize_resize = false
			_bt.authorize_move = false
			_bt.authorize_folded = false
			language_selection.append({button = _bt, key = _key})
		}		

		//	Start Button
		//	Background
		local	_btw = 266,
				_bth = 64,
				_btx = 500,
				_bty = 800,
				_border = 8
		
		start_bt_bg_pic = PictureNew()
		PictureAlloc(start_bt_bg_pic, _btw, _bth)
		start_bt_color = Vector(0.0,0.0,0.0,1.0)
		PictureFill(start_bt_bg_pic, start_bt_color)
		start_bt_bg_tex = ResourceFactoryNewTexture(g_factory)
		TextureUpdate(start_bt_bg_tex, start_bt_bg_pic)
		start_bt_back = UIAddSprite(ui, -1, start_bt_bg_tex, _btx - _border, _bty - _border, _btw, _bth)
		current_component = "x"

		//	Button itself
		local	start_button
		start_button = g_WindowsManager.CreateClickButton(0, "Start 'Amiga Memories'", "", this, "ClickOnStart")
		start_button.SetPos(Vector(_btx, _bty, 0))

		//	Render stats
		render_stats = RenderingStats()

		//	Music
		StartMusic()
	}

	function	StartMusic()
	{
		music_channel = MixerStartStream(g_mixer, "archived_files/sid_blue_monday.ogg")
		MixerChannelSetLoopMode(g_mixer, music_channel, LoopRepeat)
		MixerChannelSetPitch(g_mixer, music_channel, 1.0)
		MixerChannelSetGain(g_mixer, music_channel, 0.25)
	}

	function	StopMusic()
	{
		MixerChannelSetGain(g_mixer, music_channel, 1.0)
		MixerChannelSetLoopMode(g_mixer, music_channel, LoopNone)
		MixerChannelStop(g_mixer, music_channel)
	}

	function	UpdateStartButtonBackground()
	{
		switch(current_component)
		{
			case "x":
				start_bt_color.x = Clamp(start_bt_color.x + g_dt_frame, 0.0, 1.0)
				if (start_bt_color.x >= 1.0)
				{
					start_bt_color.x = 0.75
					current_component = "y"
				}
				break
			case "y":
				start_bt_color.y = Clamp(start_bt_color.y + g_dt_frame, 0.0, 1.0)
				if (start_bt_color.y >= 1.0)
				{
					start_bt_color.y = 0.75
					current_component = "z"
				}
				break
			case "z":
				start_bt_color.z = Clamp(start_bt_color.z + g_dt_frame, 0.0, 1.0)
				if (start_bt_color.z >= 1.0)
				{
					start_bt_color.y = 0.25
					start_bt_color.z = 0.5
					current_component = "x"
				}
				break
		}

//		start_bt_color = start_bt_color.Scale(0.995)
		start_bt_color.x = Clamp(start_bt_color.x - start_bt_color.x * g_dt_frame * 0.25, 0.0, 1.0)
		start_bt_color.y = Clamp(start_bt_color.y - start_bt_color.y * g_dt_frame * 0.25, 0.0, 1.0)
		start_bt_color.z = Clamp(start_bt_color.z - start_bt_color.z * g_dt_frame * 0.25, 0.0, 1.0)

		start_bt_color.w = 1.0

		local	_btw = 266,
				_bth = 64
		
		for(local n = 0; n < 16; n++)
		{
			local	_col = start_bt_color.Scale(0.5) + start_bt_color.Scale(n / 16.0)
			_col.x = Clamp(_col.x, 0.0, 1.0)
			_col.y = Clamp(_col.y, 0.0, 1.0)
			_col.z = Clamp(_col.z, 0.0, 1.0)
			_col.w = 1.0
			PictureFillRect(start_bt_bg_pic, _col, Rect(0,_bth / 16.0 * n, _btw, _bth / 16.0 * (n + 1)))
		}
//		PictureFill(start_bt_bg_pic, _col)
		TextureUpdate(start_bt_bg_tex, start_bt_bg_pic)
	}

	function	ClickOnStory(_sprite)
	{
		local	story_index
		foreach(idx, story in menu_table.stories)
		{
			story.button.RefreshValueText(false)
			if (story.button == _sprite)
				story_index = idx
		}

		menu_table.stories[story_index].button.RefreshValueText(true)
		g_story = menu_table.stories[story_index].key_name
	}

	function	ClickOnFlag(_sprite)
	{
		print("MainMenuScreen::ClickOnFlag() = " + _sprite)
		local	flag_index
		foreach(idx, flag in menu_table.flags)
		{
			if (flag.button == _sprite)
				flag_index = idx
		}

		local	flag_key = menu_table.flags[flag_index].key_name
		getroottable()[flag_key] = !getroottable()[flag_key]
		print(flag_key + " = " + getroottable()[flag_key].tostring())
	}

	function	ClickOnLanguage(_sprite)
	{
		print("MainMenuScreen::ClickOnLanguage() = " + _sprite)
		local	flag_index
		foreach(lang in language_selection)
		{
			lang.button.RefreshValueText(false)
			if (lang.button == _sprite)
			{
				g_current_language = lang.key
				lang.button.RefreshValueText(true)
			}
		}

		print("g_current_language = " + g_current_language)
	}

	function	ClickOnStart(_sprite)
	{
		print("MainMenuScreen::ClickOnStart() = " + _sprite)
		StopMusic()
		ProjectGetScriptInstance(g_project).PreloadStory()
	}

	function	OnRenderUser(scene)	
	{
		if ("OnRenderUser" in base)	base.OnRenderUser(scene)
		starfield_handler.RenderUser()
		render_stats.RenderUser()
	}

	function	OnUpdate(scene)
	{
		if ("OnUpdate" in base)	base.OnUpdate(scene)

		if (!DeviceWasKeyDown(keyboard_device, KeyEscape) && DeviceIsKeyDown(keyboard_device, KeyEscape))
			QuitApp()

		starfield_handler.Update()
		scrolltext_handler.Update()
		render_stats.Update()
		UpdateStartButtonBackground()
	}

	function	QuitApp()
	{
		SceneEnd(g_scene)
		ProjectEnd(g_project)
	}
}
