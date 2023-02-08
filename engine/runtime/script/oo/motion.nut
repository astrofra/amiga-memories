

/*!
	@short	Motion binding.
*/
class		Motion
{
	handle			=	0;

	function        EvaluatePosition(t)
	{	return MotionEvaluatePosition(handle, t);	}
	function        GetLength()
	{	return MotionGetLength(handle);	}
	function    	GetName()
	{	return MotionGetName(handle);	}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}
