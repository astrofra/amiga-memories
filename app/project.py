import os
import gs
from stage_manager import *

# ---------- BEGIN PUBLIC

g_story						=	"dune"
g_enable_audio_output		=	True
g_demo_mode					=	False	# 	Don't (re)generate the voice.
g_french_voice				=	True	# 	Not always available (depends on the TTS System)
g_tts_mary					=	True	# 	If set to False, will default to Windows SAPI5
g_enable_voice_postprocess	=	True	# 	Pitch down the generated voice.
g_save_enabled				=	False
g_skip_rendered_frames		=	False
g_fixed_step_enabled		=	False
g_enable_subtitles			=	False
g_display_fps				=	False
g_current_language			=	"fr"

# ---------- END PUBLIC

g_project_instance			=	0
g_WindowsManager			=	0
g_cursor 					=	0

# ProjectLoadUIFontAliased(g_project, "ui/gui_font.ttf", "gui_font")

g_project_instance		=	0

class ProjectHandler:

	def __init__(self, plus):
		print("ProjectHandler::constructor()")
		self.dispatch = None
		self.story_filename = ""
		self.scene_filename = ""
		self.scene = None
		self.emulator_scene = None
		self.scene_filename = "assets/master_scene/master_scene.scn"
		self.dispatch = self.LoadScene
		self.plus = plus
		self.dt = None

	# 	PUBLIC METHODS
	def PreloadStory(self):
		self.story_filename = "assets/scenes/" + g_story + ".nms"
		self.scene_filename = "scenes/preloader.nms"
		self.dispatch = self.ExitFromCurrentScene

	def PlayStory(self):
		self.scene_filename = self.story_filename
		self.dispatch = self.ExitFromCurrentScene


	def LoadMainMenu(self):
		self.scene_filename = "scenes/main_menu_screen.nms"
		self.dispatch = self.ExitFromCurrentScene

	# 	PRIVATE	METHODS
	def OnUpdate(self, dt):
		# print("ProjectHandler:OnUpdate(), calling '" + str(self.dispatch) + "'.")
		self.dt = dt
		self.dispatch()

	def OnSetup(self):
		# g_project_instance = ProjectGetScriptInstance(project)
		global g_project_instance
		g_project_instance = self
		print("ProjectHandler::OnSetup()")

	def SceneUpdate(self):
		if self.scene is not None:
			self.plus.UpdateScene(self.scene, self.dt)

	def LoadScene(self):
		if self.scene is not None:
			# ProjectUnloadScene(project, self.scene)
			self.scene.Clear()
			self.scene = None

		if os.path.exists(self.scene_filename):
			print("ProjectHandler::LoadScene('" + self.scene_filename + "')")
			# self.scene = ProjectInstantiateScene(project, self.scene_filename)
			self.scene = self.plus.NewScene()
			self.scene.Load(self.scene_filename, gs.SceneLoadContext(self.plus.GetRenderSystem()))
			self.plus.AddCamera(self.scene, gs.Matrix4.TranslationMatrix((0, 1, -2.5)))
			self.dispatch = self.WaitTilSceneIsReady
			# 	g_WindowsManager.current_ui = SceneGetUI(ProjectSceneGetInstance(self.scene))
		else:
			print("ProjectHandler::LoadNextTest() Could not find '" + self.scene_filename + "'.")
			self.dispatch = self.MainUpdate


	def ExitFromCurrentScene(self):
		# UISetCommandList(SceneGetUI(g_scene), "globalfade 0.25,1.0;")
		self.dispatch = self.WaitEndOfCommandList


	def WaitEndOfCommandList(self):
		# if UIIsCommandListDone(SceneGetUI(g_scene)):
		# 	self.dispatch = self.LoadScene
		self.dispatch = self.LoadScene

	def WaitTilSceneIsReady(self):
		self.plus.UpdateScene(self.scene, self.dt)
		if self.scene.IsReady():
			print("ProjectHandler::WaitTilSceneIsReady() Scene is ready!")
			self.dispatch = self.SceneUpdate
	
	def MainUpdate(self):
		# Purposedly do nothing
		pass