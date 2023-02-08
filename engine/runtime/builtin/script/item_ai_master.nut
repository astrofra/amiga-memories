class	BuiltinItemAIMaster
{
/*<
	<Script =
		<Name = "AI Master">
		<Author = "Thomas Simonnet">
		<Description = "Master the ai behaviour.">
		<Category = "TS A.I.">
		<Compatibility = <Item>>
	>
	<Parameter =
		<max_speed = <Name = "Max Speed"> <Type = "Float"> <Default = 1.0>>
		<max_speed_rot = <Name = "Max Rotation Speed"> <Type = "Float"> <Default = 3.0>>
		<allow_x_rot = <Name = "Allow X Axis Rotation"> <Type = "Bool"> <Default = True>>
		<allow_y_rot = <Name = "Allow Y Axis Rotation"> <Type = "Bool"> <Default = True>>
		<allow_z_rot = <Name = "Allow Z Axis Rotation"> <Type = "Bool"> <Default = True>>
		<debug_flag = <Name = "Enable debug"> <Type = "Bool"> <Default = False>>
	>
>*/
	AITSType = "AITSBehavior_v1_master"

	//--------------------------------------------------------------------------
	max_speed_rot		= 1.0	
	max_speed 			= 1.0
	allow_x_rot			= true
	allow_y_rot			= true
	allow_z_rot			= true
	debug_flag			= false

	//--------------------------------------------------------------------------

	
	speed_rot_vect = Vector(0.0,0.0,0.0)
	
	current_speed_rot = 0	
	current_speed = 0
	
	rot_acceleration = 100.0
	acceleration = 10.0
	
	dir_vect = Vector(1.0,0.0,0.0)
	
	desired_speed = 1.0
	desired_dir_vect = Vector(0.0,0.0,1.0)

	
	function	OnSetup(item)
	{			
		current_speed_rot = 0.0	
		current_speed = 0.0
		ItemPhysicSetAngularFactor(item, Vector(allow_x_rot.tointeger(), allow_y_rot.tointeger(), allow_z_rot.tointeger()))
	}
	
	function	OnPhysicStep(item, dt)
	{			
		if (!dt)
			return
			
		local wanted_speed 		= 0.0
		local wanted_direction 	= Vector(0.0,0.0,0.0)

		local average_value_array = {}
		local average_count_value_array = {}
		
		//update behaviour with priority
		local count_built_in = ItemGetScriptInstanceCount(item)
		
		for(local i=0; i<count_built_in; ++i)
		{
			local instance_behaviour = ItemGetScriptInstanceFromIndex(item, i)
			
			// check the build in is not this ai_master, and if it's a ai_behaviour
			if(instance_behaviour != this && instance_behaviour.rawin("AITSType") == true && instance_behaviour.AITSType == "AITSBehavior_v1")
			{				
				local array_return = instance_behaviour.Update(item)
				local weight = instance_behaviour.UpdateWeight(item)
				
				if(array_return.len() > 0 && weight != 0.0)
				{
					foreach(val in array_return)
					{
						// if the key is already created , just add it
						if(average_count_value_array.rawin(val[0]))
						{
							average_value_array.rawset(val[0], average_value_array.rawget(val[0])+ val[1] * weight)
							average_count_value_array.rawset(val[0], average_count_value_array.rawget(val[0])+1.0)
						}
						else
						{
							average_value_array.rawset(val[0], val[1] * weight)
							average_count_value_array.rawset(val[0], 1.0)
						}						
					}
				}
			}
		}

		// average the key, if it's exist and use it
		if(average_count_value_array.rawin("speed"))
		{
			wanted_speed = average_value_array.rawget("speed") / average_count_value_array.rawget("speed")
		}

		if(average_count_value_array.rawin("direction"))
		{
			wanted_direction =  (average_value_array.rawget("direction")) / average_count_value_array.rawget("direction")
		}

		desired_speed = wanted_speed
		desired_dir_vect = wanted_direction.Normalize()
		
		// change the wanted speed to not go faster than is needed
		if(desired_speed > max_speed)
			desired_speed = max_speed
		else
		if(desired_speed < -max_speed)
			desired_speed = -max_speed
		
		if(debug_flag)
			RendererDrawCross(EngineGetRenderer(g_engine), ItemGetWorldPosition(item)+desired_dir_vect);
		
		// now we have the desired speed and the desired direction, do the physic stuff	
		MoveItem2(item)
	}
	
	//-----------------------------
	function		MoveItem2(item)
	{
		local pos_item	= ItemGetWorldPosition(item)	
		local rot_item   =  ItemGetRotation(item)		
		
		local item_matrix = ItemGetMatrix(item),
				item_forward = item_matrix.GetRow(2),
				item_forward_90 = Vector(-item_forward.z, item_forward.y, item_forward.x)
				
		current_speed += (desired_speed-current_speed)*acceleration*g_dt_frame
	
		// right or left
		if(desired_dir_vect.Len2()> 0)
		{
			local vec_base_to_target_x = desired_dir_vect
			vec_base_to_target_x.y = 0.0
			vec_base_to_target_x = vec_base_to_target_x .Normalize()
			
			local vec_forward_x = item_forward
			vec_forward_x.y = 0.0
			vec_forward_x = vec_forward_x .Normalize()		
			
			local y_angular_velocity = ItemGetAngularVelocity(item).y
			
			local angle_btw_final_and_current = RangeAdjust(Clamp(vec_forward_x.AngleWithVector(vec_base_to_target_x), 0.0, 0.5), 0.0, 0.5, 0.0, 1.0)		
				
			
			if(vec_forward_x.Cross(vec_base_to_target_x).y	 < 0.0)
			{
				if(item_matrix.GetRow(1).y > 0)		
				{
					if(y_angular_velocity > 0)
						ItemApplyTorque(item, Vector(0.0, -Pow(angle_btw_final_and_current, 0.01)*max_speed_rot*Max(1.0,fabs(y_angular_velocity)), 0.0))
					else					
						ItemApplyTorque(item, Vector(0.0, -Pow(angle_btw_final_and_current, 0.1)*max_speed_rot, 0.0))
				}
				else				
				{
					if(y_angular_velocity < 0)
						ItemApplyTorque(item, Vector(0.0, Pow(angle_btw_final_and_current, 0.01)*max_speed_rot*Max(1.0,fabs(y_angular_velocity)), 0.0))
					else					
						ItemApplyTorque(item, Vector(0.0, Pow(angle_btw_final_and_current, 0.1)*max_speed_rot, 0.0))
				}
			}
			else
			{
				if(item_matrix.GetRow(1).y > 0)		
				{					
					if(y_angular_velocity < 0)
						ItemApplyTorque(item, Vector(0.0, Pow(angle_btw_final_and_current, 0.01)*max_speed_rot*Max(1.0,fabs(y_angular_velocity)), 0.0))
					else					
						ItemApplyTorque(item, Vector(0.0, Pow(angle_btw_final_and_current, 0.1)*max_speed_rot, 0.0))
				}
				else				
				{
					if(y_angular_velocity > 0)
						ItemApplyTorque(item, Vector(0.0, -Pow(angle_btw_final_and_current, 0.01)*max_speed_rot*Max(1.0,fabs(y_angular_velocity)), 0.0))
					else					
						ItemApplyTorque(item, Vector(0.0, -Pow(angle_btw_final_and_current, 0.1)*max_speed_rot, 0.0))
				}
			}
		}			
	
		// get the current speed of the item
		local	V_body = ItemGetLinearVelocity(item).Len()
		if(current_speed > 0)
			ItemApplyLinearForce(item, (item_forward )*ItemGetMass(item)*fabs(current_speed-V_body))	
		else
			ItemApplyLinearForce(item, (item_forward )*ItemGetMass(item)*-fabs(current_speed-V_body))		
	}
}
