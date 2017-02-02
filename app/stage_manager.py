#
#	File: scripts/stage_manager.nut
#	Author: Astrofra
#

#
#	@short	StageManager
#	@author	Astrofra
#

# Include("assets/scripts/g_stage_script.nut")
# Include("scripts/narrator.nut")

# Include("scripts/trackers/lip_sync_tracker.nut")
# Include("scripts/trackers/camera_tracker.nut")
# Include("scripts/trackers/subtitles_tracker.nut")
# Include("scripts/trackers/titler_tracker.nut")
# Include("scripts/trackers/video_tracker.nut")
# Include("scripts/trackers/led_tracker.nut")
# Include("scripts/trackers/rtt_tracker.nut")
# Include("scripts/trackers/music_tracker.nut")

# Include("scripts/audio_mixer.nut")
# Include("scripts/thread_handler.nut")
# Include("scripts/timers.nut")
# Include("scripts/mary_tts.nut")
# Include("scripts/paths.nut")
# Include("scripts/command_line.nut")

import gs

def	FixedSecToTick(s):
	if g_fixed_step_enabled:
		return 10000.0 * s
	else:
		return SecToTick(s)

def	SceneGroupSetup(scene, group):
	pass
	# local	items = GroupGetItemList(group)
	# foreach (item in items)
	# 	ItemRenderSetup(item, g_factory)

class	StageManager:

	def __init__(self):
		self.fps = 30.0

		self.current_clip = 0
		self.clip_idx = 0
		self.current_clip_duration = 0.0

		self.lip_sync_tracker = 0
		self.camera_tracker = 0
		self.subtitle_tracker = 0
		self.titler_tracker = 0
		self.video_tracker = 0
		self.led_tracker = 0
		self.rtt_tracker = 0
		self.music_tracker = 0

		self.audio_mixer = 0

		self.all_done = False

		self.update_function = 0
		self.wait_clock = 0

		# self.assets = 0
		self.emulator_assets = 0

		# 	TGA Save
		self.start_recording = False
		self.frame_buffer = 0
		self.frame_idx = 0

		self.render_stats = 0

		self.thread_handler = 0

	def	OnRenderUser(self):
		self.render_stats.RenderUser()

	def	OnUpdate(self):
		# print("g_clock = " + g_clock)
		if g_save_enabled and not self.all_done:
			self.SaveCurrentFrame()

		self.thread_handler.Update()

		if self.update_function != 0:
			self.update_function()

	def LoadStageScript(self, filename):
		global g_stage_script
		if os.path.exists(filename):
			print("StageManager::LoadStageScript(), loading " + filename)
			json_file = open(filename)
			g_stage_script = json.loads(json_file.read())[0]
		else:
			print("StageManager::LoadStageScript(), cannot find file " + filename)

	def	SaveEditList(self):
		if not g_demo_mode:
			self.audio_mixer.SaveEditListToFile("final_mix.edl")
		self.update_function = QuitApp

	def	QuitApp(self):
		self.update_function = 0
		self.audio_mixer.Delete()
		self.music_tracker.Delete()
		# ProjectGetScriptInstance(g_project).LoadMainMenu()

	def	UpdateScript(self):
		self.lip_sync_tracker.Update()
		self.camera_tracker.Update()
		self.subtitle_tracker.Update()
		self.video_tracker.Update()
		self.led_tracker.Update()
		self.rtt_tracker.Update()
		self.titler_tracker.Update()
		self.music_tracker.Update()
		self.render_stats.Update()

		if self.lip_sync_tracker.all_done and self.rtt_tracker.all_done:
			self.GetNextClip()
			if not self.all_done:
				self.current_clip_duration = self.lip_sync_tracker.Feed(self.current_clip)
				self.camera_tracker.Feed(self.current_clip, fps)
				self.subtitle_tracker.Feed(self.current_clip)
				self.titler_tracker.Feed(self.current_clip)
				self.video_tracker.Feed(self.current_clip, fps)
				self.led_tracker.Feed(self.current_clip)
				self.rtt_tracker.Feed(self.current_clip, self.emulator_assets)
				self.music_tracker.Feed(self.current_clip)
				self.HandleSpecialEvent(self.current_clip)
				self.HandleFading(self.current_clip)

	def	GetNextClip(self):
		print("StageManager::GetNextClip()")
		global g_stage_script

		if self.clip_idx < g_stage_script.len():
			current_clip = clone(g_stage_script[self.clip_idx])
			self.clip_idx += 1
		else:
			self.all_done = True
			self.update_function = self.SaveEditList

		return 	self.all_done

	def	SaveCurrentFrame(self):
		if not self.start_recording:
			return

		print("StageManager::SaveCurrentFrame(" + frame_idx + ")")

		idx = str(frame_idx)
		if frame_idx < 10:
			idx = "0" + idx
		if frame_idx < 100:
			idx = "0" + idx
		if frame_idx < 1000:
			idx = "0" + idx

		do_save = True
		frame_fname = "tmp/tga/frame_" + str(idx) + ".tga"

		if g_skip_rendered_frames and os.path.exists(frame_fname):
			do_save = False

		if do_save:
			# RendererGrabDisplayToPicture(g_render, frame_buffer)
			print("StageManager::SaveCurrentFrame() : PictureSaveTGA()")
			# PictureSaveTGA(frame_buffer, frame_fname)
