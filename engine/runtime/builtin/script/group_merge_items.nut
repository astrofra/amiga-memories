class	BuiltinMergeGroup
{
/*<
	<Script =
		<Name = "Merge Group Items">
		<Author = "Emmanuel Julien">
		<Description = "Merge a group of items during scene setup to improve performance.">
		<Compatibility = <Scene>>
		<Category = "Scene Management">
	>
	<Parameter =
		<group_name_0 = <Name = "Merge Group A"> <Type = "String"> <Default = "">>
		<item_name_0 = <Name = "Merged Item A"> <Type = "String"> <Default = "">>
		<group_name_1 = <Name = "Merge Group B"> <Type = "String"> <Default = "">>
		<item_name_1 = <Name = "Merged Item B"> <Type = "String"> <Default = "">>
		<optimize = <Name = "Optimize geometry"> <Type = "Bool"> <Default = False>>
	>
>*/

	item_name_0		=	""
	group_name_0	=	""
	item_name_1		=	""
	group_name_1	=	""

	optimize		=	false

	function	MergeItemList(scene, items)
	{
		return
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

	function	DoMerge(scene, group_name, item_name)
	{
		return
		local	group
		try
		{	group = SceneFindGroup(scene, group_name)	}
		catch (e)
		{	return	}

		if	(group.isNull())
			return

		// Build merge list.
		local	group_items = GroupGetItemList(group)
		local	items = []

		foreach (item in group_items)
			switch	(ItemGetType(item))
			{
				case	ItemTypeObject:
					items.append(item)
					break

				// Expand instance.
				case	ItemTypeInstance:
				{
					local	instantiated_items = InstanceGetItemList(ItemCastToInstance(item))

					foreach (instantiated_item in instantiated_items)
						if	(ItemGetType(instantiated_item) == ItemTypeObject)
							if	(ObjectGetGeometry(ItemCastToObject(instantiated_item)).isValid())
								items.append(instantiated_item)
				}
				break;
			}

		if	(items.len() < 2)
			return

		// Build a list of items whose parenting will need to be corrected after merging is complete.
		local	children = []
		
		foreach (item in items)
			foreach (child in ItemGetChildList(item))
			{
				// Skip children that we are going to merge.
				if	((ItemGetType(child) == ItemTypeObject) && GroupItemIsMember(group, child))
					continue

				// Save child and its matrix.
				children.append({ Item = child, Matrix = ItemGetMatrix(child) })
			}

		// Parent item.
//local	parent = ItemGetParent(items[0])
		local	root_item = MergeItemList(scene, items)
		ItemSetName(root_item, item_name)
//ItemSetParent(root_item, parent)

		// Setup geometry.
		local	geo = ObjectGetGeometry(ItemCastToObject(root_item))
		if	(optimize)
			GeometryOptimize(geo)
		GeometrySetup(geo)
		ItemSetup(root_item)

		// Restore children parenting.
		foreach (child in children)
		{
			try
			{
				ItemSetParent(child["Item"], root_item)
				ItemSetMatrix(child["Item"], child["Matrix"])
			}
			catch(e)
			{}
		}
	}

	function	OnSetup(scene)
	{
		return
		DoMerge(scene, group_name_0, item_name_0)
		DoMerge(scene, group_name_1, item_name_1)
	}
}
