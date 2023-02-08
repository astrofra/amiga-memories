/*
*/

Include("scripts/stage_manager.nut")
Include("scripts/interface/windows_manager.nut")
Include("scripts/utils/cursor.nut")
Include("scripts/utils/rendering_stats.nut")

//---------- BEGIN PUBLIC

g_story						<-	"gng"
g_enable_audio_output		<-	true
g_demo_mode					<-	true	//	Don't (re)generate the voice.
g_french_voice				<-	true	//	Not always available (depends on the TTS System)
g_tts_mary					<-	true	//	If set to false, will default to Windows SAPI5
g_enable_voice_postprocess	<-	true	//	Pitch down the generated voice.
g_save_enabled				<-	false
g_skip_rendered_frames		<-	false
g_fixed_step_enabled		<-	false
g_enable_subtitles			<-	true
g_display_fps				<-	false
g_current_language			<-	"fr"

//---------- END PUBLIC

g_project_instance			<-	0
g_WindowsManager			<-	0
g_cursor 					<-	0

ProjectLoadUIFontAliased(g_project, "ui/gui_font.ttf", "gui_font")

g_project_instance		<-	0

class	ProjectHandler
{
	dispatch				=	0
	story_filename			=	""
	scene_filename			=	""
	scene					=	0
	emulator_scene			=	0

	//	PUBLIC METHODS

	function	PreloadStory()
	{
		story_filename = "assets/scenes/" + g_story + ".nms"
		scene_filename = "scenes/preloader.nms"
		dispatch = ExitFromCurrentScene
	}

	function	PlayStory()
	{
		scene_filename = story_filename
		dispatch = ExitFromCurrentScene
	}

	function	LoadMainMenu()
	{
		scene_filename = "scenes/main_menu_screen.nms"
		dispatch = ExitFromCurrentScene
	}

	//	PRIVATE	METHODS

	function	OnUpdate(project)
	{
		dispatch(project)
	}

	function	OnSetup(project)
	{
		g_project_instance = ProjectGetScriptInstance(project)
		print("ProjectHandler::OnSetup()")
	}

	function	LoadScene(project)
	{
		if (scene != 0)	ProjectUnloadScene(project, scene)

		if (FileExists(scene_filename))
		{
			print("ProjectHandler::LoadScene('" + scene_filename + "')")
			scene = ProjectInstantiateScene(project, scene_filename)
			ProjectAddLayer(project, scene, 0.5)
			if (g_WindowsManager != 0)
				g_WindowsManager.current_ui = SceneGetUI(ProjectSceneGetInstance(scene))
		}
		else
			error("ProjectHandler::LoadNextTest() Could not find '" + scene_filename + "'.")

		dispatch = MainUpdate
	}

	function	ExitFromCurrentScene(project)
	{
		UISetCommandList(SceneGetUI(g_scene), "globalfade 0.25,1.0;")
		dispatch = WaitEndOfCommandList
	}

	function	WaitEndOfCommandList(project)
	{
		if (UIIsCommandListDone(SceneGetUI(g_scene)))
			dispatch = LoadScene
	}
	
	function	MainUpdate(project)
	{
	}
	
	constructor()
	{
		print("ProjectHandler::constructor()")
		if (1)
			scene_filename = "assets/scenes/" + g_story + ".nms"
		else
			scene_filename = "scenes/main_menu_screen.nms"
		dispatch =  LoadScene
	}
}