# 			print("StageManager::SaveCurrentFrame() : ExecuteBatch(ConvertTGAtoPNG())")
# 			ExecuteBatch(ConvertTGAtoPNG(idx), "convert_frame.bat")

		frame_idx += 1

	def	AllocateFrameBuffer(self):
		frame_buffer = None # PictureNew()

	def	OnSetup(self, scene):
		if g_fixed_step_enabled:
			SceneSetFixedDeltaFrame(scene, (1.0 / fps))

		# SceneSetRenderless(scene, True)

		self.LoadStageScript("scripts/" + g_story + ".json")

		self.emulator_assets = {}
		self.thread_handler = ThreadHandler()
		self.audio_mixer	= AudioMixer()

		if g_save_enabled:
			self.AllocateFrameBuffer()

		self.update_function = self.TTSSetup

	def	TTSSetup(self):
		if g_demo_mode:
			self.update_function = self.CreateTTSTracks
		else:
			# 	Start Mary TTS (if needed) via a coroutine here
			if g_tts_mary:
				self.thread_handler.CreateThread(ThreadLaunchMaryTTS)
				self.update_function  = self.AwaitMaryTTSLaunch
			else:
				self.update_function = self.CreateTTSTracks

	def AwaitMaryTTSLaunch(self):
		if not WaitForTimer("maryttslaunch", Sec(10.0)):
			# 	Speech synthesis & lipsync extraction
			self.update_function = self.CreateTTSTracks

	def CreateTTSTracks(self):
		global g_stage_script
		_text_array = []
		
		for clip in g_stage_script:
			if "text" in clip:
				_text_array.append(clip.text)

		if not g_demo_mode:
			TextToSpeech(_text_array)

		self.update_function = self.TrackerSetup

	def	LoadEmulators(self):
		print("StageManager::LoadEmulators()")
		global g_stage_script

		# _group_position	= gs.Vector3(0,0,0)

		# for _clip in g_stage_script:
		# 	if "emulator" in _clip:
		# 		emu_fname = _clip.emulator.name
		# 		emu_fname = "assets/games/" + emu_fname + "/scene.nms"
		# 		if os.path.exists(emu_fname):
		# 			if _clip.emulator.name in self.emulator_assets:
		# 				print("StageManager::LoadEmulator() " + emu_fname + " already loaded!")
		# 			else:
		# 				emulator_group = SceneLoadAndStoreGroup(g_scene, emu_fname, ImportFlagCamera + ImportFlagObject + ImportFlagLight) #  ImportFlagAll & ~ImportFlagGlobals)
		# 				SceneGroupSetup(g_scene, emulator_group)
		# 				# 	GroupSetup(emulator_group)

		# 				_group_position.y -= Mtr(50.0)

		# 				_emu_items_handler = GroupFindItem(emulator_group, "emulator_handler")
		# 				ItemSetPosition(_emu_items_handler, _group_position)

		# 				# 	Add the emulator to the assets group
		# 				self.emulator_assets.rawset(_clip.emulator.name, emulator_group)

		# 				print("StageManager::LoadEmulator() Succesfully Loaded : " + emu_fname)
		# 		else:
		# 			print("StageManager::LoadEmulator() Cannot find : " + emu_fname)

	def	HandleSpecialEvent(self, _current_clip):
		print("StageManager::HandleSpecialEvent()")
		if "event" in _current_clip:
			print("StageManager::HandleSpecialEvent() Loading : " + "assets/" + _current_clip.event)
			# _item_list = SceneGetItemList(g_scene)
			# for _item in _item_list:
			# 	if ItemGetName(_item) == _current_clip.event:
			# 		ItemGetScriptInstance(_item).EventStart()

	def	HandleFading(self, _current_clip):
		print("StageManager::HandleFading()")
		if "fade" in _current_clip:
			_ui = SceneGetUI(g_scene)

			if _current_clip.fade.toupper() == "IN":
				UISetGlobalFadeEffect(_ui, 1.0)
				UISetCommandList(_ui, "globalfade 1,0;")

			if _current_clip.fade.toupper() == "OUT":
					UISetGlobalFadeEffect(_ui, 0.0)
					UISetCommandList(_ui, "globalfade 2,1;")

	# ------------------------
	def	TrackerSetup(self):
	# ------------------------
		print("StageManager::TrackerSetup()")

		if g_tts_mary and not g_demo_mode:
			self.thread_handler.CreateThread(ThreadStopMaryTTS)

		self.lip_sync_tracker = LipSyncTrack()
