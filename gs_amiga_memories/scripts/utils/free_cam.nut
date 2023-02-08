class	FreeCamera
{
/*<
	<Script =
		<Name = "Free Camera">
		<Author = "Scorpheus">
		<Description = "Free camera.">
		<Category = "Game/Camera">
		<Compatibility = <Camera>>
	>
	<Parameter =
		<SpeedCam = <Name="SpeedCam"> <Description = "Speed Camera"> <Type = "Float"> <Default = 0.3>>
		<Stick_to_the_floor = <Name="Stick to the floor"> <Description = "Stick to the floor"> <Type = "Bool"> <Default = False>>
		<triple_screen = <Name="Triple screen"> <Description = "Triple screen"> <Type = "Bool"> <Default = False>>
		<follow_the_road = <Name="Follow the road"> <Description = "Follow the road"> <Type = "Bool"> <Default = False>>
		<fov = <Name="fov"> <Description = "fov"> <Type = "Float"> <Default = 40.0>>
	>
>*/
	SpeedCam = 0.3
	Stick_to_the_floor = false
	triple_screen = false
	follow_the_road= false
	fov = 40.0
 
	acc			=	0
	euler		=	0

	id_path_list = []
 
	function	OnSetup(item)
	{
		ItemSetNoTarget(item)

		if(triple_screen)
		{
			// tell the scene to not be render by herlself
			SceneSetRenderless(g_scene, true)
			CameraSetFov(ItemCastToCamera(item), Deg(fov))
		}
	}
 
	function	OnUpdate(item)
	{
		local	keyboard = GetKeyboardDevice(),
				mouse = GetMouseDevice()
 
	 	if	(DeviceIsKeyDown(mouse, KeyButton0))
	 	{
			local	old_mx = DeviceInputLastValue(mouse, DeviceAxisX),
					old_my = DeviceInputLastValue(mouse, DeviceAxisY)
			local	mx = DeviceInputValue(mouse, DeviceAxisX),
					my = DeviceInputValue(mouse, DeviceAxisY)
	 
			acc = Vector(0, 0, 0)
			euler = ItemGetRotation(item) + Vector(my - old_my, mx - old_mx, 0) * Deg(360.0)
	 
			if	(euler.x < Deg(-90))
				euler.x = Deg(-90)
			if	(euler.x > Deg(95))
				euler.x = Deg(95)
			ItemSetRotation(item, euler)
	 
		}
		
		local VecDir = MatrixToEuler(ItemGetRotationMatrix(item), ItemGetRotationOrder(item))

		local speed = SpeedCam
		if	(DeviceIsKeyDown(keyboard, KeyRShift))
			speed *= 2.0		
 
		if(follow_the_road)
		{
			if(g_PathManager)
			{	
				local point = ItemGetPosition(item)		
				if(id_path_list.len() == 0)
					id_path_list.append(g_PathManager.GetNearestPath(point))

				// check if it's the end of the path and change it in case
				if(g_PathManager.IsEndOfThePath(id_path_list, point) && id_path_list.len() > 1)
				{				
					id_path_list.remove(0)					
				}

				ItemSetPosition(item, g_PathManager.GetTargetPoint(id_path_list, point, speed))
			}
		}
		else
		{
			if	(DeviceIsKeyDown(keyboard, KeyUpArrow) || DeviceIsKeyDown(keyboard, KeyZ) || DeviceIsKeyDown(keyboard, KeyW))
				ItemSetPosition(item, ItemGetPosition(item) + Vector(sin(VecDir.y), -sin(VecDir.x), cos(-VecDir.y))*speed)
			if	(DeviceIsKeyDown(keyboard, KeyDownArrow) || DeviceIsKeyDown(keyboard, KeyS))
				ItemSetPosition(item, ItemGetPosition(item) - Vector(sin(VecDir.y), -sin(VecDir.x), cos(-VecDir.y))*speed)
			if	(DeviceIsKeyDown(keyboard, KeyLeftArrow) || DeviceIsKeyDown(keyboard, KeyQ) || DeviceIsKeyDown(keyboard, KeyA))
				ItemSetPosition(item, ItemGetPosition(item) - Vector(cos(VecDir.y), 0.0, sin(-VecDir.y))*speed)
			if	(DeviceIsKeyDown(keyboard, KeyRightArrow) || DeviceIsKeyDown(keyboard, KeyD))
				ItemSetPosition(item, ItemGetPosition(item) + Vector(cos(VecDir.y), 0.0, sin(-VecDir.y))*speed)
		}

		if(Stick_to_the_floor)
		{
			local contact = SceneCollisionRaytrace(g_scene, ItemGetWorldPosition(item)+Vector(0,2.0,0), Vector(0,-1,0), 4, CollisionTraceAll, -1)
			if	(contact.hit)
				ItemSetPosition(item, contact.p+Vector(0,1.5,0))
		}

		if(triple_screen)
			RenderTripleScreen(item)
	}

	//------------------
	function    RenderTripleScreen(item)
	{		
		local save_cam_rot = ItemGetRotationMatrix(item)		
		local save_cam_pos = ItemGetWorldPosition(item)
		local cam_fov = CameraGetFov(ItemCastToCamera(item))

			SceneRegisterAsPropertyCallback(g_scene, g_render)
			
			ScenePushRenderable(g_scene, g_render)

			// Clear the complete viewport.
			RendererSetViewport(g_render, 0, 0, 1, 1)
			RendererSetClipping(g_render, 0, 0, 1, 1)
			RendererClearFrame(g_render, 0,0,0)

			// compute the horizontal_fov, from the viewport size and the original fov
			local	viewport = RendererGetOutputDimensions(g_render)
			local	viewport_ar = viewport.y / (viewport.x/3.0)			

			local	hyp = tan(cam_fov*0.5)
			local	horizontal_fov = atan(hyp /viewport_ar) 

			//draw the middle screen
			RendererSetViewport(g_render, 1.0/3.0, 0.0, 2.0/3.0, 1.0)
	//		RendererSetViewItemAndApplyView(g_render, item)
			RendererRenderQueue(g_render)
		
			// draw the right screen
			{
				local rot_matrix = RotationMatrixY(-horizontal_fov*2.0)
				ItemSetRotationMatrix(item, save_cam_rot * rot_matrix)
			}

			RendererSetViewport(g_render, 0.0,0.0, 1.0/3.0+0.001, 1.0)
	//		RendererSetViewItemAndApplyView(g_render, item)
			RendererRenderQueue(g_render)
		
			// draw the left screen
			{
				local rot_matrix = RotationMatrixY(horizontal_fov*2.0)
				ItemSetRotationMatrix(item, save_cam_rot * rot_matrix)
			}
			RendererSetViewport(g_render, 2.0/3.0-0.001, 0.0, 1.0, 1.0)
	//		RendererSetViewItemAndApplyView(g_render, item)
			RendererRenderQueue(g_render)

			// reset the scene (for ui)
			RendererSetViewport(g_render, 0, 0, 1, 1)
			RendererRenderQueueReset(g_render)


		ItemSetRotationMatrix(item, save_cam_rot )
		ItemSetPosition(item, save_cam_pos)
	}
}