g_PathManager <- 0

Include ("scripts/utils/utils.nut")

//------------
class	PathManager
//------------
{
	/*<
	<Script =
		<Name = "PathManager">
		<Author = "Thomas Simonnet">
		<Description = "PathManager">
		<Category = "">
		<Compatibility = <Scene>>
	>
	<Parameter =
		<path_track = <Name = "path_track"> <Type = "String"> <Default = "track.nml">>
	>
>*/
	
	//--------------------------------------------------------------------------
	path_track = "track.nml"
	//--------------------------------------------------------------------------
		
	paths = 0
		
	function OnRenderUser(scene)
	{		/*
		foreach(path in paths)
		{
			local previous_point = Vector(0.0,0.0,0.0)
			foreach(id, point in path)
			{
				//if(id != 0)
				{
					RendererDrawLine(EngineGetRenderer(g_engine), previous_point, point)
					RendererDrawCross(EngineGetRenderer(g_engine), point)
				}
				previous_point = point
			}
		}*/
	}

	//-----------------------------------------
	function	SceneTableGetAIPaths(scene_array)
	//-----------------------------------------
	{
		paths = {}
	
		if ("Motions" in scene_array)
		{
			local	motions = scene_array.Motions
			foreach(motion in motions)
			{
				local	motion_name = motion.Id
				paths.rawset(motion_name, [])
				local	list_x, list_y, list_z
	
				foreach(entry_name, motion_entry in motion)
				{
					switch(entry_name)
					{
						case "PositionX":
							list_x = motion.PositionX.Curve.Knot
							break
						case "PositionY":
							list_y = motion.PositionY.Curve.Knot
							break
						case "PositionZ":
							list_z = motion.PositionZ.Curve.Knot
							break
					}
				}
	
				local	vector_list = []
				foreach(i, val in list_x)
				{
					local	x,y,z,w
					x = split(list_x[i],":")[1].tofloat()
					y = split(list_y[i],":")[1].tofloat()
					z = split(list_z[i],":")[1].tofloat()
					w = split(list_x[i],":")[0].tofloat()
					vector_list.append(Vector(x, y, z, w))
				}
	
				paths[motion_name] = vector_list
			}
		}
		else
			LogOutput("SceneTableGetPaths() : no motions found in scene array.", _OUTPUT_ERROR_)
			
	}
	
	//-------------------------------------------
	function	SceneFindAIPath( path_name)
	//-------------------------------------------
	{
		if (path_name in paths)
		{
			LogOutput("SceneFindAIPath() : Path '" + path_name + "' found in scene.")
			return paths[path_name]
		}
		else
			LogOutput("[!]SceneFindAIPath() : No path named '" + path_name + "' found in scene.", _OUTPUT_ERROR_)		
	}
	
	//-----------------------------
	function	GetLength(path)	//	Replace MotionGetLength()
	//-----------------------------
	{
		//	FIXME
		local	max_time = 0.0
		foreach(point in path)
			if (point.w > max_time)
				max_time = point.w
		return	max_time
	}
	
	//-----------------------------------------
	function	EvaluatePosition(path, time)	//	MotionEvaluatePosition MotionEvaluatePosition()
	//-----------------------------------------
	{
		//	FIXME
		local	closest_point = 0
	
		foreach(point_index, point in path)
			//if (Abs(point.w - time) < Abs(path[closest_point].w - time))
			if(point.w < time)
			{
				closest_point = point_index
			}
			
	//		print(previous_closest_point+", "+closest_point)
			
		local current_point = path[closest_point]
		if(closest_point+1 < path.len())
		{
			local futur_point = path[closest_point+1]
			return futur_point.Lerp(RangeAdjust(time, current_point.w, futur_point.w, 0.0, 1.0), current_point)
		}
	
		return current_point
	}
	
	//-------------------------------
	function	AIPathGetMotion(path)
	//-------------------------------
	{
				//	FIXME
				return path
	}
	
	//-------------------------------
	function	MotionGetName(motion)
	//-------------------------------
	{
				//	FIXME
				return	path.tostring()
	}
	
	//-----------------------------------------------------
	function	GetPointTime(point)
	//-----------------------------------------------------
	{
		return point.w
	}
	//-----------------------------------------------------
	function			GetNearestPath( _point)
	//-----------------------------------------------------
	{
		local near_path = 0
		
		local near_distance = Mtr(1000000.0)
		
		foreach(motion in paths)
		{
			// check the distance to the point
			local temp_distance = GetClosestPoint(motion, _point).Dist2(_point)
			if(temp_distance < near_distance)
			{
				near_distance = temp_distance
				near_path = motion
			}	
		}
		
		return near_path
	}
	
	//-----------------------------------------------------
	function	GetClosestPoint(path, position)
	//-----------------------------------------------------
	{
		local	closest_point_index = 0
	
		foreach(point_index, point in path)
		{
			local	dist = position.Dist(point)
			local	closest_dist = path[closest_point_index].Dist(point)
	
			if (dist < closest_dist)
				closest_point_index	= point_index
		}
		
		return path[closest_point_index]
	}
	
	//---------------------------
	function	AIPathIsValid(path)
	//---------------------------
	{
		if ((typeof path) == "array")
		{
			return true
		}
		else
		{
			return false
		}
	}
	
	//--------------
	function OnSetup(scene)
	//--------------
	{		
		g_PathManager = this
		
		local file_tracks = LoadSceneFromNML(path_track)
		SceneTableGetAIPaths(file_tracks)
	}

}
		