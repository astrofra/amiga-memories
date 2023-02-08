class	BuiltinItemAIBehaviourFollowTarget
{
/*<
	<Script =
		<Name = "Follow Target">
		<Author = "Thomas Simonnet">
		<Description = "Follow a target.">
		<Category = "TS A.I./Behaviour">
		<Compatibility = <Item>>
	>
	<Parameter =
		<target_name = <Name="Target"> <Description = "Target item to follow."> <Type = "Item">>
		<distance = <Name = "Distance"> <Type = "Float"> <Default = 1.0>>		
		<activate_distance = <Name = "Activate Distance (0=always activate)"> <Type = "Float"> <Default = 0.0>>		
	>
>*/
	AITSType = "AITSBehavior_v1"

	//--------------------------------------------------------------------------
	distance				=	1.0
	target_name			=	""
	activate_distance = 0.0

	//--------------------------------------------------------------------------
	target_item			=	0		
	distance_sq 		= 0
	activate_distance_sq 		= 0
	
	current_dist_to_target_sq = 0
	
	max_speed				= 0
	
	function	OnSetupDone(item)
	{
		if(target_name && target_name != "")
		{
			target_item = SceneFindItem(g_scene, target_name)
			if	(!ObjectIsValid(target_item))
				target_item = 0
		}
		distance_sq = distance*distance
		activate_distance_sq = activate_distance*activate_distance
		
		// get the max speed from the aimaster
		local count_built_in = ItemGetScriptInstanceCount(item)
		for(local i=0; i<count_built_in; ++i)
		{
			local instance_behaviour = ItemGetScriptInstanceFromIndex(item, i)
			
			// check the build in is not this ai_master, and if it's a ai_behaviour
			if(instance_behaviour != this && instance_behaviour.rawin("AITSType") == true && instance_behaviour.AITSType == "AITSBehavior_v1_master")
				max_speed = instance_behaviour.max_speed
		}
	}
	
	//-----------------------------
	function	UpdateWeight(item)
	{		
		if(activate_distance_sq == 0.0 || current_dist_to_target_sq < activate_distance_sq)
			// more it's near , nmore weight
			return RangeAdjust(Clamp(current_dist_to_target_sq, 0.0, distance_sq), 0.0, distance_sq, 10.0, 1.0)
		else
			return 0.0
	}
	
	//-----------------------------
	function	Update(item)
	{			
		if(target_item == 0)
			return []
			
		local desired_dir_vect = ItemGetWorldPosition(target_item) - ItemGetWorldPosition(item)

		current_dist_to_target_sq = desired_dir_vect.Len2()
		local k = 0.0
		if(current_dist_to_target_sq > distance_sq)
			k=RangeAdjust(Clamp(current_dist_to_target_sq, distance_sq, distance_sq*3.0), distance_sq, distance_sq*3.0, 0.0, max_speed)
		else			
			k=RangeAdjust(Clamp(current_dist_to_target_sq, 0.0, distance_sq), 0.0, distance_sq, -max_speed*0.5, 0.0)

	
		return  [
					["speed", k*1.0],
					["direction", desired_dir_vect.Normalize()]
				]
	}
	
}
