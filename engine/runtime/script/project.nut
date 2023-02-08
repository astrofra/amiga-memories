/*
	nEngine	SQUIRREL binding API.
	Copyright 2005~2008 Emmanuel Julien.
*/

/*
	Load a scene and setup all of its resources.
*/
function    ProjectSceneFromFile(scene, file)
{
	local   r = SceneFromFile(scene, file)
	if  (r)
		EngineSetupAllResources(g_engine)
	return r
}
