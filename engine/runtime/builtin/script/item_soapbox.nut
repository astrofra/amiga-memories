class	BuiltinItemSoapbox
{
/*<
	<Script =
		<Name = "Soapbox">
		<Author = "Emmanuel Julien">
		<Description = "A simple physic soapbox.">
		<Category = "Physics">
		<Documentation = "doc://builtin/item_soapbox.htm">
		<Requires = <RigidBody>>
	>
	<Parameter =
		<ray_prefix = <Name = "Ray prefix"> <Description = "Name prefix of the items whose position is used as the ray origin."> <Type = "String"> <Default = "ray">>
		<ray_reach = <Name = "Ray reach (m)"> <Description = "The maximum distance to the ground from the ray origin until ground contact is lost."> <Type = "Float"> <Default = 0.15>>
		<spring_a0 = <Name = "Spring dampening"> <Description = "Spring stabilisation factor."> <Type = "Float"> <Default = 0.2>>
		<spring_a1 = <Name = "Spring strength"> <Description = "Spring rigidity."> <Type = "Float"> <Default = 5.0>>
		<thrust_name = <Name = "Thrust item"> <Description = "Thrust will be applied at this item position."> <Type = "Item"> <Default = "thrust">>
		<thrust = <Name = "Thrust power"> <Description = "Thrust force multiplier."> <Type = "Float"> <Default = 240.0>>
		<stabilization = <Name = "Stabilization"> <Description = "Higher values prevent the box from tumbling over by restricting angular motion on the X and Z axises."> <Type = "Float"> <Default = 0.0>>
	>
>*/

	//--------------------------------------------------------------------------
	ray_prefix			=	"ray"
	ray_reach			=	Mtr(0.15)

	spring_a0			=	0.2
	spring_a1			=	5.0

	thrust_name			=	"thrust"
	thrust				=	240.0

	stabilization		=	0.0
	//--------------------------------------------------------------------------

	pad					=	null

	body_item			=	0
	thrust_item			=	0
	ray_position		=	0
	ray_count			=	0

	is_accel			=	false

	//--------------------------------------------------------------------------
	function	GetSpeed()
	{	return ItemGetLinearVelocity(body_item).Dot(body_item.matrix().GetRow(2))	}
	function	GetBodyItem()
	{	return body_item	}
	function	IsAccelerating()
	{	return is_accel		}

	//--------------------------------------------------------------------------
	function	OnSetup(item)
	{
		print("Physic Soapbox setup")

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

		body_item = item

		ItemPhysicSetAngularFactor(item, Vector(1.0, 1.0, 1.0 - stabilization))
	}

	/*--------------------------------------------------------------------------
		Extend this class and reimplement this function to provide a more
		complex tire friction model (eg. pacejka).
	--------------------------------------------------------------------------*/
	function	SpringFriction(index, item, matrix, ray_d, lg_speed)
	{
		local	wp = ray_position[index].ApplyMatrix(matrix)
		local	wv = ItemWorldPointVelocity(item, wp)
		local	hit = SceneCollisionRaytrace(g_scene, wp, ray_d, -1, 1, ray_reach)

		if	(hit.hit)
		{
			// Apply spring force & friction.
			if	(hit.d < ray_reach)
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
			}
		}

		try		{	OnWheelUpdate(index, hit)	}	catch(e) {}

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

		ControlLocalSpace(item, 1.0 / 100.0)
	}

	//--------------------------------------------------------------------------
	function	ControlLocalSpace(item, dt)
	{
		is_accel = false

		local	k = ItemGetMass(item) * thrust.tofloat() * dt

		if	((pad != null) && DeviceIsAvailable(pad))
		{
			DeviceUpdate(g_pad_0)

			if	(DevicePoolFunction(g_pad_0, DeviceLeft))
				ItemApplyTorque(item, Vector(0.0, -1.0 * k, 0.0))
			if	(DevicePoolFunction(g_pad_0, DeviceRight))
				ItemApplyTorque(item, Vector(0.0, 1.0 * k, 0.0))
	
			local	matrix = ItemGetMatrix(item)
			if	(DevicePoolFunction(g_pad_0, DeviceUp))
			{
				is_accel = true
				ItemApplyForce(item, ItemGetWorldPosition(thrust_item), matrix.GetRow(2).MulReal(1.5 * k))
			}
			if	(DevicePoolFunction(g_pad_0, DeviceDown))
				ItemApplyForce(item, ItemGetWorldPosition(thrust_item), matrix.GetRow(2).MulReal(-1.0 * k))
		}
		else
		{
			local	device = GetKeyboardDevice()
	
			if	(DeviceIsKeyDown(device, KeyLeftArrow))
				ItemApplyTorque(item, Vector(0.0, -1.0 * k, 0.0))
			if	(DeviceIsKeyDown(device, KeyRightArrow))
				ItemApplyTorque(item, Vector(0.0, 1.0 * k, 0.0))
	
			local	matrix = ItemGetMatrix(item)
			if	(DeviceIsKeyDown(device, KeyUpArrow))
			{
				is_accel = true
				ItemApplyForce(item, ItemGetWorldPosition(thrust_item), matrix.GetRow(2).MulReal(1.5 * k))
			}
			if	(DeviceIsKeyDown(device, KeyDownArrow))
				ItemApplyForce(item, ItemGetWorldPosition(thrust_item), matrix.GetRow(2).MulReal(-1.0 * k))
		}
	}
}
