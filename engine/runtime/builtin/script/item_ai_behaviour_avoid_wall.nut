class	BuiltinItemAIBehaviourAvoidWall
{
/*<
	<Script =
		<Name = "Avoid Walls">
		<Author = "Thomas Simonnet">
		<Description = "The AI will avoid the wall by setting a high priority near the wall.">
		<Category = "TS A.I./Behaviour">
		<Compatibility = <Item>>
	>
	<Parameter =
		<dist_wall = <Name = "Distance Wall"> <Description = "Set the distance the ai is taking care of the wall."> <Type = "Float"> <Default = 3.0>>
		<debug_flag = <Name = "Enable debug"> <Type = "Bool"> <Default = False>>
			
	>
>*/
	AITSType = "AITSBehavior_v1"

	//--------------------------------------------------------------------------
	dist_wall = 3.0
	debug_flag			= false
	
	//--------------------------------------------------------------------------

	max_speed				= 0.0
	
	has_hit_left = 0
	has_hit_right = 0
	
	function	OnSetupDone(item)
	{
		has_hit_left = false
		has_hit_right = false
	
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
	
	function	UpdateWeight(item)
	{		
		if(has_hit_left || has_hit_right)
			return 10.0
		else
			return 0.0
	}

	
	function	Update(item)
	{					
		has_hit_left = false
		has_hit_right = false
		
		// test wall
		local 	item_matrix = ItemGetMatrix(item),
				item_forward = item_matrix.GetRow(2),
				item_forward_90 = Vector(-item_forward.z, item_forward.y, item_forward.x)

		local	hit_right = SceneCollisionRaytrace(g_scene, ItemGetWorldPosition(item)+Vector(0,0.2,0), (item_forward-item_forward_90).Normalize(), -1, 1, dist_wall.tofloat())
		local	hit_left = SceneCollisionRaytrace(g_scene, ItemGetWorldPosition(item)+Vector(0,0.2,0), (item_forward+item_forward_90).Normalize(), -1, 1, dist_wall.tofloat())

		local dist_right_sq = 10000.0
		local dist_left_sq = 10000.0

		if(hit_left.hit)
		{
			if(hit_left.n.y < 0.5 && (ItemPhysicGetFlag(hit_left.item) == PhysicFlagNone || ItemPhysicGetFlag(hit_left.item) == PhysicModeStatic))
			{
				dist_left_sq = hit_left.d
				has_hit_left = true
				
				if(debug_flag)
					RendererDrawCrossColored(EngineGetRenderer(g_engine), hit_left.p, Vector(1,0.5,0));
			}
		}

		if(hit_right.hit)			
		{
			if(hit_right.n.y < 0.5 && (ItemPhysicGetFlag(hit_right.item) == PhysicFlagNone || ItemPhysicGetFlag(hit_right.item) == PhysicModeStatic) )
			{
				dist_right_sq = hit_right.d
				has_hit_right = true
				
				if(debug_flag)
					RendererDrawCrossColored(EngineGetRenderer(g_engine), hit_right.p, Vector(0,0.5,1));
			}
		}
		
		// check nearest
		if(hit_left.hit && dist_left_sq < dist_wall.tofloat() && dist_left_sq < dist_right_sq)
		{		
			local selected_speed = HitInFront(item, dist_left_sq, item_forward)
			
			local dir_vec = ((item_forward_90*-1.0)+(ItemGetWorldPosition(item)-hit_left.p)).Normalize()
			
			if(debug_flag)
				RendererDrawCrossColored(EngineGetRenderer(g_engine), ItemGetWorldPosition(item)+(dir_vec), Vector(1,0,0))
				
			return  [
					["speed", selected_speed],
					["direction", dir_vec]
					]
		}
		else
		if(hit_right.hit && dist_right_sq < dist_wall.tofloat() && dist_right_sq < dist_left_sq )
		{
				
			local selected_speed = HitInFront(item, dist_right_sq, item_forward)
			
			local dir_vec = ((item_forward_90)+(ItemGetWorldPosition(item)-hit_right.p)).Normalize()
			
			if(debug_flag)
				RendererDrawCrossColored(EngineGetRenderer(g_engine), ItemGetWorldPosition(item)+(dir_vec), Vector(0,0,1))
				
			return  [
					["speed", selected_speed],
					["direction", dir_vec]
					]
		}			
		
		return  []
	}	
	
	//-----------------------------
	function HitInFront(item, dist_other_collide, item_forward)
	{		
		// inverse speed if the wall is very near and in front			
		local	hit_front = SceneCollisionRaytrace(g_scene, ItemGetWorldPosition(item)+Vector(0,0.2,0), item_forward, -1, 1, dist_wall.tofloat())
		if(hit_front.hit)
		{
			if(hit_front.n.y < 0.5 && (ItemPhysicGetFlag(hit_front.item) == PhysicFlagNone || ItemPhysicGetFlag(hit_front.item) == PhysicModeStatic))
			{
				if(dist_other_collide > hit_front.d)
					return -max_speed
			}
		}
		
		return max_speed
	}
}
