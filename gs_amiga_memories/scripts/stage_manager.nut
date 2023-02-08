/*
	File: scripts/stage_manager.nut
	Author: Astrofra
*/

/*!
	@short	StageManager
	@author	Astrofra
*/

//Include("assets/scripts/stage_script.nut")
Include("scripts/narrator.nut")

Include("scripts/trackers/lip_sync_tracker.nut")
Include("scripts/trackers/camera_tracker.nut")
Include("scripts/trackers/subtitles_tracker.nut")
Include("scripts/trackers/titler_tracker.nut")
Include("scripts/trackers/video_tracker.nut")
Include("scripts/trackers/led_tracker.nut")
Include("scripts/trackers/rtt_tracker.nut")
Include("scripts/trackers/music_tracker.nut")

Include("scripts/audio_mixer.nut")
Include("scripts/thread_handler.nut")
Include("scripts/timers.nut")
Include("scripts/mary_tts.nut")
Include("scripts/paths.nut")
Include("scripts/command_line.nut")


function	FixedSecToTick(s)
{	
	if (g_fixed_step_enabled)
		return (10000.0 * s)
	else
		return (SecToTick(s))
}

function	SceneGroupSetup(scene, group)
{		
	local	items = GroupGetItemList(group)
	foreach (item in items)
		ItemRenderSetup(item, g_factory)
}

