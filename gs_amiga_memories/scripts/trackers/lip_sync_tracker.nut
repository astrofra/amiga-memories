/*
	File: scripts/lipsync_test.nut
	Author: Astrofra
*/

g_viseme_set <- "assets/visemes/sven-robot/"

Include(g_viseme_set + "phoneme_to_viseme.nut")

function	LipSyncNutInclude(_key)
{
		local	_nut_fname = "voice_" + g_story + "_" + _key + ".nut"
		print("LipSyncNutInclude() : loading '" + _nut_fname + "'.")

		if (FileExists("tmp/" + _nut_fname))
		{
			print("Loading from 'tmp/'")
			Include("tmp/" + _nut_fname)
		}
		else
		{
			print("Loading from 'archived_files/'")
			Include("archived_files/" + _nut_fname)
		}
}

/*!
	@short	lipsync_test
	@author	Astrofra
*/
class	LipSyncTrack
{
	current_clip			=	0
	text					=	0
	current_phoneme_index 	=	0
	current_phoneme 		=	0
	lipsync_clock			=	0.0
	duration				=	-1.0
	all_done				=	false
	current_viseme_sprite	=	0
	mouth_2d				=	false
	ui						=	0
	external_material_list	=	0
	disable_narrator		=	false

	/*!
		@short	OnUpdate
		Called each frame.
	*/
	function	Update()
	{
		local	_clock = g_clock - lipsync_clock

		if (all_done)
			return

		if (_clock > current_phoneme.last_time)
			GetNextPhoneme()
	}

	function	GetNextPhoneme()
	{
		if (current_phoneme_index < list_phoneme.len())
		{
			if (text != "pause")
			{
				current_phoneme = list_phoneme[current_phoneme_index]
				//	print("GetNextPhoneme() : '" + current_phoneme.phoneme_type + "'.")
				GetVisemeFromPhoneme(current_phoneme.phoneme_type)
			}
			else
			{
				current_phoneme = list_phoneme[current_phoneme_index]
				GetVisemeFromPhoneme("_")
			}

			current_phoneme_index++
		}
		else
		{
			//	print("LipSyncTrack::GetNextPhoneme() All done!")
			GetVisemeFromPhoneme("_")
			if ((duration < 0) || (g_clock - lipsync_clock >= duration))
				all_done = true
		}
	}

	function	GetVisemeFromPhoneme(pho)
	{
//		if ("video" in current_clip)	//	FIX ME!!!
//			return

		if (pho == "_")	pho = "closed"
		pho = pho.toupper()

		if (pho in visemes)
		{
			local	vi = visemes[pho]

			if (disable_narrator)
				return

			local	mouth_tex = EngineLoadTexture(g_engine, g_viseme_set + vi + ".png")

			if (mouth_2d)
			{
				if (current_viseme_sprite != 0)
					UIDeleteSprite(ui, current_viseme_sprite)
		
				current_viseme_sprite = UIAddSprite(ui, -1, mouth_tex, 10, 10, 150, 150)
				SpriteSetScale(current_viseme_sprite, 2, 2)
			}
			else
			{
				local	geo, mat
				geo = ItemGetGeometry(SceneFindItem(g_scene, "monitor_screen"))
				mat = GeometryGetMaterialFromIndex(geo, 0)
				MaterialSetTexture(mat, 0, mouth_tex)
				foreach(_mat in external_material_list)
					MaterialSetTexture(_mat, 0, mouth_tex)
			}
		}
	}

	//----------------------------------------
	function	RegisterExternalMaterial(_mat)
	//----------------------------------------
	{
		external_material_list.append(_mat)
	}

	//-------------------------
	function	AddPauseAtEnd()
	//-------------------------
	{
		print("LipSyncTrack::AddPauseAtEnd()")
		local _last_idx = list_phoneme.len() - 1
		local	clip_duration = 0.0
		if (_last_idx >= 0)
		{
			list_phoneme[_last_idx].last_time += FixedSecToTick(Sec(1.0))
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
		print("LipSyncTrack::Feed()")
		local	clip_duration, key
		duration = -1.0
		current_clip = _current_clip
		text = current_clip.text
		key = SHA1(text)
		lipsync_clock = g_clock
		all_done = false
		current_phoneme_index 	=	0
		current_phoneme 		=	0

		print("LipSyncTrack::Feed(" + key + ")")
		LipSyncNutInclude(key)

		if ("duration" in _current_clip)
		{
			clip_duration = FixedSecToTick(Sec(_current_clip.duration))
			duration = clip_duration
		}
		else
			clip_duration = AddPauseAtEnd()

		if ("emulator" in _current_clip && !("narrator_command" in _current_clip.emulator))
			disable_narrator = true
		else
			disable_narrator = false

		if (text != "pause")
			SceneGetScriptInstance(g_scene).audio_mixer.PlaySound("voice_" + g_story + "_" + key + ".ogg", g_clock, "voice_over")

		GetNextPhoneme()

		return	clip_duration
	}

	constructor()
	{
		print("LipSyncTrack::constructor()")

		ui = SceneGetUI(g_scene)
		external_material_list = []
	}
}
