/*
	File: scripts/utils/ai_test_scene.nut
	Author: Movida Production
*/

Include("scripts/utils/utils.nut")
Include("scripts/ai/ai_light.nut")

g_CarCamera			<-	0
g_ValueRecorder		<-	{	IsRecording = false	}

class	DummyCarScript
{

	brake		=	false
	rear_gear	=	false

	constructor()
	{
	}

	function	ShowBrakeLight()
	{
		return	brake
	}

	function	IsUsingRearGear()
	{
		return	rear_gear
	}

}

/*!
	@short	AILightTest
	@author	Movida Production
*/
class	AILightTest
{

	test_duration		=	Sec(2.0)

	light_list			=	0
	light_intensity		=	0.0
	body_list			=	0
	light_switched_on	=	false
	ai_list				=	0
	car_script			=	0
	dispatch			=	0
	timer_next_test		=	0
	label_item			=	0

	/*!
		@short	OnUpdate
		Called each frame.
	*/
	function	OnUpdate(scene)
	{
		foreach(ai_script in ai_list)
			ai_script.Update()

		UpdateLight()

		if (dispatch != 0)
		{
			UpdateLabel(dispatch)
			this[dispatch]()
		}
	}

	function	UpdateLabel(str)
	{
		ItemGetScriptInstance(label_item).label = str
	}

	function	UpdateLight()
	{
		light_intensity += g_dt_frame * (light_switched_on?1.0:-1.0)
		light_intensity = Clamp(light_intensity, 0.0, 1.0)

		foreach(light in light_list)
		{
			LightSetDiffuseIntensity(light, light_intensity * 0.7)
			LightSetSpecularIntensity(light, light_intensity )
		}
	}

	function	TestIdle()
	{
		if ((g_clock - timer_next_test) > SecToTick(Sec(test_duration)))
		{
			timer_next_test = g_clock
			dispatch = "TestBrake"
			light_switched_on = !light_switched_on
		}
	}

	function	TestBrake()
	{
		if ((g_clock - timer_next_test) < SecToTick(Sec(test_duration)))
			car_script.brake = true
		else
		{
			car_script.brake = false
			timer_next_test = g_clock
			dispatch = "TestIsUsingRearGear"
		}
	}

	function	TestIsUsingRearGear()
	{
		if ((g_clock - timer_next_test) < SecToTick(Sec(test_duration)))
			car_script.rear_gear = true
		else
		{
			car_script.rear_gear = false
			timer_next_test = g_clock
			dispatch = "TestSwitchLightOn"
		}
	}

	function	TestSwitchLightOn()
	{
		if ((g_clock - timer_next_test) < SecToTick(Sec(test_duration)))
		{
			foreach(ai_script in ai_list)
				ai_script.SwitchLightOn()
		}
		else
		{
			timer_next_test = g_clock
			dispatch = "TestSetFog"
		}
	}

	function	TestSetFog()
	{
		if ((g_clock - timer_next_test) < SecToTick(Sec(test_duration)))
		{
			foreach(ai_script in ai_list)
				ai_script.SetFog(true)
		}
		else
		{
			foreach(ai_script in ai_list)
				ai_script.SetFog(false)
			foreach(ai_script in ai_list)
				ai_script.SwitchLightOff()

			timer_next_test = g_clock
			dispatch = "TestActivateLeftIndicator"
		}
	}

	function	TestActivateLeftIndicator()
	{
		if ((g_clock - timer_next_test) < SecToTick(Sec(test_duration * 3.0)))
		{
			foreach(ai_script in ai_list)
				if (!ai_script.indicator_left) ai_script.ActivateLeftIndicator()
		}
		else
		{
			foreach(ai_script in ai_list)
				ai_script.DeactivateIndicators()

			timer_next_test = g_clock
			dispatch = "TestActivateRightIndicator"
		}
	}

	function	TestActivateRightIndicator()
	{
		if ((g_clock - timer_next_test) < SecToTick(Sec(test_duration * 3.0)))
		{
			foreach(ai_script in ai_list)
				if (!ai_script.indicator_right) ai_script.ActivateRightIndicator()
		}
		else
		{
			foreach(ai_script in ai_list)
				ai_script.DeactivateIndicators()

			timer_next_test = g_clock
			dispatch = "TestIdle"
		}
	}

	/*!
		@short	OnSetup
		Called when the scene is about to be setup.
	*/
	function	OnSetup(scene)
	{

		g_CarCamera = { module_camera_item = 0}
		g_CarCamera.module_camera_item = CameraGetItem(SceneGetCurrentCamera(scene))
		car_script = DummyCarScript()
		label_item = SceneFindItem(scene, "mode_label")

		ai_list = []
		light_list = []
		body_list = []
		local	temp = SceneGetItemList(scene)

		foreach(item in temp)
		{
			if (ItemGetName(item) == "ai_car")
			{
				local	body = ItemGetChild(item, "body")
				local	light_script = AILight()
				light_script.Setup(body, car_script, true)
				light_script.state = "low_beam"
				ai_list.append(light_script)
				//ItemGetScriptInstance(body)
			}
			else
			{
				if (ItemGetName(item) == "light")
				{
					light_list.append(ItemCastToLight(item))
				}
			}
		}

		dispatch = "TestIdle"
	}
}
