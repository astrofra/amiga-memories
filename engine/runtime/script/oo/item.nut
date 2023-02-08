

/*!
	@short	Item binding.
*/
class		Item
{
	function		name()
	{	return ItemGetName(this);	}

	function		position()
	{	return ItemGetPosition(this);	}
	function		worldPosition()
	{	return ItemGetWorldPosition(this);	}
	function		setPosition(p)
	{	ItemSetPosition(this, p);	}	
	function		setTarget(p)
	{	ItemSetTarget(this, p);	}
	
	function		rotation()
	{	return ItemGetRotation(this);	}
	function		setRotation(r)
	{	ItemSetRotation(this, r);	}
	
	function		scale()
	{	return ItemGetScale(this);	}
	function		setScale(s)
	{	ItemSetScale(this, s);	}
	
	function		rotationMatrix()
	{	return ItemGetRotationMatrix(this);	}

	function		motion(id)
	{	return Motion(ItemGetMotion(this, id));	}
	function		setMotion(slot, motion, blend = 0, weight = 1, start = 0, scale = 1)
	{	ItemSetMotion(this, slot, motion.GetHandle(), blend, weight, start, scale);	}
	function        stopMotion()
	{	ItemStopMotion(this);	}
	function        motionSlotStop(slot)
	{	ItemMotionSlotStop(this, slot);	}

	function		activate(active = true)
	{	ItemActivate(this, active);	}
	function		activateHierarchy(active = true)
	{	ItemActivateHierarchy(this, active);	}

	function		setInvisible(invisible = false)
	{	ItemSetInvisible(this, invisible);	}
	function		isValid()
	{	return ItemIsValid(this);	}

	function        alpha()
	{	return ItemGetAlpha(this);	}
	function        setAlpha(alpha)
	{	ItemSetAlpha(this, alpha);	}

	function		setupScript()
	{	ItemSetupScript(this);	}
	function		scriptInstance()
	{	return ItemGetScriptInstance(this);	}

	function		setCommandList(list)
	{	ItemSetCommandList(this, list);	}
	function		isCommandListDone()
	{	return ItemIsCommandListDone(this);	}

	function		geometry()
	{	return Geometry(ObjectGetGeometry(ItemCastToObject(this)));	}
	function		setGeometry(g)
	{	ObjectSetGeometry(ItemCastToObject(this), g);	}

	function		setGeometryFromFile(path)
	{	ObjectSetGeometry(ItemCastToObject(this), EngineLoadGeometry(g_engine, path));	}
}
