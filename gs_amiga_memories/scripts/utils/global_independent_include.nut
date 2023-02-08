// this file is to set properly and only once global values
// use the global_setup and global_update function once

Include ("scripts/utils/utils.nut")

root_table <- getroottable()

// the current global scene
if(!("g_global_scene" in root_table))
	g_global_scene <- 0

function	g_scene{return g_global_scene;}

// load the translator
if(!("g_translation_db" in root_table))
	Include("scripts/locale/locale_function.nut")

// load the cursor
if(!("g_cursor" in root_table))
{	
	Include("scripts/utils/cursor.nut")
	g_cursor <- CCursor()
}

// load the device control manager
if(!("g_control_device_manager" in root_table))
{	
	Include("scripts/control_device_manager.nut")
	g_control_device_manager <- ControlDeviceManager()
}

// load the g_SituationManager
if(!("g_SituationManager" in root_table))
{	
	Include("scripts/situation_manager.nut")
	g_SituationManager <- SituationManager()
}

// load the g_WindowsManager
if(!("g_WindowsManager" in root_table))
{	
	Include("scripts/interface/windows_manager.nut")
	g_WindowsManager <- WindowsManager()
}

// load the g_CarCamera
if(!("g_CarCamera" in root_table))
{	
	Include("scripts/car_camera.nut")
	g_CarCamera <- CarCamera()
}

// load the g_ValueRecorder
if(!("g_ValueRecorder" in root_table))
{	
	Include("scripts/value_recorder.nut")
	g_ValueRecorder <- ValueRecorder()
}

// load the g_SoundManager
if(!("g_SoundManager" in root_table))
{	
	Include("scripts/sound_manager.nut")
	g_SoundManager <- SoundManager()
}

// load the g_DboxManager
if(!("g_DboxManager" in root_table))
{	
	Include("scripts/dbox_manager.nut")
	g_DboxManager <- DboxManager()
}

// load the g_PathManager
if(!("g_PathManager" in root_table))
{	
	Include("scripts/path_manager.nut")
	g_PathManager <- PathManager()
}

// load the g_Debug2dManager
if(!("g_Debug2dManager" in root_table))
{	
	Include("scripts/utils/debug_2d_manager.nut")
	g_Debug2dManager <- Debug2dManager()
}

// load the g_AIManager
if(!("g_AIManager" in root_table))
{	
	Include("scripts/ai/ai_manager.nut")
	g_AIManager <- AIManager()
}

// load g_NetworkManager
if(!("g_NetworkManager" in root_table))
{	
	Include("scripts/utils/network_manager.nut")
	g_NetworkManager <- NetworkManager()
}

// load g_AndroidInterfaceConnection
if(!("g_AndroidInterfaceConnection" in root_table))
{	
	Include("scripts/interface/android_interface_connection.nut")
	g_AndroidInterfaceConnection <- android_interface_connection()
}
	
// load the g_SimuFont
if(!("g_SimuFont" in root_table))
{	
	ProjectLoadUIFontAliased(g_project, "ui/gui_font.ttf", "gui_font")
	g_SimuFont <- ResourceFactoryLoadRasterFont(g_factory, "ui/profont.nml", "ui/profont")
}

// load the deactivation system, allow deactivate far away
if(!("g_DeactivationSystem" in root_table))
{	
	Include("scripts/deactivation_system.nut")
	g_DeactivationSystem <- DeactivationSystem()
}

// load the splash prain particle manager
if(!("g_RainSplashParticlesManager" in root_table))
{	
	Include("scripts/utils/rainsplashparticlesmanager.nut")
	g_RainSplashParticlesManager <- RainSplashParticlesManager()
}

	
if(!("g_BilanAccident" in root_table))	
	g_BilanAccident <- 0

if(!("g_car_instance" in root_table))	
	g_car_instance <- 0

// do the setup only once
if(!("g_GlobalSetupOnce" in root_table))
	g_GlobalSetupOnce <- false
	
function GlobalSetup()
{	
	// setup cursor
	g_cursor.Setup()

	g_DeactivationSystem.Setup()

	g_RainSplashParticlesManager.Setup()

	if(g_GlobalSetupOnce)
		return

	g_NetworkManager.Setup()
	
	g_SoundManager.Setup()
		
	g_GlobalSetupOnce = true
	
	//setup control device manager	
	g_control_device_manager.SetupConnectedDeviceList()
			
	g_control_device_manager.LoadCurrentControlDeviceSettings()
	
	// setup the windows manager
	g_WindowsManager.Setup()

	// setup the dbox manager
	g_DboxManager.Setup()

	//setup and load the path
	g_PathManager.Setup()

	
}

function GlobalUpdate()
{
	// update cursor
	g_cursor.Update()	
	
	//update control device manager	
	g_control_device_manager.UpdateAllDevices()
	
	// update the scenario
	g_SituationManager.Update()
	
	// update the mirror of the car
	if(g_car_instance && g_car_instance.car_mirror && 
		!g_ValueRecorder.FirstUpdate && g_CarCamera.module_camera_item)
		g_car_instance.car_mirror.Update()

	g_AIManager.Update()

	// update car camera
	g_CarCamera.Update()		
	
	g_RainSplashParticlesManager.Update()	
	
	// update g_ValueRecorder
	if(!g_ValueRecorder.IsRecording)
		g_ValueRecorder.Update(g_dt_frame)	
	

	// update g_SoundManager
	g_SoundManager.Update()	

	g_WindowsManager.Update(true)

	g_PathManager.Update()

	g_DeactivationSystem.Update()

	g_NetworkManager.Update()
	
	
}

class	GlobalItemUpdateScript
{	
	function	OnRenderUser(scene)
	{
		g_Debug2dManager.OnRenderUser(scene)
	}

	/*! @short	OnRenderDone Called each frame. */ 
	function	OnRenderDone(item) 
	{
		// Call special drawing
		g_SituationManager.RenderDone()
	}

	/*! @short	OnUpdate Called each frame. */ 
	function	OnUpdate(item) 
	{
		GlobalUpdate()
	}
		
	function 	OnSetup(Item)
	{		
		GlobalSetup()	
	}
}		


function	ConformString(str)
{
	local	l = str.len(), i,
			nstr = "", c
	
	for (i = 0; i < l; i++)
	{
		c = str.slice(i,i+1)
		if ((c >= "a" && c <= "z") || (c >= "A" && c <= "Z") || (c >= "0" && c <= "9")) 
			nstr += c
		else
			nstr += "_"
	}		
	
	return (nstr)
}
