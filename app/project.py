import stage_manager

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

class	ProjectHandler:
	self.dispatch = 0
	self.story_filename = ""
	self.scene_filename = ""
	self.scene = 0
	self.emulator_scene = 0

	# 	PUBLIC METHODS
	def PreloadStory(self):
		self.story_filename = "assets/scenes/" + g_story + ".nms"
		self.scene_filename = "scenes/preloader.nms"
		self.dispatch = self.ExitFromCurrentScene


	def PlayStory(self):
		self.scene_filename = self.story_filename
		self.dispatch = ExitFromCurrentScene


	def LoadMainMenu(self):
		self.scene_filename = "scenes/main_menu_screen.nms"
		self.dispatch = ExitFromCurrentScene


	# 	PRIVATE	METHODS
	def OnUpdate(self, project):
		self.dispatch(project)


	def OnSetup(self, project):
		g_project_instance = ProjectGetScriptInstance(project)
		print("ProjectHandler::OnSetup()")

	def LoadScene(self, project):
		if self.scene is not None:
			ProjectUnloadScene(project, self.scene)

		if os.path.FileExists(self.scene_filename):
			print("ProjectHandler::LoadScene('" + self.scene_filename + "')")
			self.scene = ProjectInstantiateScene(project, self.scene_filename)
			ProjectAddLayer(project, self.scene, 0.5)
			if (g_WindowsManager != 0)
				g_WindowsManager.current_ui = SceneGetUI(ProjectSceneGetInstance(self.scene))
		else:
			error("ProjectHandler::LoadNextTest() Could not find '" + self.scene_filename + "'.")

		self.dispatch = MainUpdate


	def ExitFromCurrentScene(self, project):
		UISetCommandList(SceneGetUI(g_scene), "globalfade 0.25,1.0;")
		self.dispatch = WaitEndOfCommandList


	def WaitEndOfCommandList(self, project):
		if UIIsCommandListDone(SceneGetUI(g_scene)):
			self.dispatch = LoadScene

	
	def MainUpdate(self, project):
		pass

	def __init__(self):
		print("ProjectHandler::constructor()")
		if True:
			self.scene_filename = "assets/scenes/" + g_story + ".nms"
		else:
			self.scene_filename = "scenes/main_menu_screen.nms"
		self.dispatch =  LoadScene