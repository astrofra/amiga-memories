class	BuiltinSmartCameraFollowItem
{
/*<
	<Script =
		<Name = "Smart Camera Follow Item">
		<Author = "Thomas Simonnet">
		<Description = "Follow an item from a distance and be always in sight.">
		<Category = "Game/Camera">
		<Compatibility = <Camera>>
	>
	<Parameter =
		<target_name = <Name="Target"> <Description = "Target item to follow."> <Type = "Item">>
		<distance = <Name = "Distance"> <Type = "Float"> <Default = 3.0>>
		<height = <Name = "Height"> <Description = "Height up to the target."> <Type = "Float"> <Default = 1.0>>
	>
>*/

	//--------------------------------------------------------------------------
	distance				=	3.0
	target_name				=	""
	height					=	1.0

	//--------------------------------------------------------------------------
	
	target_item				=	0	
	
	distance_sq 			= 	0.0

	vect_to_target 			=	0
	vect_to_target_norm 	=	0

	current_dir_vect = Vector(0.0,0.0,0.0)
	
	function	OnSetup(item)
	{
		if(target_name && target_name != "")
		{
			target_item = SceneFindItem(g_scene, target_name)
			if	(!ObjectIsValid(target_item))
			{
				target_item = 0
				print("Smart Camera Follow Item: No Target \"" +target_name+ "\" for "+ItemGetName(item))
			}
		}
		else 			
			print("Smart Camera Follow Item: No Target for "+ItemGetName(item))

		distance_sq = distance*distance
	}
	
	function	OnUpdate(item)
	{		
		if(target_item == 0)
			return 

		vect_to_target = ItemGetWorldPosition(target_item) - ItemGetWorldPosition(item)
		vect_to_target_norm = vect_to_target.Normalize()
	
		TargettingRot(item, g_dt_frame)
		
		FollowItem(item, g_dt_frame)
	}
	
	function		FollowItem(item, dt)
	{
		local pos_item	= ItemGetWorldPosition(item)	
		local rot_item   =  ItemGetRotation(item)		
		
		// compute force
		local dist_to_target_sq = vect_to_target.Len2()
		local k = 0.0
		if(dist_to_target_sq > distance_sq)
			k=RangeAdjust(Clamp(dist_to_target_sq, distance_sq, distance_sq*3.0), distance_sq, distance_sq*3.0, 0.0, 10.0)
		else			
			k=RangeAdjust(Clamp(dist_to_target_sq, 0.0, distance_sq), 0.0, distance_sq, -0.50, 0.0)

		local item_matrix = ItemGetMatrix(item),
				item_forward = item_matrix.GetRow(2),
				item_forward_90 = Vector(-item_forward.z, item_forward.y, item_forward.x)

		local new_vect = clone(vect_to_target)

		// test wall
		{
			local	hit_front = SceneCollisionRaytrace(g_scene, pos_item, vect_to_target_norm, -1, CollisionTraceAll, dist_to_target_sq)

			if(hit_front.hit)
			{
				if(hit_front.d*hit_front.d < dist_to_target_sq /*&& 
						hit_front.item != item*/)
				{
					k *= 5.0
					new_vect += hit_front.n* RangeAdjust(Clamp(hit_front.d, 0.0, 2.0), 0.0, 2.0, 2.0, 1.0)
				}
			}

			new_vect.y = 0.0
		}	

		current_dir_vect = current_dir_vect *0.9 + new_vect*0.1

		ItemSetPosition(item, pos_item + current_dir_vect.Normalize()*k*dt)

		// move the Y
		local YVector = ItemGetWorldPosition(item)
		ItemSetPosition(item, Vector(YVector.x, YVector.y*0.9+(ItemGetWorldPosition(target_item).y+height)*0.1, YVector.z))
	}

//--------------------------------------------------------------------------
	function	TargettingRot(item, dt)
	{
		local	item_angle = ItemGetRotation(item)
		
		{// x axis			
			local vec_base_to_target_x = clone(vect_to_target)
			vec_base_to_target_x.y = 0.0
			vec_base_to_target_x = vec_base_to_target_x .Normalize()
			
			local angle_vector = vect_to_target_norm.AngleWithVector(vec_base_to_target_x)						
			
			if(ItemGetWorldPosition(item).y < ItemGetWorldPosition(target_item).y)
				angle_vector *= -1.0

			item_angle.x -= (item_angle.x - angle_vector)*4.0*dt			
		}
	
		{// y axis				
			local vec_base_to_target_y = clone(vect_to_target)
			
			vec_base_to_target_y.y = 0.0
			vec_base_to_target_y = vec_base_to_target_y.Normalize() 

			local angle_from_euler = Vector(sin(item_angle.y), 0.0, cos(item_angle.y))			
		
			local angle_vector = vec_base_to_target_y.AngleWithVector(angle_from_euler)	

			if(vec_base_to_target_y.Cross(angle_from_euler).y > 0)
				item_angle.y -= angle_vector*4.0*dt
			else
				item_angle.y += angle_vector*4.0*dt
		}			

		ItemSetRotation(item, item_angle)		
	}
	
}
