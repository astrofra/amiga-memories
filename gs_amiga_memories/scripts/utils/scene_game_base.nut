/*
	File: scripts/utils/scene_game.nut
	Author: P. Blanche - F. Gutherz
*/

/*!
	@short	SceneGame
	@author	P. Blanche - F. Gutherz
*/
class	SceneGameBase
{
	/*!
		@short	OnSetup
		Called when the scene is about to be setup.
	*/
	function	OnSetup(scene)
	{
		//	UI
		if ("g_cursor" in getroottable())
		{
			g_cursor = CCursor()
			g_cursor.Setup()
			g_cursor.ui = SceneGetUI(scene)
			g_WindowsManager = WindowsManager()
			g_WindowsManager.current_ui = SceneGetUI(scene)
		}

		//	Physic
		SceneSetGravity(scene, Vector(0,0,0))
	}

	function	OnUpdate(scene)
	{
		if ("g_cursor" in getroottable())
			if (g_cursor != 0)	g_cursor.Update()
	}
}
