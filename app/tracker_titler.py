# 
#	File: scripts/subtitles_tracker.nut
#	Author: Astrofra
# 

# Include("scripts/self.ui.nut")

# !
#	@short	SubtitleTrack
#	@author	Astrofra
# 
class	VideoTitlerTrack:

	def __init__(self):
		self.ui						=	0
		self.text					=	""
		self.titler_label			=	0
		self.command					=	0
		self.all_done				=	False
		self.main_sprite				=	0
		self.handler_sprite			=	0

		self.ui = SceneGetUI(g_scene)

		# 	Main window
		self.handler_sprite = UIAddWindow(self.ui, -1, 0, 0, 0, 0)
		
		# 	BG
		bg_texture = ResourceFactoryLoadTexture(g_factory, "self.ui/on_screen_message.png")
		self.main_sprite = UIAddSprite(self.ui, -1, bg_texture, 0, 0, TextureGetWidth(bg_texture), TextureGetHeight(bg_texture))
		child_bg = UIAddSprite(self.ui, -1, bg_texture, 0, 0, TextureGetWidth(bg_texture) * 0.8, TextureGetHeight(bg_texture))
		SpriteSetParent(child_bg, self.main_sprite)
		SpriteSetPosition(child_bg, TextureGetWidth(bg_texture) * -0.8, 0.0)

		# 	Text
		UILoadFont("self.ui/fonts/FuturaBOLD.ttf")
		self.titler_label = Label(self.ui, TextureGetWidth(bg_texture), TextureGetHeight(bg_texture), 0, 0, true, true)
		self.titler_label.label_color = 0xffff00ff
		self.titler_label.font = "FuturaBOLD"
		self.titler_label.font_size = 64
		self.titler_label.drop_shadow = true
		self.titler_label.font_tracking = -1.0
		self.titler_label.font_leading = -1.0
		self.titler_label.label = ""
		self.titler_label.refresh()

		SpriteSetParent(self.titler_label.window, self.main_sprite)
		SpriteSetPivot(self.titler_label.window, 0, 0) # -TextureGetWidth(bg_texture) * 0.5, -TextureGetHeight(bg_texture) * 0.5)
		# local	x,y
		x = (1280.0 - (960.0 / 720.0 * 1280.0)) / 2.0
		y = 960.0 - TextureGetHeight(bg_texture) - 32.0
		SpriteSetPosition(self.main_sprite, x, y)
		SpriteSetOpacity(self.main_sprite, 0.0)

		SpriteSetParent(self.main_sprite, self.handler_sprite)		

	# !
	#	@short	OnUpdate
	#	Called each frame.
	# 
	def Update(self):
		if self.all_done
			return

		if self.command.toupper() == "IN":
				SpriteSetOpacity(self.main_sprite, 0.0)
				SpriteSetOpacity(self.titler_label.window, 0.0)
				SpriteSetPosition(self.handler_sprite, -32, 0)
				SpriteSetPosition(self.titler_label.window, 64, 0)
				WindowSetCommandList(self.main_sprite, "toalpha 1,1;")
				WindowSetCommandList(self.handler_sprite, "toposition 1,0,0;")
				WindowSetCommandList(self.titler_label.window, "toposition 1,0,0+toalpha 3.0,1;")
				self.all_done = True

		if self.command.toupper() == "OUT":
				SpriteSetOpacity(self.main_sprite, 1.0)
				SpriteSetPosition(self.handler_sprite, 0, 0)
				WindowSetCommandList(self.main_sprite, "toalpha 0.35,0;")
				WindowSetCommandList(self.handler_sprite, "toposition 0.35,-16,0;")
				WindowSetCommandList(self.titler_label.window, "toposition 0.5,128,0+toalpha 0.5,0;")
				self.all_done = True


	def GetSubtitleDuration(self):
		print("VideoTitlerTrack::GetSubtitleDuration()")
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
		print("VideoTitlerTrack::Feed()")
		self.all_done = False
		self.command = ""

		if "titler" in _current_clip:
			if "self.text" in _current_clip.titler:
				self.text = _current_clip.titler.self.text
				self.titler_label.label = self.text
				self.titler_label.refresh()

			if "self.command" in _current_clip.titler:
				self.command = _current_clip.titler.self.command
		else:
			self.all_done = True
