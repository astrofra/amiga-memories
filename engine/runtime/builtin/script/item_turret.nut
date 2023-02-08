class	BuiltinItemTurret
{
/*<
	<Script =
		<Name = "Turret">
		<Author = "Thomas Simonnet">
		<Description = "A simple turret, targeting or moving by the keyboard.">
		<Documentation = "doc://builtin/item_turret.htm">
		<Category = "Game/Misc">
		<Requires = <RigidBody>>
	>
	<Parameter =
		<head_turret = <Name = "Head turret"> <Description = "Name prefix of the head turret item, moving on y-axis."> <Type = "String"> <Default = "head">>
		<canon_turret = <Name = "Cannon turret"> <Description = "Name prefix of the base turret item, moving on x-axis."> <Type = "String"> <Default = "cannon">>
		<target_name = <Name = "Target name"> <Description = "Name prefix of the target's turret."> <Type = "String"> <Default = "">>
		<min_x_angle = <Name = "angle X min"> <Description = "Min angle in x-axis (degree)."> <Type = "Float"> <Default = -90.0>>
		<max_x_angle = <Name = "angle X max"> <Description = "Max angle in x-axis (degree)."> <Type = "Float"> <Default = 10.0>>
		<min_y_angle = <Name = "angle Y min"> <Description = "Min angle in y-axis (degree)."> <Type = "Float"> <Default = -90.0>>
		<max_y_angle = <Name = "angle Y max"> <Description = "Max angle in y-axis (degree)."> <Type = "Float"> <Default = 90.0>>
		<turret_angle_speed = <Name = "Angle speed turn"> <Description = "Speed to turn the turret."> <Type = "Float"> <Default = 4.0>>
	>
>*/

	//--------------------------------------------------------------------------
	head_turret			=	"head"
	canon_turret		=	"cannon"

	target_name			=	""
	
	min_x_angle				=	-90
	max_x_angle				=	10.0
	min_y_angle				=	-90.0
	max_y_angle				=	90.0
	
	turret_angle_speed	=	4.0		// kind of angle per frame

	//--------------------------------------------------------------------------
	
	
	pad					=	null
	
	head_turret_item	= 	0
	cannon_turret_item	= 	0

	target_item			=	0	
	
	rad_min_x_angle				=	0.0
	rad_max_x_angle				=	0.0
	rad_min_y_angle				=	0.0
	rad_max_y_angle				=	0.0

	//--------------------------------------------------------------------------
	function	OnSetup(item)
	{
		if(head_turret && head_turret != "")
		{
			head_turret_item = SceneFindItemChild(g_scene, item, head_turret)
			if	(!ObjectIsValid(head_turret_item))
				head_turret_item = 0
		}
			
		if(head_turret_item && canon_turret && canon_turret != "")
		{
			cannon_turret_item = SceneFindItemChild(g_scene, head_turret_item, canon_turret)
			if	(!ObjectIsValid(cannon_turret_item))
				cannon_turret_item = 0
		}
			
		if(target_name && target_name != "")
		{
			target_item = SceneFindItem(g_scene, target_name)
			if	(!ObjectIsValid(target_item))
				target_item = 0
		}
		
		rad_min_x_angle				=	(min_x_angle	*3.14) / 180.0
		rad_max_x_angle				=	(max_x_angle	*3.14) / 180.0
		rad_min_y_angle				=	(min_y_angle	*3.14) / 180.0
		rad_max_y_angle				=	(max_y_angle	*3.14) / 180.0
	}

	//--------------------------------------------------------------------------
	function	ControlLocalSpace(item, dt)
	{
		if	((pad != null) && DeviceIsAvailable(pad))
		{
			DeviceUpdate(g_pad_0)

			local	head_angle = ItemGetRotation(head_turret_item)
			if	(DevicePoolFunction(g_pad_0, DeviceLeft))
				head_angle.y -= turret_angle_speed*g_dt_frame
			if	(DevicePoolFunction(g_pad_0, DeviceRight))
				head_angle.y += turret_angle_speed*g_dt_frame
	
			ItemSetRotation(head_turret_item, head_angle)
			
			local	cannon_angle = ItemGetRotation(cannon_turret_item)
			if	(DevicePoolFunction(g_pad_0, DeviceUp))
				cannon_angle.x += turret_angle_speed*g_dt_frame
			if	(DevicePoolFunction(g_pad_0, DeviceDown))
				cannon_angle.x -= turret_angle_speed*g_dt_frame
				
			ItemSetRotation(cannon_turret_item, cannon_angle)
		}
		else
		{
			KeyboardUpdate()
	
			local	head_angle = ItemGetRotation(head_turret_item)
			if	(KeyboardSeekFunction(DeviceKeyPress, KeyLeftArrow))
				head_angle.y -= turret_angle_speed*g_dt_frame
			if	(KeyboardSeekFunction(DeviceKeyPress, KeyRightArrow))
				head_angle.y += turret_angle_speed*g_dt_frame
				
			if(rad_min_y_angle > head_angle.y)
				head_angle.y = rad_min_y_angle
				
			if(rad_max_y_angle < head_angle.y)
				head_angle.y = rad_max_y_angle
				
			ItemSetRotation(head_turret_item, head_angle)
	
			local	cannon_angle = ItemGetRotation(cannon_turret_item)
			if	(KeyboardSeekFunction(DeviceKeyPress, KeyUpArrow))
				cannon_angle.x -= turret_angle_speed*g_dt_frame
			if	(KeyboardSeekFunction(DeviceKeyPress, KeyDownArrow))
				cannon_angle.x += turret_angle_speed*g_dt_frame
				
			if(rad_min_x_angle > cannon_angle.x)
				cannon_angle.x = rad_min_x_angle
				
			if(rad_max_x_angle < cannon_angle.x)
				cannon_angle.x = rad_max_x_angle
				
			ItemSetRotation(cannon_turret_item, cannon_angle)
		}
	}
	
	//--------------------------------------------------------------------------
	function	Targetting(item, dt)
	{
		local vec_base_to_target = ItemGetWorldPosition(target_item) - ItemGetWorldPosition(item)

		local	head_angle = ItemGetRotation(head_turret_item)
		
		{// x axis
			local	cannon_angle = ItemGetRotation(cannon_turret_item)			
			
			local vec_base_to_target_x = (ItemGetWorldPosition(target_item) - ItemGetWorldPosition(item))
			vec_base_to_target_x.y = 0.0
			vec_base_to_target_x = vec_base_to_target_x .Normalize()

			local vec_base_to_target_norm = (ItemGetWorldPosition(target_item) - ItemGetWorldPosition(item)).Normalize()
			
			local angle_vector = vec_base_to_target_norm.AngleWithVector(vec_base_to_target_x)						
			
			if(ItemGetWorldPosition(item).y < ItemGetWorldPosition(target_item).y)
				angle_vector *= -1.0

			cannon_angle.x -= (cannon_angle.x - angle_vector)*4.0*g_dt_frame
			
			if(rad_min_x_angle > cannon_angle.x)
				cannon_angle.x = rad_min_x_angle
				
			if(rad_max_x_angle < cannon_angle.x)
				cannon_angle.x = rad_max_x_angle
			
			ItemSetRotation(cannon_turret_item, cannon_angle)		
		}
	
		{// y axis	
			
			local vec_base_to_target_y = ItemGetWorldPosition(target_item) - ItemGetWorldPosition(item)
			
			vec_base_to_target_y.y = 0.0
			vec_base_to_target_y = vec_base_to_target_y.Normalize() 
			
			local angle_vector = vec_base_to_target_y.AngleWithVector(Vector(0.0, 0.0, -1.0))	
						
			if(vec_base_to_target_y.Cross(Vector(0.0, 0.0, 1.0)).y > 0)
				head_angle.y -= (head_angle.y - angle_vector)*4.0*g_dt_frame
			else
				head_angle.y -= (head_angle.y - (-angle_vector))*4.0*g_dt_frame		
				
			if(rad_min_y_angle > head_angle.y)
				head_angle.y = rad_min_y_angle
				
			if(rad_max_y_angle < head_angle.y)
				head_angle.y = rad_max_y_angle
				
			ItemSetRotation(head_turret_item, head_angle)
		}			
	}

	//--------------------------------------------------------------------------
	function	OnUpdate(item)
	{
		// do something only if the head and the base are here
		if(head_turret_item	!= 	0 && cannon_turret_item	!= 	0)
		{
			// if the target is here
			if(target_item)
				Targetting(item, g_dt_frame)
			else
				ControlLocalSpace(item, g_dt_frame)
		}
	}
}
