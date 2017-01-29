# 
#	File: camera_tracker.py
#	Author: Astrofra
# 

# !
#	@short	CameraTrack
#	@author	Astrofra
# 
class	CameraTrack:

	def __init__(self):
		self.camera_list = {}
		self.camera_item = 0
		self.prev_camera_item = 0
		self.camera_motion = 0
		self.speed = Mtr(0.4) #Meters
		self.default_speed = Mtr(0.4) #Meters
		self.fps = 30.0


	def Update(self):
		if (self.camera_motion != 0)
			this[self.camera_motion]()


	def Feed(_current_clip, fps = 30.0):
		if "camera" in _current_clip:
			_camera_track = _current_clip.camera
			_clip_duration = self.GetSubtitleDuration()

			self.camera_item = SceneFindItem(g_scene, _camera_track.name)
			SceneSetCurrentCamera(g_scene, ItemCastToCamera(self.camera_item))

			# 	If the camera was not accessed before, store its position & rotation
			if not (_camera_track.name in self.camera_list):
				self.camera_list.rawset(_camera_track.name, {position = 0, rotation = 0})
				self.camera_list[_camera_track.name].position = ItemGetPosition(self.camera_item)
				self.camera_list[_camera_track.name].rotation = ItemGetRotation(self.camera_item)
			else:
				# 	Otherwise, 
				# 	If the camera changed since the last feed, reset it
				if ItemGetName(self.camera_item) != ItemGetName(self.prev_camera_item):
					ItemSetPosition(self.camera_item, self.camera_list[_camera_track.name].position)
					ItemSetRotation(self.camera_item, self.camera_list[_camera_track.name].rotation)

			if "self.speed" in _camera_track:
				self.speed = _camera_track.self.speed
			else:
				self.speed = self.default_speed

			self.camera_motion = _camera_track.motion

			self.prev_camera_item = self.camera_item
		else:
			self.camera_motion = 0


	# 	Public Camera Motions
	def Idle(self):
		pass


	def DollyFront(self):
		self.pDolly(1.0)


	def DollyBack(self):
		self.pDolly(-1.0)0


	def PanRight(self):
		self.pPan(1.0)


	def PanLeft(self):
		self.pPan(-1.0)


	def PanUp(self):
		self.pPanV(1.0)


	def PanDown(self):
		self.pPanV(1.0)


	# 	Private Camera Motions
	def pDolly(self, direction):
		_front = ItemGetMatrix(self.camera_item).GetFront()
		_pos = ItemGetPosition(self.camera_item)
		_pos += _front.Scale(self.speed / self.fps * direction * g_dt_frame)
		ItemSetPosition(self.camera_item, _pos)


	def pPan(self, direction):
		_front = ItemGetMatrix(self.camera_item).GetRight()
		_pos = ItemGetPosition(self.camera_item)
		_pos += _front.Scale(self.speed / self.fps * direction * g_dt_frame)
		ItemSetPosition(self.camera_item, _pos)


	def pPanV(self, direction):
		_front = ItemGetMatrix(self.camera_item).GetUp()
		_pos = ItemGetPosition(self.camera_item)
		_pos += _front.Scale(self.speed / self.fps * direction * g_dt_frame)
		ItemSetPosition(self.camera_item, _pos)


	def GetSubtitleDuration(self)
		print("SubtitleTrack::GetSubtitleDuration()")
		_last_idx = list_phoneme.len() - 1
		clip_duration = 0.0
		if _last_idx >= 0:
			list_phoneme[_last_idx].last_time += FixedSecToTick(Sec(0.5))
			clip_duration = list_phoneme[_last_idx].last_time

		return	clip_duration