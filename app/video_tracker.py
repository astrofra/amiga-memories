# 
#	File: scripts/video_tracker.nut
#	Author: Astrofra
# 

# !
#	@short	VideoTrack
#	@author	Astrofra
# 
class	VideoTrack:

	def __init__(self):
		self.video_tracks = {}
		self.video_slot =	{	screen = "", screen_material_name = "", 
									screen_material = 0, file = "", fps = 60, 
									frame_idx = 0, prev_frame_idx = -1, 
									playing = False	}
		self.default_screen = "monitor_screen"
		self.default_material_name = "assets/monitor_screen.nmm"
		self.default_fps = 60
		# 
		#		local	geo, mat
		#		geo = ItemGetGeometry(SceneFindItem(g_scene, "monitor_screen"))
		#		screen_material = GeometryGetMaterialFromIndex(geo, 0)
		# 

		# 
		#	screen_material		=	0
		#	video_path			=	0
		#	frame_idx			=	0.0
		#	prev_frame_idx		=	-1.0
		#	fps					=	60
		# 


	def Update(self):
		if self.video_tracks == 0 || self.video_tracks.len() == 0:
			return

		for _video_track in self.video_tracks:
			if _video_track.playing:
				_video_track.frame_idx += (g_dt_frame * _video_track.fps)
				if int(_video_track.frame_idx) != _video_track.prev_frame_idx:
					self.ShowVideoFrame(_video_track)

				_video_track.prev_frame_idx = int(_video_track.frame_idx)	


	def ShowVideoFrame(self, _video_track):
		# video_frame, fname
		fname = str(int(_video_track.frame_idx))
		if _video_track.frame_idx < 10:
			fname = "0" + fname
		if _video_track.frame_idx < 100:
			fname = "0" + fname
		if _video_track.frame_idx < 1000:
			fname = "0" + fname
		fname = "png-in/" + _video_track.file + "/" + "frame_" + fname + ".jpg"
		if os.paths.FileExists("tmp/" + fname):
			video_frame = EngineLoadTexture(g_engine, "tmp/" + fname)
			MaterialSetTexture(_video_track.screen_material, 0, video_frame)
		else:
			if os.paths.FileExists("archived_files/" + fname):
				video_frame = EngineLoadTexture(g_engine, "archived_files/" + fname)
				MaterialSetTexture(_video_track.screen_material, 0, video_frame)


	def Feed(self, _current_clip, _fps):
		print("VideoTrack::Feed()")

		# 	By default, we assume that all the existing video tracks
		# 	Are set to "STOP".
		for _video_track in self.video_tracks:
			_video_track.playing = False

		if "video" in _current_clip:
			print("VideoTrack::Feed() Found a 'video' array, len = " + _current_clip.video.len().tostring() + ".")

			for _video_track in _current_clip.video:
				_video_slot_key = ""
				_new_video_slot = clone(self.video_slot)

				if "screen" in _video_track:
					_video_slot_key += _video_track.screen
					_new_video_slot.screen = _video_track.screen
				else:
					_video_slot_key += self.default_screen
					_new_video_slot.screen = _video_track.screen

				_video_slot_key += "_"

				if "screen_material" in _video_track:
					_video_slot_key += _video_track.screen_material
					_new_video_slot.screen_material_name = _video_track.screen_material
				else:
					_video_slot_key += self.default_screen
					_new_video_slot.screen_material_name = _video_track.self.default_material_name

				_video_slot_key += "_"

				if "file" in _video_track:
					_video_slot_key += _video_track.file
					_new_video_slot.file = _video_track.file

					_video_slot_key += "_"

				if "fps" in _video_track:
					_video_slot_key += str(_video_track.fps)
					_new_video_slot.fps = _video_track.fps
				else:
					_video_slot_key += str(self.default_fps)
					_new_video_slot.fps = self.default_fps

				if "frame" in _video_track:
					_new_video_slot.frame_idx = _video_track.frame

# 				_video_slot_key = StringReplace(_video_slot_key, "/", "_")
#				_video_slot_key = _video_slot_key.replace(".", "_")
#				_video_slot_key = _video_slot_key.replace("-", "_")
# 
				_video_slot_key = SHA1(_video_slot_key)
				print("VideoTrack::Feed() : _video_slot_key = " + _video_slot_key)

				if not (_video_slot_key in self.video_tracks):
					print("VideoTrack::Feed() : Creating new video track : " + _video_slot_key)
					geo = ItemGetGeometry(SceneFindItem(g_scene, _new_video_slot.screen))
					_new_video_slot.screen_material = GeometryGetMaterial(geo, _new_video_slot.screen_material_name)	# 	GeometryGetMaterialFromIndex(geo, 0)

					self.video_tracks.rawset(_video_slot_key, _new_video_slot)

				self.video_tracks[_video_slot_key].playing = True				
# 
#			video_path = _current_clip.video
#			fps = _fps
#			if "frame" in _current_clip:
#				frame_idx = _current_clip.frame
		else:
			print("VideoTrack::Feed() : No video found.")

		print("VideoTrack::Feed() Setup " + str(self.video_tracks.len()) + " tracks.")