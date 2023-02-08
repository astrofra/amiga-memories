/*
	File: scripts/utils/physic_item_xz_plane.nut
	Author: P. Blanche - F. Gutherz
*/

g_gravitational_constant <-	6.6742 / Pow(10.0, 11.0)

/*!
	@short	PhysicItemZPlane
	@author	P. Blanche - F. Gutherz
*/
class	PhysicItemXZPlane
{
	body						=	0
	bounding_box				=	0
	mass						=	0
	linear_damping				=	0.0
	angular_damping				=	0.0
	position 					= 	0
	linear_velocity				=	0
	prev_linear_velocity		=	0
	angular_velocity			=	0
	linear_acceleration			=	0

	attraction_forces_list		=	0

	function	OnSetup(item)
	{
		body = item
		mass = ItemGetMass(body)
		bounding_box = ItemGetMinMax(item)
		ItemPhysicSetLinearFactor(item, Vector(1,0,1))
		ItemPhysicSetAngularFactor(item, Vector(0,1,0))
		linear_velocity = g_zero_vector
		prev_linear_velocity = g_zero_vector
		angular_velocity = g_zero_vector
		linear_acceleration = g_zero_vector
		position = ItemGetWorldPosition(item)
		attraction_forces_list = []
	}

	function	OnPhysicStep(item, dt)
	{
		linear_velocity = ItemGetLinearVelocity(item)
		angular_velocity = ItemGetAngularVelocity(item)
		linear_acceleration = linear_velocity - prev_linear_velocity
		position = ItemGetWorldPosition(item)

		if (linear_damping > 0.0)
		{
			local	_scale = Clamp(linear_damping, 0.0, 1.0) * -1.0 * mass
			ItemApplyLinearForce(item, linear_velocity.Scale(_scale))
		}

		if (angular_damping > 0.0)
		{
			local	_scale = Clamp(angular_damping, 0.0, 1.0) * -1.0 * mass
			ItemApplyTorque(item, angular_velocity.Scale(_scale))
		}

		foreach(_F in attraction_forces_list)
			ItemApplyLinearForce(item, _F.Scale(mass))

		attraction_forces_list = []

		prev_linear_velocity = clone(linear_velocity)
	}

	function	RenderUser(scene)
	{
		RendererDrawLineColored(g_render, position, position + linear_acceleration.Scale(10.0), Vector(1,0,1))
	}

	function	ApplyAttraction(_F)
	{
		attraction_forces_list.append(_F)
	}

	function	SetAngularDamping(_value)
	{
		angular_damping = _value
	}

	function	SetLinearDamping(_value)
	{
		linear_damping = _value
	}

}
