class	BuiltinThirdPersonCamera
{
/*<
	<Script =
		<Name = "3rd Person Camera">
		<Author = "Emmanuel Julien">
		<Description = "Third person camera.">
		<Category = "Game/Camera">
		<Compatibility = <Camera>>
	>
	<Parameter =
		<target_name = <Name="Target"> <Description = "Target item to follow."> <Type = "Item">>
		<keep_behind = <Name = "Keep behind."> <Type = "Bool"> <Default = True>>
		<enable_collision = <Name = "Avoid occlusion."> <Type = "Bool"> <Default = True>>
		<distance = <Name = "Distance (m)"> <Type = "Float"> <Default = 12.0>>
		<preserve_distance = <Name = "Preserve distance."> <Description = "Offset the camera virtual target when the real target gets too close."> <Type = "Bool"> <Default = True>>
		<height = <Name = "Height (m)"> <Description = "Camera height relative to the target."> <Type = "Float"> <Default = 1.5>>
		<target_height = <Name = "Target Height (m)"> <Description = "Target height offset to the target."> <Type = "Float"> <Default = 2.5>>
		<accuracy = <Name = "Accuracy"> <Description = "How fast the camera reaches its optimal position."> <Type = "Float"> <Default = 0.95>>
	>
>*/

	//--------------------------------------------------------------------------
	target_name				=	""
	target_height			=	2.5

	distance				=	12.0
	height					=	4.0
	keep_behind				=	true
	enable_collision		=	true
	preserve_distance		=	true

	accuracy				=	0.95

	//--------------------------------------------------------------------------

	target					=	0	
	smooth_target			=	0
	smooth_distance			=	0
	smooth_position			=	0

	function	SetTarget(item)
	{	target = item	}

	function	FilterSafeDistance(trace, distance)
	{	return !trace.hit || (trace.d >= distance) ? distance : trace.d	}

	function	GetSafeDistance(target_position, dt)
	{
		if	(!enable_collision)
			return distance
		return FilterSafeDistance(SceneCollisionRaytrace(g_scene, target_position, dt, ~0, CollisionTraceAll, distance), distance)
	}

	function	warmStart(item)
	{
		if	((target = SceneFindItem(g_scene, target_name)).isNull())
			throw("Target item '" + target_name + "' not found")

		smooth_target = ItemGetWorldPosition(target)
		smooth_position = ItemGetWorldPosition(item)
		smooth_distance = distance
	}

	function	OnUpdate(item)
	{
		if	(target == 0)
			warmStart(item)

		local	fps = Min(1.0 / g_dt_frame, 30.0)		// Keep the refresh rate in reasonable ranges.
		local	k_lerp = pow(accuracy, fps)
		local	target_position = ItemGetWorldPosition(target) + Vector(0, target_height, 0)

		// Compute ideal position.
		local	dt = (keep_behind ? ItemGetMatrix(target).GetRow(2) * -1 : ItemGetWorldPosition(item) - target_position).Normalize()
		local	safe_distance = GetSafeDistance(target_position, dt)

		// Increase or decrease distance to target.
		smooth_distance += (safe_distance - smooth_distance) * pow(accuracy + (1.0 - accuracy) * 0.5, fps)

		dt.y = 0
		dt = dt.Normalize()
		local	position = dt * smooth_distance + target_position + Vector(0, height, 0)

		// Move to position.
		smooth_position += (position - smooth_position) * k_lerp
		ItemSetPosition(item, smooth_position)

		// Compute ideal target and align view.
		if	(preserve_distance && (safe_distance < distance))
		{
			local	k = distance - safe_distance
			target_position += dt * k * -0.3
		}

		smooth_target += (target_position - smooth_target) * k_lerp
		ItemSetTarget(item, smooth_target)
	}

	function	OnSetup(item)
	{
		accuracy = Min(accuracy, 1.0)
	}
}
