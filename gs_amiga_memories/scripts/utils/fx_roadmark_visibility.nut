/*
	File: scripts/utils/fx_roadmark_visibility.nut
	Author: Movida Production
*/

/*!
	@short	FxRoadmarkVisibility
	@author	Movida Production
*/
class	FxRoadmarkVisibility
{
/*<
	<Parameter =
		<material_name_list = <Name = "Materials 'A|B|C' :"> <Type = "String"> <Default = "">>
	>
	<Parameter =
		<test_mode = <Name = "Test mode"> <Type = "Bool"> <Default = 0>>
	>
>*/

	material_name_list			=	0
	material_list				=	0
	visibility					=	0.8
	previous_visibility			=	0.8
	test_mode					=	false

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function	OnUpdate(item)
	{
		if (test_mode)
		{
			visibility += (g_dt_frame * 0.15)
			if (visibility > 1.0)	visibility = 0.0
		}

		if (previous_visibility != visibility)
		{
			foreach(mat in material_list)
				MaterialSetSelf(mat, Vector(visibility, visibility, visibility))
		}

		previous_visibility = visibility
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		material_list = []
		material_list = GetMaterialList(item, material_name_list)
	}

	function	GetMaterialList(item, mat_name_list)
	{
		local	_mat_list = []

		local	geo = ItemGetGeometry(item)
		local	_list = split(mat_name_list, "|")
		foreach(_mat_name in _list)
		{
			local	_mat_found = GeometryGetMaterial(geo, _mat_name)
			if (ObjectIsValid(_mat_found))
				_mat_list.append(_mat_found)
		}
		
		return _mat_list
	}
}
