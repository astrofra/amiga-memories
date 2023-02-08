class	BuiltinCameraAutoFocus
{
/*<
	<Script =
		<Name = "Digicam Auto-Focus">
		<Author = "Emmanuel Julien">
		<Description = "Simulate the auto-focus servo of a digital camera.">
		<Compatibility = <Camera>>
		<Category = "FX">
	>
	<Parameter =
		<focal_offset = <Name = "Focal offset (m):"> <Description = "Offset the focal point by a given value in meters."> <Type = "Float"> <Default = 0.0>>
		<focal_fstop = <Name = "F-Stop (m):"> <Type = "Float"> <Default = 5.0>>
		<focus_on = <Name = "Focus on item:"> <Type = "String"> <Default = "">>
	>
>*/

//-------------------
	focal_offset	=	0.0
	focus_on		=	""
	focus_on_item	=	0
//-------------------

	focal_cdist		=	0.1

	function	OnUpdate(item)
	{
		local	camera = ItemCastToCamera(item),
				m = ItemGetMatrix(item)

		local	scene = ItemGetScene(item)

		local	distance_to_focus_item = ItemGetWorldPosition(focus_on_item).Dist(m.GetRow(3))
		local	hit = SceneCollisionRaytrace(scene, m.GetRow(3), m.GetRow(2), ~0, CollisionTraceAll, distance_to_focus_item * 1.5)
		if	(!hit.hit)
			return

		local	tdist = focus_on_item ? hit.d * 0.5 + distance_to_focus_item * 0.5 : hit.d
		focal_cdist += ((tdist + focal_offset) - focal_cdist) * 0.1

		ItemRegistrySetKey(item, "PostProcess:Dof:FDist", focal_cdist)
	}

	function	OnSetup(item)
	{
		if	(focus_on)
			focus_on_item = SceneFindItem(ItemGetScene(item), focus_on)
	}
}
