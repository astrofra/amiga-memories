//	Global_callbacks.nut
print("//	Global_callbacks.nut		//")

//-----------------------------------------------------------------------------------------
function	OnRenderContextChanged()
{
	print("Global callback: OnRenderContextChanged().")
		
	local	current_scene_instance
	current_scene_instance = SceneGetScriptInstance(g_scene)
	
	if	("Refresh" in current_scene_instance)
		current_scene_instance.Refresh()
}

function	OnHardwareButtonPressed(button)
{/*
	print("Global callback: OnHardwareButtonPressed(" + button + ").")
		
	local	current_scene_instance
	current_scene_instance = SceneGetScriptInstance(g_scene)
	
	if	("OnHardwareButtonPressed" in current_scene_instance)
		current_scene_instance.OnHardwareButtonPressed(button)*/
}

function	OnHttpRequestComplete(uid, data)
{
	//print("OnHttpRequestComplete() :  " + uid + " complete.")
	
	if	(g_NetworkManager && "HttpRequestComplete" in g_NetworkManager)
		g_NetworkManager.HttpRequestComplete(uid, data)
}

function	OnHttpRequestError(uid)
{
	print("OnHttpRequestError() :  " + uid + " errored.")

	if	(g_NetworkManager && "HttpRequestError" in g_NetworkManager)
		g_NetworkManager.HttpRequestError(uid)
}
