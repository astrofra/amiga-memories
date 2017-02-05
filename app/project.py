import os
import gs
from stage_manager import *
from globals import *

# ProjectLoadUIFontAliased(g_project, "ui/gui_font.ttf", "gui_font")

class ProjectHandler:

	def __init__(self, plus):
		print("ProjectHandler::constructor()")
		self.dispatch = None
		self.story_filename = ""
		self.scene_filename = ""
		self.scene = None
		self.scene_manager = None
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
			if self.scene_manager is not None:
				self.scene_manager.OnUpdate(self.dt)
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
			self.scene_manager = StageManager()
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
			self.scene_manager.OnSetup(self.scene)
			self.dispatch = self.SceneUpdate
	
	def MainUpdate(self):
		# Purposedly do nothing
		pass