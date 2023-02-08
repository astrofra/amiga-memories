/*
	File: scripts/mary_tts.nut
	Author: Astrofra
*/

//-----------------------------------
function	ThreadLaunchMaryTTS(scene)
//-----------------------------------
{
	print("ThreadLaunchMaryTTS() : begin.")
	ExecuteBatch(LaunchMaryTTS(), "launch_mary_tts.bat", "RunInBackground")
	print("ThreadLaunchMaryTTS() : end.")
}

//----------------------------------
function	ThreadStopMaryTTS(scene)
//----------------------------------
{
	print("ThreadStopMaryTTS() : begin.")
	system(g_current_path_engine + "kill_mary_tts.bat")
	print("ThreadStopMaryTTS() : end.")
}