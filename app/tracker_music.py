# 
#	File: scripts/music_tracker.nut
#	Author: Astrofra
# 

# !
#	@short	MusicTrack
#	@author	Astrofra
# 
class	MusicTrack:

	def __init__(self):
		self.music_channel = MixerChannelLock(g_mixer)
		self.music_path =	0
		self.gain =	1.0
		self.target_gain =	1.0


	def Update(self):
		self.gain += (self.target_gain - self.gain) * g_dt_frame * 2.0
		self.gain = Clamp(self.gain, 0.0, 1.0)
		MixerChannelSetGain(g_mixer, self.music_channel, self.gain)


	def Feed(self, _current_clip):
		print("MusicTrack::Feed()")
		self.music_path = 0

		if "music" in _current_clip:
			print("MusicTrack::Feed() Found 'music' key.")
			if "command" in _current_clip.music:
				print("MusicTrack::Feed() Found 'command' = " + _current_clip.music.command)
				
				if _current_clip.music.command == "FadeOut":
					self.target_gain = 0.0

				if _current_clip.music.command == "Start":
					if "file" in _current_clip.music:
						_filename = "tmp/" + _current_clip.music.file + ".ogg"
						if os.paths.FileExists(_filename):
							_filename = "archived_files/" + _current_clip.music.file + ".ogg"
						if os.paths.FileExists(_filename):
							MixerChannelStartStream(g_mixer, self.music_channel, _filename)
							if "self.gain" in _current_clip.music:
								self.gain = _current_clip.music.self.gain
								self.target_gain = self.gain
								MixerChannelSetGain(g_mixer, self.music_channel, self.gain)
						else:
							print("MusicTrack::Feed() Cannot find file '" + _filename + "'.")
					else:
						print("MusicTrack::Feed() No 'file' key found!")

				if _current_clip.music.command == "Stop":
					MixerChannelStop(g_mixer, self.music_channel)
					break

	def Delete(self):
		print("MusicTrack::Delete()")
		MixerChannelStop(g_mixer, self.music_channel)
		MixerChannelSetGain(g_mixer, self.music_channel, 1.0)
		MixerChannelUnlock(g_mixer, self.music_channel)