//------------------
class	StageManager
//------------------
{
	fps						=	30.0

	current_clip			=	0
	clip_idx				=	0
	current_clip_duration	=	0.0

	lip_sync_tracker		=	0
	camera_tracker			=	0
	subtitle_tracker		=	0
	titler_tracker			=	0
	video_tracker			=	0
	led_tracker				=	0
	rtt_tracker				=	0
	music_tracker			=	0

	audio_mixer				=	0

	all_done				=	false

	update_function			=	0
	wait_clock				=	0

	assets					=	0
	emulator_assets			=	0

	keyboard_device			=	0

	//	TGA Save
	start_recording			=	false
	frame_buffer			=	0
	frame_idx				=	0

	render_stats			=	0

	thread_handler			=	0

	//-----------------------------
	function	OnRenderUser(scene)	
	//-----------------------------
	{
		render_stats.RenderUser()
	}


	//-------------------------
	function	OnUpdate(scene)
	//-------------------------
	{
		//print("g_clock = " + g_clock)
		if (g_save_enabled && !all_done)
			SaveCurrentFrame()

		thread_handler.Update()

		if (update_function != 0)
			update_function()
	}

	function	SaveEditList()
	{
		if (!g_demo_mode)	audio_mixer.SaveEditListToFile("final_mix.edl")
		update_function = QuitApp
	}

	function	QuitApp()
	{
		update_function = 0
		audio_mixer.Delete()
		music_tracker.Delete()
		ProjectGetScriptInstance(g_project).LoadMainMenu()
//		SceneEnd(g_scene)
//		ProjectEnd(g_project)
	}

	//------------------------
	function	UpdateScript()
	//------------------------
	{
		lip_sync_tracker.Update()
		camera_tracker.Update()
		subtitle_tracker.Update()
		video_tracker.Update()
		led_tracker.Update()
		rtt_tracker.Update()
		titler_tracker.Update()
		music_tracker.Update()
		render_stats.Update()

		if (lip_sync_tracker.all_done && rtt_tracker.all_done)
		{
			GetNextClip()
			if (!all_done)
			{
				current_clip_duration = lip_sync_tracker.Feed(current_clip)
				camera_tracker.Feed(current_clip, fps)
				subtitle_tracker.Feed(current_clip)
				titler_tracker.Feed(current_clip)
				video_tracker.Feed(current_clip, fps)
				led_tracker.Feed(current_clip)
				rtt_tracker.Feed(current_clip, emulator_assets)
				music_tracker.Feed(current_clip)
				HandleSpecialEvent(current_clip)
				HandleFading(current_clip)
			}
		}

		if (!DeviceWasKeyDown(keyboard_device, KeyEscape) && DeviceIsKeyDown(keyboard_device, KeyEscape))
			QuitApp()
	}

	//-----------------------
	function	GetNextClip()
	//-----------------------
	{
		print("StageManager::GetNextClip()")

		if (clip_idx < stage_script.len())
		{
			current_clip = clone(stage_script[clip_idx])
			clip_idx++
		}
		else
		{
			all_done = true
			update_function = SaveEditList
		}

		return 	all_done
	}

	//----------------------------
	function	SaveCurrentFrame()
	//----------------------------
	{
		if (!start_recording)
			return

		print("StageManager::SaveCurrentFrame(" + frame_idx + ")")

		local	idx = frame_idx.tostring()
		if (frame_idx < 10)	idx = "0" + idx
		if (frame_idx < 100)	idx = "0" + idx
		if (frame_idx < 1000)	idx = "0" + idx

		local	do_save = true
		local	frame_fname = "tmp/tga/frame_" + idx + ".tga"

		if (g_skip_rendered_frames && FileExists(frame_fname))
			do_save = false

		if (do_save)
		{
			RendererGrabDisplayToPicture(g_render, frame_buffer)
			print("StageManager::SaveCurrentFrame() : PictureSaveTGA()")
			PictureSaveTGA(frame_buffer, frame_fname)
//			print("StageManager::SaveCurrentFrame() : ExecuteBatch(ConvertTGAtoPNG())")
//			ExecuteBatch(ConvertTGAtoPNG(idx), "convert_frame.bat")
		}

		frame_idx++
	}

	//----------------------------------
	function	AllocateFrameBuffer()
	//----------------------------------
	{
		frame_buffer = PictureNew()
	}

	//------------------------
	function	OnSetup(scene)
	//------------------------
	{
		keyboard_device = GetInputDevice("keyboard")

		if (g_fixed_step_enabled)
			SceneSetFixedDeltaFrame(scene, (1.0 / fps))

		SceneSetRenderless(scene, true)

		Include("assets/scripts/" + g_story + ".nut")

		emulator_assets = {}
		thread_handler = ThreadHandler()
		audio_mixer	= AudioMixer()

		if (g_save_enabled)
			AllocateFrameBuffer()

		update_function = TTSSetup
	}

	//--------------------
	function	TTSSetup()
	//--------------------
	{
		if (g_demo_mode)
			update_function = CreateTTSTracks
		else
		{
			//	Start Mary TTS (if needed) via a coroutine here
			if (g_tts_mary)
			{
				thread_handler.CreateThread(ThreadLaunchMaryTTS)
				update_function  = AwaitMaryTTSLaunch
			}
			else
				update_function = CreateTTSTracks
		}
	}

	//------------------------------
	function	AwaitMaryTTSLaunch()
	//------------------------------
	{
		if (!WaitForTimer("maryttslaunch", Sec(10.0)))
		{
			//	Speech synthesis & lipsync extraction
			update_function = CreateTTSTracks
		}
	}

	//---------------------------
	function	CreateTTSTracks()
	//---------------------------
	{
		local	_text_array = []
		
		foreach(clip in stage_script)
			if ("text" in clip)
				_text_array.append(clip.text)

		if (!g_demo_mode)
			TextToSpeech(_text_array)

		update_function = TrackerSetup
	}

	//-------------------------
	function	LoadEmulators()
	//-------------------------
	{
		print("StageManager::LoadEmulators()")

		local	_group_position	=	Vector(0,0,0)

		foreach(_clip in stage_script)
		{
			if ("emulator" in _clip)
			{
				local	emu_fname = _clip.emulator.name
				emu_fname = "assets/games/" + emu_fname + "/scene.nms"
				if (FileExists(emu_fname))
				{
					if (_clip.emulator.name in emulator_assets)
						print("StageManager::LoadEmulator() " + emu_fname + " already loaded!")
					else
					{
						local	emulator_group = SceneLoadAndStoreGroup(g_scene, emu_fname, ImportFlagCamera + ImportFlagObject + ImportFlagLight) // ImportFlagAll & ~ImportFlagGlobals)
						SceneGroupSetup(g_scene, emulator_group)
						//	GroupSetup(emulator_group)

						_group_position.y -= Mtr(50.0)

						local	_emu_items_handler = GroupFindItem(emulator_group, "emulator_handler")
						ItemSetPosition(_emu_items_handler, _group_position)

						//	Add the emulator to the assets group
						emulator_assets.rawset(_clip.emulator.name, emulator_group)

						print("StageManager::LoadEmulator() Succesfully Loaded : " + emu_fname)
					}
				}
				else
					print("StageManager::LoadEmulator() Cannot find : " + emu_fname)
			}
		}
	}

	//-------------------------------------------
	function	HandleSpecialEvent(_current_clip)
	//-------------------------------------------
	{
		print("StageManager::HandleSpecialEvent()")
		if ("event" in _current_clip)
		{
			print("StageManager::HandleSpecialEvent() Loading : " + "assets/" + _current_clip.event)
			local	_item_list = SceneGetItemList(g_scene)
			foreach(_item in _item_list)
				if (ItemGetName(_item) == _current_clip.event)
					ItemGetScriptInstance(_item).EventStart()
		}
	}

	function	HandleFading(_current_clip)
	{
		print("StageManager::HandleFading()")
		if ("fade" in _current_clip)
		{
			local	_ui = SceneGetUI(g_scene)
			switch(_current_clip.fade)
			{
				case "in" :
				case "In" : 
					UISetGlobalFadeEffect(_ui, 1.0)
					UISetCommandList(_ui, "globalfade 1,0;")
					break

				case "out" :
				case "Out" :
					UISetGlobalFadeEffect(_ui, 0.0)
					UISetCommandList(_ui, "globalfade 2,1;")
					break
			}
		}
	}

	//------------------------
	function	TrackerSetup()
	//------------------------
	{
		print("StageManager::TrackerSetup()")

		if (g_tts_mary && !g_demo_mode)
			thread_handler.CreateThread(ThreadStopMaryTTS)

		lip_sync_tracker = LipSyncTrack()
/*			
		//	Load the 3D environment
		assets = SceneLoadAndStoreGroup(g_scene, g_main_scene, ImportFlagAll)
		SceneGroupSetup(g_scene, assets)
		//			GroupSetup(assets)
*/

		LoadEmulators()

		render_stats = RenderingStats()

		start_recording = true
		g_clock = 0.0

		GetNextClip()
		current_clip_duration = lip_sync_tracker.Feed(current_clip)

		camera_tracker = CameraTrack()
		camera_tracker.Feed(current_clip, fps)

		subtitle_tracker = SubtitleTrack()
		subtitle_tracker.Feed(current_clip)

		titler_tracker = VideoTitlerTrack()
		subtitle_tracker.Feed(current_clip)

		video_tracker = VideoTrack()
		video_tracker.Feed(current_clip, fps)

		led_tracker = LedTrack(audio_mixer)
		led_tracker.Feed(current_clip)

		rtt_tracker	= RenderToTextureTracker()
		rtt_tracker.Feed(current_clip, emulator_assets)

		music_tracker = MusicTrack()
		music_tracker.Feed(current_clip)

		HandleSpecialEvent(current_clip)
		HandleFading(current_clip)

//local	_ch = MixerStreamStart(g_mixer, "tmp/radix_tournesol.ogg")
//MixerChannelSetGain(g_mixer, _ch, 0.1)

		update_function = UpdateScript
	}

}

//------------------------ BATCHES ----------------------

//---------------------------------------
function	ConvertTGAtoPNG(frame_number)
//---------------------------------------
{
	local	str = [
				"@Echo off",
				"REM === Generated by GameStart ===",
				"echo Convert TGA to PNG",
				"cd /d " + g_current_path_dos,
				"convert -alpha deactivate tga/frame_" + frame_number + ".tga tga/frame_" + frame_number + ".png",
				"cd tga",
				"del frame_" + frame_number + ".tga"
	]

	return 	str
}
