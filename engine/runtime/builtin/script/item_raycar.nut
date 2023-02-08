class	BuiltinItemRaycar
{
/*<
	<Script =
		<Name = "Raycast Car">
		<Author = "Emmanuel Julien">
		<Description = "A simple physic ray car.">
		<Documentation = "doc://builtin/item_raycar.htm">
		<Category = "Physics/Vehicle">
		<Requires = <RigidBody>>
	>
	<Parameter =
		<ray_prefix = <Name = "Ray prefix"> <Description = "Name prefix of the items whose position is used as the ray origin."> <Type = "String"> <Default = "ray">>
		<ray_reach = <Name = "Ray reach (m)"> <Description = "The maximum distance to the ground from the ray origin until ground contact is lost."> <Type = "Float"> <Default = 0.15>>
		<spring_a0 = <Name = "Spring dampening"> <Description = "Spring stabilisation factor."> <Type = "Float"> <Default = 0.2>>
		<spring_a1 = <Name = "Spring strength"> <Description = "Spring rigidity."> <Type = "Float"> <Default = 5.0>>
		<wheel_radius = <Name = "Wheel radius (m)"> <Description = "Wheel radius."> <Type = "Float"> <Default = 0.5>>

		<thrust_name = <Name = "Thrust item"> <Description = "Thrust will be applied at this item position."> <Type = "Item"> <Default = "thrust">>
		<thrust = <Name = "Thrust power"> <Description = "Thrust force multiplier."> <Type = "Float"> <Default = 240.0>>
	>
>*/

	//--------------------------------------------------------------------------
	ray_prefix			=	"ray"
	ray_reach			=	Mtr(0.15)

	spring_a0			=	0.2
	spring_a1			=	5.0

	thrust_name			=	"thrust"
	thrust				=	240.0

	wheel_radius		=	0.5
	//--------------------------------------------------------------------------

	pad					=	null

	body_item			=	0
	thrust_item			=	0
	ray_position		=	0
	ray_count			=	0

	front_left_wheel	=	0
	front_right_wheel	=	0
	front_angle			=	0
	rear_wheel			=	0

	wheel_contact		=	0

	//--------------------------------------------------------------------------
	function	GetSpeed()
	{	return ItemGetLinearVelocity(body_item).Dot(body_item.matrix().GetRow(2))	}
	function	GetBodyItem()
	{	return body_item	}
	function	HasWheelContact(index)
	{	return wheel_contact[index]	}

	//--------------------------------------------------------------------------
	function	OnSetup(item)
	{
		ray_position = []
		for	(local n = 0; true; ++n)
		{
			try
			{
				local ray_item = SceneFindItemChild(g_scene, item, ray_prefix + n)
				ray_position.append(ItemGetPosition(ray_item))
			}
			catch (e)
			{	break	}
		}
		ray_count = ray_position.len()
		thrust_item = SceneFindItemChild(g_scene, item, thrust_name)

		front_left_wheel = SceneFindItemChild(g_scene, item, "wheel0")
		front_right_wheel = SceneFindItemChild(g_scene, item, "wheel1")
		rear_wheel = SceneFindItemChild(g_scene, item, "wheel2")

		body_item = item
		wheel_contact = array(ray_count, false)
	}

	//--------------------------------------------------------------------------
	function	GetWheelItem(index)
	{
		switch (index)
		{
			case 0:	return front_left_wheel
			case 1:	return front_right_wheel
			case 2:	return rear_wheel
			case 3:	return rear_wheel
		}
		throw("Invalid wheel item index " + index)
	}

	//--------------------------------------------------------------------------
	function	SpringFriction(index, item, matrix, ray_d, lg_speed)
	{
		local	wp = ray_position[index].ApplyMatrix(matrix)
		local	wv = ItemWorldPointVelocity(item, wp)
		local	hit = SceneCollisionRaytrace(g_scene, wp, ray_d, -1, 1, ray_reach)

		// Apply spring force & friction.
		local	wheel_item = GetWheelItem(index)
		local	wheel_r = wheel_item.rotation()

		wheel_contact[index] = (hit.hit) && (hit.d < ray_reach)
		if	(wheel_contact[index])
		{
			local	wv = ItemWorldPointVelocity(item, wp).Reverse()

			// Spring.
			local	wad = hit.n.Dot(wv), wva
			if	(wad < 0.0)
					wva = Vector(0, 0, 0)
			else	wva = hit.n.MulReal(wad)
			ItemApplyImpulse(item, wp, wva.MulReal(spring_a0))

			local	k_dst = sqrt(ray_reach - hit.d) * spring_a1
			ItemApplyForce(item, wp, hit.n.MulReal(k_dst * ItemGetMass(item)))

			// Lateral friction.
			local	vlat = wheel_item.matrix().GetRow(0)

			local	wvl = vlat.MulReal(vlat.Dot(wv))
			ItemApplyImpulse(item, wp, wvl.MulReal(0.05))

			// Adjust wheel on the ground.
			local	wheel_p = wheel_item.position()
			wheel_p.y = ray_position[index].y - hit.d + wheel_radius
			wheel_item.setPosition(wheel_p)

			// Adjust wheel rotational speed.
			if	(index != 3)
			{
				local	vlat = item.matrix().GetRow(2).Dot(ItemGetLinearVelocity(item))
				local	vr = (vlat / wheel_radius)
				wheel_r.x += DegreeToRadian(vr)
			}
		}
		else
			wheel_r.x *= 0.99

		wheel_item.setRotation(wheel_r)
		return hit;
	}

	//--------------------------------------------------------------------------
	function	OnPhysicStep(item, step_taken)
	{
		if	(!step_taken)
			return			// Engine did not update item physic state, skip.

		local	matrix = ItemGetMatrix(item)
		local	ray_d = matrix.GetRow(1).Reverse()

		local	linear_v = ItemGetLinearVelocity(item)
		local	lg_speed = matrix.GetRow(2).Dot(linear_v)
		local	resistance = 0.0;
		for	(local n = 0; n < ray_count; ++n)
			if	(SpringFriction(n, item, matrix, ray_d, lg_speed).hit)
				resistance++

		// Linear resistance.
		resistance /= ray_count
		ItemApplyLinearImpulse(item, linear_v.MulReal(-0.0075 * resistance))

		// Rotational resistance.
		local	angular_v = ItemGetAngularVelocity(item)
		angular_v.y *= 1.0 - (resistance) * 0.04
		ItemSetAngularVelocity(item, angular_v)
	}

	//--------------------------------------------------------------------------
	function	ControlLocalSpace(item, dt)
	{
		local	k = ItemGetMass(item) * thrust.tofloat() * dt

		KeyboardUpdate()

		if	(KeyboardSeekFunction(DeviceKeyPress, KeyLeftArrow))
			front_angle += (Deg(-40) - front_angle) * 0.1
		else	if	(KeyboardSeekFunction(DeviceKeyPress, KeyRightArrow))
			front_angle += (Deg(40) - front_angle) * 0.1
		else
			front_angle += (Deg(0) - front_angle) * 0.1

		local	r = front_left_wheel.rotation()
		r.y = front_angle
		front_left_wheel.setRotation(r)
		r = front_right_wheel.rotation()
		r.y = front_angle
		front_right_wheel.setRotation(r)

		local	matrix = ItemGetMatrix(item),
				thrust_k = ((HasWheelContact(0) ? 1 : 0) + (HasWheelContact(1) ? 1 : 0)) / 2.0

		if	(KeyboardSeekFunction(DeviceKeyPress, KeyUpArrow))
			ItemApplyForce(item, ItemGetWorldPosition(thrust_item), matrix.GetRow(2).MulReal(1.5 * k * thrust_k))
		if	(KeyboardSeekFunction(DeviceKeyPress, KeyDownArrow))
			ItemApplyForce(item, ItemGetWorldPosition(thrust_item), matrix.GetRow(2).MulReal(-1.0 * k * thrust_k))
	}

	//--------------------------------------------------------------------------
	function	OnUpdate(item)
	{
		ControlLocalSpace(item, g_dt_frame)
	}
}
