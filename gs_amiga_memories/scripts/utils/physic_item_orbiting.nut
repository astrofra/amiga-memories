/*
	File: scripts/utils/physic_item_orbiting.nut
	Author: P. Blanche - F. Gutherz
*/

Include("scripts/utils/physic_item_xz_plane.nut")

/*!
	@short	PhysicOrbitingItem
	@author	P. Blanche - F. Gutherz
*/
class	PhysicOrbitingItem 	extends	PhysicItemXZPlane
{
	item_gravity_source		=	0
	target_orbit_point		=	0
	orbit_tangent_vector	=	0
	dir_to_orbiting_point	=	0
	first_orbit_update_done	=	false

	function	OnUpdate(item)
	{
		if ("OnUpdate" in base)	base.OnUpdate(item)
		if (item_gravity_source != 0)
		{
			local	dir_to_orbiting_point = position - ItemGetScriptInstance(item_gravity_source).position
			local	ratio = ItemGetScriptInstance(item_gravity_source).orbiting_radius / dir_to_orbiting_point.Len()
			target_orbit_point = ItemGetScriptInstance(item_gravity_source).position + dir_to_orbiting_point.Scale(ratio)
		}
	}

	function	SetOrbitOnItem(_gravity_source_item)
	{
		item_gravity_source = _gravity_source_item
		first_orbit_update_done	=	false
	}

	function	FreeFromOrbit()
	{
		item_gravity_source = 0
	}

	function	OnPhysicStep(item, dt)
	{
		if ("OnPhysicStep" in base)	base.OnPhysicStep(item, dt)
		if (item_gravity_source != 0)
		{
			if (!first_orbit_update_done)
			{
				local	a = (target_orbit_point - ItemGetScriptInstance(item_gravity_source).position).Normalize()
				orbit_tangent_vector = Vector(a.z, a.y, -a.x)
				local	orbit_target_orientation = EulerFromDirection(orbit_tangent_vector)
				ItemPhysicResetTransformation(body, target_orbit_point, orbit_target_orientation)
				ItemSetPosition(body, target_orbit_point)
				first_orbit_update_done = true
				position = target_orbit_point
			}

			//	Stick item to orbit radius
			local	force
			force = target_orbit_point - position
			local	impulse_intensity = RangeAdjust(force.Len(), 0.0, 1.0, 0.0, 1.0)
			impulse_intensity = Clamp(impulse_intensity, 0.0, 1.0)
			impulse_intensity = Pow(impulse_intensity, 2.0) * 10.0
			ItemApplyLinearImpulse(item, force.Scale(impulse_intensity))

			//	Set item orientation to the orbit tangent
			local	a = (target_orbit_point - ItemGetScriptInstance(item_gravity_source).position).Normalize()
			orbit_tangent_vector = Vector(a.z, a.y, -a.x)
			local	orbit_target_orientation = EulerFromDirection(orbit_tangent_vector)
			local	_torque
			_torque = orbit_target_orientation - orientation
			if (_torque.y > Deg(180.0) || _torque.y < Deg(-180.0))
				_torque = (orientation - orbit_target_orientation)

			ItemApplyTorque(item, _torque.Scale(100.0 * mass))

			//	Apply thrust along the orbit tangent
			ItemApplyLinearForce(item, orbit_tangent_vector.Scale(mass * 25.0))
		}
	}

	function	RenderUser(scene)
	{
		if ("RenderUser" in base)	base.RenderUser(scene)

		if (item_gravity_source != 0)
		{
			local	_pos = ItemGetScriptInstance(item_gravity_source).position
			RendererDrawCross(g_render, target_orbit_point)
			RendererDrawLine(g_render, position, position + orbit_tangent_vector.Scale(5.0))
		}
	}

	function	OnSetup(item)
	{
		if ("OnSetup" in base)	base.OnSetup(item)
		target_orbit_point = g_zero_vector
		dir_to_orbiting_point = g_zero_vector
		orbit_tangent_vector = g_zero_vector
	}
}
