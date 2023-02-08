/*
	File: scripts/base_emulator.nut
	Author: Astrofra
*/

/*!
	@short	EmulatorBase
	@author	Astrofra
*/
class	EmulatorBase
{

	paused					=	false
	parent_item				=	0
	narrator_item			=	0
	narrator_is_open		=	false
	narrator_y_scale		=	0.0
	narrator_y_scale_target	=	0.0
	

	function	OnUpdate(item)
	{
		if (narrator_y_scale > narrator_y_scale_target)
			narrator_y_scale -= (4.0 * g_dt_frame)
		else
		if (narrator_y_scale < narrator_y_scale_target)
			narrator_y_scale += (4.0 * g_dt_frame)

		narrator_y_scale = Clamp(narrator_y_scale, 0.0, 1.0)

		if (narrator_item != 0)
			ItemSetScale(narrator_item, Vector(1.05, Pow(narrator_y_scale, 0.3), 1))
	}

	function	Pause()
	{	paused	=	true	}

	function	Unpause()
	{	paused	=	false	}

	function	OpenNarrator()
	{
		print("EmulatorBase::OpenNarrator()")
		if (narrator_is_open)
			return

		narrator_y_scale_target = 1.0
		narrator_is_open = true
	}

	function	CloseNarrator()
	{
		print("EmulatorBase::CloseNarrator()")
		if (!narrator_is_open)
			return

		narrator_y_scale_target = 0.0
		narrator_is_open = false
	}

	function	OnSetup(item)
	{
		paused		=	true

		parent_item = ItemGetParent(item)
		local	_child_item_list = ItemGetChildList(parent_item)
		foreach(_item in _child_item_list)
			if (ItemGetName(_item) == "narrator_plane")
			{
				narrator_item = _item
				local	narrator_material = GeometryGetMaterialFromIndex(ItemGetGeometry(narrator_item), 0)
				local	scene_script = SceneGetScriptInstance(g_scene)
				if ("lip_sync_tracker" in scene_script)
					scene_script.lip_sync_tracker.RegisterExternalMaterial(narrator_material)

				ItemSetScale(narrator_item, Vector(1.05,0,1))
				narrator_is_open =	false
				narrator_y_scale_target = 0.0
				narrator_y_scale = 0.0 
			}
	}	

}
