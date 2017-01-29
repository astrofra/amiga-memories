# 
# 	File: scripts/subtitles_tracker.nut
# 	Author: Astrofra
# 

# Include("scripts/self.ui.nut")

# !
#	@short	SubtitleTrack
#	@author	Astrofra
# 
class	SubtitleTrack:

	def __init__(self):
		self.text =	0
		self.current_sub_index =	0
		self.current_sub =	0
		self.subtitle_clock =	0.0
		self.all_done =	False
		self.subtitle_label =	0

		self.ui = SceneGetUI(g_scene)
		en_font = UILoadFont("self.ui/fonts/FuturaLight.ttf")
		jp_font = UILoadFont("self.ui/fonts/MSGOTHIC.TTC")
		UIFontSetFallback(en_font, jp_font)

		self.list_sub = []
		self.subtitle_label = Label(self.ui, 1280, 128, 1280 * 0.5, 960 - (128 * 0.75), True, True)
		self.subtitle_label.label_color = 0xffff00ff
		self.subtitle_label.font = "FuturaLight"
		self.subtitle_label.font_size = 64
		self.subtitle_label.drop_shadow = True
		self.subtitle_label.font_tracking = -1.0
		self.subtitle_label.font_leading = -1.0
		self.subtitle_label.label = ""
		self.subtitle_label.refresh()		

	# !
	#	@short	OnUpdate
	#	Called each frame.
	# 
	def Update(self):
		_clock = g_clock - self.subtitle_clock
		if self.all_done:
			return

		if _clock > self.current_sub.last_time:
			self.GetNextSub()


	def GetNextSub(self):
		print("LipSyncTrack::GetNextSub()")
		if self.current_sub_index < self.list_sub.len():
			if self.text != "pause":
				self.current_sub = self.list_sub[self.current_sub_index]
				self.DisplaySub(self.current_sub.self.text)
			else:
				self.DisplaySub("")

			self.current_sub_index += 1
		else:
			self.subtitle_label.label = ""
			self.subtitle_label.refresh()
			self.all_done = True


	def DisplaySub(self, _str):
		print("SubtitleTrack::DisplaySub(" + _str + ")")
		self.subtitle_label.label = _str
		if g_enable_subtitles:
			self.subtitle_label.refresh()

	def GetSubtitleDuration(self):
		print("SubtitleTrack::GetSubtitleDuration()")
		_last_idx = list_phoneme.len() - 1
		clip_duration = 0.0
		if _last_idx >= 0:
			list_phoneme[_last_idx].last_time += FixedSecToTick(Sec(0.5))
			clip_duration = list_phoneme[_last_idx].last_time

		return	clip_duration

	# !
	#	@short	OnSetup
	#	Called when the scene is about to be setup.
	# 
	def Feed(self, _current_clip):
		print("SubtitleTrack::Feed()")
		clip_duration = -1
		self.text = _current_clip.self.text
		key = SHA1(self.text)
		self.subtitle_clock = g_clock
		self.all_done = False
		LipSyncNutInclude(key)
		clip_duration = self.GetSubtitleDuration()
		self.list_sub = []
		self.current_sub_index = 0

		if self.text != "pause":
			if not ("sub" in _current_clip):
				self.all_done = True
				return

			print("SubtitleTrack::Feed() subtitle self.text = " + self.text)

			sub_first_time = 0.0 
			sub_last_time = 0.0
			total_sub_len = 0

			# 	Fallback on English is the current language is not available
			_language = "en"
			if g_current_language in _current_clip.sub:
				_language = g_current_language
				if _language == "jp":
					self.subtitle_label.font_size = 42
			else:
				_language = "en"
				self.subtitle_label.font_size = 64

			# 	Global sub length for this clip
			for sub in _current_clip.sub[_language]:
				total_sub_len += sub.len()

			for sub in _current_clip.sub[_language]:
				sub_duration = int(clip_duration * sub.len() / total_sub_len)
				sub_last_time += sub_duration
				self.list_sub.append({self.text = sub, first_time = sub_first_time, last_time = sub_last_time})
				print(" [first_time, last_time = " + sub_first_time + ", " + sub_last_time + "]")
				sub_first_time = sub_last_time

		self.GetNextSub()
		return	clip_duration