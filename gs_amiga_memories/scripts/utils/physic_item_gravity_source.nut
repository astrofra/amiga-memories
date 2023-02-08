/*
	File: scripts/physic_item_gravity_source.nut
	Author: P. Blanche - F. Gutherz
*/

Include("scripts/utils/physic_item_xz_plane.nut")

/*!
	@short	PhysicItemGravitySource
	@author	P. Blanche - F. Gutherz
*/
class	PhysicItemGravitySource	extends	PhysicItemXZPlane
{
	orbiting_radius	=	0
	focus			=	false

	function	OnUpdate(item)
	{
		if ("OnUpdate" in base)	base.OnUpdate(item)
	}

	function	OnPhysicStep(item, dt)
	{
		if ("OnPhysicStep" in base)	base.OnPhysicStep(item, dt)
	}

	function	RenderUser(scene)
	{
		if ("RenderUser" in base)	base.RenderUser(scene)
		if(focus)	DrawCircleInXZPlane(position, orbiting_radius, g_vector_cyan, 8.0)
	}

	function	OnSetup(item)
	{
		if ("OnSetup" in base)	base.OnSetup(item)
		local	_min = bounding_box.min,
				_max = bounding_box.max
		_min.y = 0.0
		_max.y = 0.0
		orbiting_radius = _min.Dist(_max) * Pow(mass, 0.5) * 0.25
		focus = false
	}

}
