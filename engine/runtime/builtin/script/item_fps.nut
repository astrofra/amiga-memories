class	BuiltinCharacterController
{
/*<
	<Script =
		<Name = "1st Person Camera">
		<Author = "Emmanuel Julien">
		<Description = "Typical controls for a movable character.">
		<Category = "Game/Camera">
		<Compatibility = <Camera>>
	>
	<Parameter =
		<height = <Name = "Height (m)"> <Type = "Float"> <Default = 1.80>>
		<radius = <Name = "Width (m)"> <Type = "Float"> <Default = 0.7>>
		<mass = <Name = "Mass (Kg)"> <Type = "Float"> <Default = 5>>
		<speed = <Name = "Speed (m/s)"> <Type = "Float"> <Default = 0.35>>
		<boxshape = <Name = "Use a Sphere as collision."> <Type = "Bool"> <Default = False>>
	>
>*/
	height		=	1.8
	radius		=	0.7
	mass		=	1
	speed		=	0.35
	boxshape	=	false

	body		=	0

	acc			=	0
	euler		=	0

	function	CreateBody(item)
	{
		// Create the body object.
		body = ObjectGetItem(SceneAddObject(ItemGetScene(item), "Body"))
		ItemSetPosition(body, ItemGetWorldPosition(item))

		// Create the body capsule collision shape.
		local shape = ItemAddCollisionShape(body)

		if	(!boxshape)
			ShapeSetCapsule(shape, radius, height)
		else	
			ShapeSetSphere(shape, Max(radius, height))

		ShapeSetRotation(shape, Vector(Deg(90), 0, 0))
		ShapeSetPosition(shape, Vector(0, 0, 0))
		ShapeSetMass(shape, mass)
		ShapeSetFriction(shape, 0.2, 0.2)
		ShapeSetRestitution(shape, 0)

		ItemSetPhysicMode(body, PhysicModeDynamic)
		ItemPhysicSetAngularFactor(body, Vector(0, 0, 0))

		// Parent this to the body object and move to 90% of the total height.
		ItemSetNoTarget(item)
		ItemSetParent(item, body)
		ItemSetPosition(item, Vector(0, height * 0.9, 0))
	}

	function	OnSetup(item)
	{
		CreateBody(item)
		acc = Vector(0, 0, 0)
		euler = Vector(0, 0, 0)
	}

	function	OnUpdate(item)
	{
		local	keyboard = GetKeyboardDevice(),
				mouse = GetMouseDevice()

		local	old_mx = DeviceInputLastValue(mouse, DeviceAxisX),
				old_my = DeviceInputLastValue(mouse, DeviceAxisY)
		local	mx = DeviceInputValue(mouse, DeviceAxisX),
				my = DeviceInputValue(mouse, DeviceAxisY)

		DeviceInputSetValue(mouse, DeviceAxisX, 0.5)
		DeviceInputSetValue(mouse, DeviceAxisY, 0.5)

		acc = Vector(0, 0, 0)
		euler = ItemGetRotation(item) + Vector(my - old_my, mx - old_mx, 0) * Deg(360.0)

		if	(euler.x < Deg(-60))
			euler.x = Deg(-60)
		if	(euler.x > Deg(60))
			euler.x = Deg(60)
		ItemSetRotation(item, euler)

		if	(DeviceKeyPressed(keyboard, KeySpace))
			ItemApplyLinearImpulse(body, ItemGetMatrix(item).GetRow(1).MulReal(25.0 * speed))

		if	(DeviceIsKeyDown(keyboard, KeyUpArrow) || DeviceIsKeyDown(keyboard, KeyZ) || DeviceIsKeyDown(keyboard, KeyW))
			acc = Vector(0, 0, 1)
		if	(DeviceIsKeyDown(keyboard, KeyDownArrow) || DeviceIsKeyDown(keyboard, KeyS))
			acc = Vector(0, 0, -1)
		if	(DeviceIsKeyDown(keyboard, KeyLeftArrow) || DeviceIsKeyDown(keyboard, KeyQ) || DeviceIsKeyDown(keyboard, KeyA))
			acc = Vector(-1, 0, 0)
		if	(DeviceIsKeyDown(keyboard, KeyRightArrow) || DeviceIsKeyDown(keyboard, KeyD))
			acc = Vector(1, 0, 0)

		if	(DeviceIsKeyDown(keyboard, KeyLShift))
			acc *= 2.5

		ItemApplyLinearImpulse(body, acc * RotationMatrixY(euler.y) * speed)

		// FIXME this is framerate dependent.
		ItemSetLinearVelocity(body, ItemGetLinearVelocity(body) * Vector(0.94, 1.0, 0.94))
	}
}
