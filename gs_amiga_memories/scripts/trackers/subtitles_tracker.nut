/*
	File: scripts/subtitles_tracker.nut
	Author: Astrofra
*/

Include("scripts/ui.nut")

/*!
	@short	SubtitleTrack
	@author	Astrofra
*/
class	SubtitleTrack
{
	text					=	0
	list_sub				=	0
	current_sub_index		=	0
	current_sub				=	0
	subtitle_clock			=	0.0
	all_done				=	false
	ui						=	0
	subtitle_label			=	0

	/*!
		@short	OnUpdate
		Called each frame.
	*/
	function	Update()
	{
		local	_clock = g_clock - subtitle_clock
		if (all_done)
			return

		if (_clock > current_sub.last_time)
			GetNextSub()
	}

	function	GetNextSub()
	{
		print("LipSyncTrack::GetNextSub()")
		if (current_sub_index < list_sub.len())
		{
			if (text != "pause")
			{
				current_sub = list_sub[current_sub_index]
				DisplaySub(current_sub.text)
			}
			else
				DisplaySub("")

			current_sub_index++
		}
		else
		{
			subtitle_label.label = ""
			subtitle_label.refresh()
			all_done = true
		}
	}

	function	DisplaySub(str)
	{
		print("SubtitleTrack::DisplaySub(" + str + ")")
		subtitle_label.label = str
		if (g_enable_subtitles)	subtitle_label.refresh()
	}

	//-------------------------
	function	GetSubtitleDuration()
	//-------------------------
	{
		print("SubtitleTrack::GetSubtitleDuration()")
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
		print("SubtitleTrack::Feed()")
		local	clip_duration, key
		text = _current_clip.text
		key = SHA1(text)
		subtitle_clock = g_clock
		all_done = false
		LipSyncNutInclude(key)
		clip_duration = GetSubtitleDuration()
		list_sub = []
		current_sub_index = 0

		if (text != "pause")
		{
			if (!("sub" in _current_clip))
			{
				all_done = true
				return
			}

			print("SubtitleTrack::Feed() subtitle text = " + text)

			local	sub_first_time = 0.0, 
					sub_last_time = 0.0,
					total_sub_len = 0

			//	Fallback on English is the current language is not available
			local	_language
			if (g_current_language in _current_clip.sub)
			{
				_language = g_current_language
				if (_language == "jp")
					subtitle_label.font_size = 42
			}
			else
			{
				_language = "en"
				subtitle_label.font_size = 64
			}

			//	Global sub length for this clip
			foreach(sub in _current_clip.sub[_language])
				total_sub_len += sub.len()

			foreach(sub in _current_clip.sub[_language])
			{
				local	sub_duration = (clip_duration * sub.len() / total_sub_len).tointeger()
				sub_last_time += sub_duration
				list_sub.append({text = sub, first_time = sub_first_time, last_time = sub_last_time})
				print(" [first_time, last_time = " + sub_first_time + ", " + sub_last_time + "]")
				sub_first_time = sub_last_time
			}
		}

		GetNextSub()
		return	clip_duration
	}

	constructor()
	{
		ui = SceneGetUI(g_scene)
		local	en_font = UILoadFont("ui/fonts/FuturaLight.ttf")
		local	jp_font = UILoadFont("ui/fonts/MSGOTHIC.TTC")
		UIFontSetFallback(en_font, jp_font)
		list_sub = []
		subtitle_label = Label(ui, 1280, 128, 1280 * 0.5, 960 - (128 * 0.75), true, true)
		subtitle_label.label_color = 0xffff00ff
		subtitle_label.font = "FuturaLight"
		subtitle_label.font_size = 64
		subtitle_label.drop_shadow = true
		subtitle_label.font_tracking = -1.0
		subtitle_label.font_leading = -1.0
		subtitle_label.label = ""
		subtitle_label.refresh()
	}
}
