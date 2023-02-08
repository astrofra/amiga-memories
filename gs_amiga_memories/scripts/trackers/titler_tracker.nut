/*
	File: scripts/subtitles_tracker.nut
	Author: Astrofra
*/

Include("scripts/ui.nut")

/*!
	@short	SubtitleTrack
	@author	Astrofra
*/
class	VideoTitlerTrack
{
	ui						=	0
	text					=	""
	titler_label			=	0
	command					=	0
	all_done				=	false
	main_sprite				=	0
	handler_sprite			=	0

	/*!
		@short	OnUpdate
		Called each frame.
	*/
	function	Update()
	{
		if (all_done)
			return

		switch(command)
		{
			case "In":
			case "in":
				SpriteSetOpacity(main_sprite, 0.0)
				SpriteSetOpacity(titler_label.window, 0.0)
				SpriteSetPosition(handler_sprite, -32, 0)
				SpriteSetPosition(titler_label.window, 64, 0)
				WindowSetCommandList(main_sprite, "toalpha 1,1;")
				WindowSetCommandList(handler_sprite, "toposition 1,0,0;")
				WindowSetCommandList(titler_label.window, "toposition 1,0,0+toalpha 3.0,1;")
				all_done = true
				break

			case "Out":
			case "out":
				SpriteSetOpacity(main_sprite, 1.0)
				SpriteSetPosition(handler_sprite, 0, 0)
				WindowSetCommandList(main_sprite, "toalpha 0.35,0;")
				WindowSetCommandList(handler_sprite, "toposition 0.35,-16,0;")
				WindowSetCommandList(titler_label.window, "toposition 0.5,128,0+toalpha 0.5,0;")
				all_done = true
				break
		}
	}

	//-------------------------
	function	GetSubtitleDuration()
	//-------------------------
	{
		print("VideoTitlerTrack::GetSubtitleDuration()")
		local _last_idx = list_phoneme.len() - 1
		local	clip_duration = 0.0
		if (_last_idx >= 0)
		{
			list_phoneme[_last_idx].last_time += FixedSecToTick(Sec(0.5))
			clip_duration = list_phoneme[_last_idx].last_time
		}

		return	clip_duration
	}

	/*!
		@short	OnSetup
		Called when the scene is about to be setup.
	*/
	function	Feed(_current_clip)
	{
		print("VideoTitlerTrack::Feed()")
		all_done = false
		command = ""

		if ("titler" in _current_clip)
		{
			if ("text" in _current_clip.titler)
			{
				text = _current_clip.titler.text
				titler_label.label = text
				titler_label.refresh()
			}

			if ("command" in _current_clip.titler)
				command = _current_clip.titler.command
		}
		else
			all_done = true
	}

	constructor()
	{
		print("VideoTitlerTrack::constructor()")
		ui = SceneGetUI(g_scene)

		//	Main window
		handler_sprite = UIAddWindow(ui, -1, 0, 0, 0, 0)
		
		//	BG
		local	bg_texture = ResourceFactoryLoadTexture(g_factory, "ui/on_screen_message.png")
		main_sprite = UIAddSprite(ui, -1, bg_texture, 0, 0, TextureGetWidth(bg_texture), TextureGetHeight(bg_texture))
		local	child_bg = UIAddSprite(ui, -1, bg_texture, 0, 0, TextureGetWidth(bg_texture) * 0.8, TextureGetHeight(bg_texture))
		SpriteSetParent(child_bg, main_sprite)
		SpriteSetPosition(child_bg, TextureGetWidth(bg_texture) * -0.8, 0.0)

		//	Text
		UILoadFont("ui/fonts/FuturaBOLD.ttf")
		titler_label = Label(ui, TextureGetWidth(bg_texture), TextureGetHeight(bg_texture), 0, 0, true, true)
		titler_label.label_color = 0xffff00ff
		titler_label.font = "FuturaBOLD"
		titler_label.font_size = 64
		titler_label.drop_shadow = true
		titler_label.font_tracking = -1.0
		titler_label.font_leading = -1.0
		titler_label.label = ""
		titler_label.refresh()

		SpriteSetParent(titler_label.window, main_sprite)
		SpriteSetPivot(titler_label.window, 0, 0) //-TextureGetWidth(bg_texture) * 0.5, -TextureGetHeight(bg_texture) * 0.5)
		local	x,y
		x = (1280.0 - (960.0 / 720.0 * 1280.0)) / 2.0
		y = 960.0 - TextureGetHeight(bg_texture) - 32.0
		SpriteSetPosition(main_sprite, x, y)
		SpriteSetOpacity(main_sprite, 0.0)

		SpriteSetParent(main_sprite, handler_sprite)
	}
}
