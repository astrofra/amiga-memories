/*
	File: scripts/special_events/boing_ball-physics.nut
	Author: Astrofra
*/

/*!
	@short	EventBoingBallPhysics
	@author	Astrofra
*/
class	EventBoingBallPhysics
{
	body		=	0
	speed		=	1.0

	max_self	=	0.25
	self_illum	=	0.0
	materials	=	0
	light		=	0

	clock		=	0
	dead		=	false
	start_delay	=	0
	dispatch	=	0

	function	OnUpdate(item)
	{
		if (dead)
			return

		if	(dispatch !=	0)
			dispatch()

		UpdateLight()

		self_illum -= (g_dt_frame * 2.0)
		self_illum = Clamp(self_illum, 0.0, max_self)
	}

	function	UpdateLight()
	{
		foreach(_mat in materials)
			MaterialSetSelf(_mat, MaterialGetDiffuse(_mat).Scale(self_illum))

		LightSetDiffuseIntensity(light, self_illum)
		LightSetSpecularIntensity(light, self_illum)
	}

	function	WaitForStartDelay()
	{
		if ((g_clock - clock) > SecToTick(start_delay))
			dispatch = StartPhysic
	}

	function	StartPhysic()
	{
		local	_rand = Vector(0,0,0)
		_rand.x = Rand(-1.0, 1.0)
		_rand.y = Rand(-1.0, 0.0) * 0.1
		_rand.z = Rand(-1.0, 1.0)
		_rand = _rand.Normalize()

		ItemPhysicSetLinearFactor(body, Vector(1,1,1))
		ItemPhysicSetAngularFactor(body, Vector(0.5,0.5,0.5))
		ItemApplyLinearImpulse(body, _rand.Scale(0.1))

		dispatch = 0
	}

	function	EventStart()
	{
		clock = g_clock
		dispatch = WaitForStartDelay
	}

	function	OnCollisionEx(item, item_with, contact_list, direction)
	{
		local	_imp, _torque

		self_illum = max_self
		UpdateLight()

		foreach(_n in contact_list.n)
		{
			local	_rand = Vector(0,0,0)
			_rand.x = Rand(-1.0, 1.0)
			_rand.y = Rand(-1.0, 1.0)
			_rand.z = Rand(-1.0, 1.0)
			_imp = (_n + _rand).Normalize()
			_torque = EulerFromDirection(_imp)
			ItemApplyLinearImpulse(item, _imp.Scale(0.1))
			ItemApplyTorque(item, _torque.Scale(100.0 * ItemGetMass(item)))
		}
	}

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function	OnPhysicStep(item, dt)
	{
		if (dead)
			return

		ItemApplyLinearForce(body, Vector(0,-0.1,0).Scale(speed * ItemGetMass(body)))
	}

	function	OnExitTrigger(item, trigger)
	{
		if (ItemGetName(trigger) == "trigger_off_screen")
		{
			print("EventBoingBallPhysics::OnExitTrigger() Died !!!")
			Die(item)
		}
	}

	function	Die(item)
	{
		SceneItemActivateHierarchy(g_scene, item, false)
		ItemSetPhysicMode(item, PhysicModeNone)
		dead = true
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		body = item
		ItemPhysicSetLinearFactor(body, g_zero_vector)
		ItemPhysicSetAngularFactor(body, g_zero_vector)
		SceneSetGravity(g_scene, g_zero_vector)
		speed = Rand(0.9, 1.1)
		start_delay = Sec(Rand(0.0, 5.0))
		dispatch	=	0

		//	Find Light
		light = ItemCastToLight(ItemGetChild(item, "ball_light"))
		LightSetDiffuseIntensity(light, 0.0)
		LightSetSpecularIntensity(light, 0.0)

		//	Find Materials
		materials = []
		local	_mesh = ItemGetChild(item, "boing_ball_mesh")
		local	_geo = ItemGetGeometry(_mesh)
		materials.append(GeometryGetMaterialFromIndex(_geo, 0))
		materials.append(GeometryGetMaterialFromIndex(_geo, 1))

		print("EventBoingBallPhysics::OnSetup() speed = " + speed.tostring() + ", start_delay = " + start_delay.tostring() + " sec.")
	}
}