#			
#		# 	Load the 3D environment
#		self.assets = SceneLoadAndStoreGroup(g_scene, g_main_scene, ImportFlagAll)
#		SceneGroupSetup(g_scene, self.assets)
#		# 			GroupSetup(self.assets)
		self.LoadEmulators()

		self.render_stats = RenderingStats()

		self.start_recording = True
		g_clock = 0.0

		self.GetNextClip()
		self.current_clip_duration = self.lip_sync_tracker.Feed(self.current_clip)

		self.camera_tracker = CameraTrack()
		self.camera_tracker.Feed(self.current_clip, fps)

		self.subtitle_tracker = SubtitleTrack()
		self.subtitle_tracker.Feed(self.current_clip)

		self.titler_tracker = VideoTitlerTrack()
		self.titler_tracker.Feed(self.current_clip)

		self.video_tracker = VideoTrack()
		self.video_tracker.Feed(self.current_clip, fps)

		self.led_tracker = LedTrack(self.audio_mixer)
		self.led_tracker.Feed(self.current_clip)

		self.rtt_tracker	= RenderToTextureTracker()
		self.rtt_tracker.Feed(self.current_clip, self.emulator_assets)

		self.music_tracker = MusicTrack()
		self.music_tracker.Feed(self.current_clip)

		self.HandleSpecialEvent(self.current_clip)
		self.HandleFading(self.current_clip)

# local	_ch = MixerStreamStart(g_mixer, "tmp/radix_tournesol.ogg")
# MixerChannelSetGain(g_mixer, _ch, 0.1)

		self.update_function = self.UpdateScript

# # ------------------------ BATCHES ----------------------

# # ---------------------------------------
# function	ConvertTGAtoPNG(frame_number)
# # ---------------------------------------
# {
# 	local	str = [
# 				"@Echo off",
# 				"REM === Generated by GameStart ===",
# 				"echo Convert TGA to PNG",
# 				"cd /d " + g_current_path_dos,
# 				"convert -alpha deactivate tga/frame_" + frame_number + ".tga tga/frame_" + frame_number + ".png",
# 				"cd tga",
# 				"del frame_" + frame_number + ".tga"
# 	]

# 	return 	str
# }
