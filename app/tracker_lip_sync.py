# 
#	File: scripts/lipsync_test.nut
#	Author: Astrofra
#

import gs
import os
from globals import *
from compat import *

# Include(g_viseme_set + "phoneme_to_viseme.nut")

# !
#	@short	lipsync_test
#	@author	Astrofra
# 
class LipSyncTrack:

	def __init__(self):
		self.ui = None # SceneGetUI(g_scene)
		self.external_material_list = []

		self.current_clip = 0
		self.text = 0
		self.current_phoneme_index = 0
		self.current_phoneme = 0
		self.lipsync_clock = 0.0
		self.duration = -1.0
		self.all_done = False
		self.current_viseme_sprite = 0
		self.mouth_2d = False
		self.disable_narrator = False
		self.visemes = None

	def LipSyncNutInclude(self, _key):
			global g_story
			_nut_fname = "voice_" + g_story + "_" + _key + ".json"
			print("LipSyncNutInclude() : loading '" + _nut_fname + "'.")

			json_file = None
			if os.path.exists("tmp/" + _nut_fname):
				print("Loading from 'tmp/'")
				json_file = open("tmp/" + _nut_fname)
			else:
				print("Loading from 'archived_files/'")
				json_file = open("archived_files/" + _nut_fname)

			if json_file is not None:
				self.visemes = json.loads(json_file.read())
			else:
				self.visemes = {}

	# !
	#	@short	OnUpdate
	#	Called each frame.
	# 
	def Update(self):
		# _clock = g_clock - self.lipsync_clock

		# if self.all_done:
		# 	return

		# if _clock > self.current_phoneme.last_time:
		# 	self.GetNextPhoneme()
		pass


	def GetNextPhoneme(self):
		if self.current_phoneme_index < len(list_phoneme):
			if self.text != "pause":
				self.current_phoneme = list_phoneme[self.current_phoneme_index]
				# 	print("GetNextPhoneme() : '" + self.current_phoneme.phoneme_type + "'.")
				self.GetVisemeFromPhoneme(self.current_phoneme.phoneme_type)
			else:
				self.current_phoneme = list_phoneme[self.current_phoneme_index]
				self.GetVisemeFromPhoneme("_")

			self.current_phoneme_index += 1
		else:
			# 	print("LipSyncTrack::GetNextPhoneme() All done!")
			self.GetVisemeFromPhoneme("_")
			if self.duration < 0 or g_clock - self.lipsync_clock >= self.duration:
				self.all_done = True


	def GetVisemeFromPhoneme(self, pho):
# 		if ("video" in self.current_clip)	# 	FIX ME!!!
# 			return

		if pho == "_":
			pho = "closed"
		pho = pho.upper()

		if pho in self.visemes:
			vi = self.visemes[pho]

			if self.disable_narrator:
				return

			mouth_tex = EngineLoadTexture(g_engine, g_viseme_set + vi + ".png")

			if self.mouth_2d:
				if self.current_viseme_sprite != 0:
					UIDeleteSprite(self.ui, self.current_viseme_sprite)
		
				self.current_viseme_sprite = UIAddSprite(self.ui, -1, mouth_tex, 10, 10, 150, 150)
				SpriteSetScale(self.current_viseme_sprite, 2, 2)
			else:
				# local	geo, mat
				geo = ItemGetGeometry(SceneFindItem(g_scene, "monitor_screen"))
				mat = GeometryGetMaterialFromIndex(geo, 0)
				MaterialSetTexture(mat, 0, mouth_tex)
				for _mat in self.external_material_list:
					MaterialSetTexture(_mat, 0, mouth_tex)


	def RegisterExternalMaterial(self, _mat):
		self.external_material_list.append(_mat)


	def AddPauseAtEnd(self):
		print("LipSyncTrack::AddPauseAtEnd()")
		_last_idx = len(list_phoneme) - 1
		clip_duration = 0.0
		if _last_idx >= 0:
			list_phoneme[_last_idx].last_time += FixedSecToTick(Sec(1.0))
			clip_duration = list_phoneme[_last_idx].last_time

		return	clip_duration

	# !
	#	@short	OnSetup
	#	Called when the scene is about to be setup.
	# 
	def Feed(self, _current_clip):
		print("LipSyncTrack::Feed()")
		# local	clip_duration, key
		clip_duration = -1.0
		self.duration = -1.0
		self.current_clip = _current_clip
		self.text = self.current_clip['text']
		key = SHA1(self.text)
		self.lipsync_clock = g_clock
		self.all_done = False
		self.current_phoneme_index =	0
		self.current_phoneme =	0

		print("LipSyncTrack::Feed(" + key + ")")
		self.LipSyncNutInclude(key)

		if "self.duration" in _current_clip:
			clip_duration = FixedSecToTick(Sec(_current_clip.self.duration))
			self.duration = clip_duration
		else:
			clip_duration = self.AddPauseAtEnd()

		if "emulator" in _current_clip and not ("narrator_command" in _current_clip.emulator):
			self.disable_narrator = True
		else:
			self.disable_narrator = False

		if self.text != "pause":
			SceneGetScriptInstance(g_scene).audio_mixer.PlaySound("voice_" + g_story + "_" + key + ".ogg", g_clock, "voice_over")

		self.GetNextPhoneme()

		return	clip_duration