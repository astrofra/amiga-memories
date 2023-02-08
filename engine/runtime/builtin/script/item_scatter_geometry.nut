class	BuiltinScatterGeometry
{
/*<
	<Script =
		<Name = "Scatter Geometry">
		<Author = "Francois Gutherz">
		<Description = "Scatter a geometry randomly around the item.">
		<Category = "Transformation">
		<Compatibility = <Item>>
	>
	<Parameter =
		<radius = <Name = "Radius"> <Type = "Float"> <Default = 10.0>>
		<amount = <Name = "Amount"> <Type = "Int"> <Default = 25>>
		<filename_0 = <Name = "Filename"> <Description = "Path relative to the project root."> <Type = "String"> <Default = "item_0.nmg">>
		<filename_1 = <Name = "Filename"> <Description = "Path relative to the project root."> <Type = "String"> <Default = "item_1.nmg">>
		<filename_2 = <Name = "Filename"> <Description = "Path relative to the project root."> <Type = "String"> <Default = "">>
		<filename_3 = <Name = "Filename"> <Description = "Path relative to the project root."> <Type = "String"> <Default = "">>
		<min_scale = <Name = "Min. Scale"> <Type = "Float"> <Default = 0.75>>
		<max_scale = <Name = "Max. Scale"> <Type = "Float"> <Default = 1.0>>
		<merge_enabled = <Name = "Merge geometry"> <Type = "Bool"> <Default = "True">>
	>
>*/
	//-------------------------------------------------------------------------------------
	radius			=	Mtr(10.0)
	amount			=	25
	filename_0		=	"item_0.nmg"
	filename_1		=	"item_1.nmg"
	filename_2		=	""
	filename_3		=	""
	min_scale		=	0.75
	max_scale		=	1.0
	merge_enabled		=	true
	//-------------------------------------------------------------------------------------

	origin			=	Vector(0, 0, 0)

	function	OnSetupDone(item)
	{
		local	scene
		scene = ItemGetScene(item)
		origin = ItemGetWorldPosition(item)
		
		local	i, new_item,
			item_list = [],
			mesh_list = []
			
		if (filename_0 != null && FileExists(filename_0))
			mesh_list.append(filename_0)
		if (filename_1 != null && FileExists(filename_1))
			mesh_list.append(filename_1)
		if (filename_2 != null && FileExists(filename_2))
			mesh_list.append(filename_2)
		if (filename_3 != null && FileExists(filename_3))
			mesh_list.append(filename_3)

		print("BuiltinScatterGeometry::OnSetupDone() : found " + (mesh_list.len()).tostring() + " mesh(es) to scatter.")

		if (mesh_list == [])
			return

		for(i = 0; i < amount; i++)
		{
			new_item = SceneAddObject(scene, "new_item_" + i.tostring())
			local	_filename
			_filename = mesh_list[Mod(Irand(0,100), mesh_list.len())]
			ObjectSetGeometry(new_item, EngineLoadGeometry(g_engine, _filename))
			new_item = ObjectGetItem(new_item)

			local	pos = origin + (Vector(Rand(-1.0,1.0), 0.0, Rand(-1.0,1.0)).Normalize(radius * Rand(0.0, 1.0)))
			local	hit = SceneCollisionRaytrace(scene, pos + Vector(0,0.5,0), Vector(0,-1.0,0), -1, CollisionTraceAll, Mtr(10.0))
			if (hit.hit)
				pos.y = hit.p.y

			ItemSetPosition(new_item, pos)
			local	_sc = Rand(min_scale, max_scale)
			ItemSetScale(new_item, Vector(_sc, _sc, _sc))
			ItemSetRotation(new_item, Vector(0.0, DegreeToRadian(Rand(0.0,180.0)), 0.0))
			
			item_list.append(new_item)
			//ItemSetup(new_item)
		}
		
		if (merge_enabled)
		{
			local	root_item = MergeItemList(scene, item_list)
			ItemSetName(root_item, ItemGetName(item))
			local	geo = ObjectGetGeometry(ItemCastToObject(root_item))
			GeometryOptimize(geo)
			GeometrySetup(geo)
			ItemSetup(root_item)
		}
	}
	
	function	MergeItemList(scene, items)
	{
		print("Merging " + items.len() + " items:")

		// Might be an instance.
		if	(scene.type() == objectTypeItem)
			scene = ItemGetScene(scene)

		local	start_clock = SystemGetClock()

		while (items.len() > 1)
		{
			print("  " + items.len() + " items left...")

			local	merged_items = []
			for	(local n = 0; n < items.len(); )
			{
				merged_items.append(SceneMergeItems(scene, items[n], items[n + 1]));

				SceneDeleteItem(scene, items[n])
				SceneDeleteItem(scene, items[n + 1])
				SceneFlushDeletionQueue(scene)

				n += 2
				if	((n + 1) == items.len())
				{
					merged_items.append(items[n])
					break
				}
			}
			items = merged_items
		}

		print("Done merging in " + (SystemGetClock() - start_clock) * 1000 / SystemGetClockFrequency() + "ms.")
		return items[0]
	}
}
