

/*!
	@short	Camera binding.
*/
class		Camera	extends	ItemDerived
{
	handle			=	0;

	function		GetItem()
	{	return Item(CameraGetItem(handle));	}

	function		SetAspectRatio(ar = -1)
	{	CameraSetAspectRatio(handle, ar);	}
	function		GetAspectRatio(ar)
	{	return CameraGetAspectRatio(handle);	}
	function		SetAspectRatioVertical(is_vertical = false)
	{	CameraSetAspectRatioRefAxis(handle, is_vertical);	}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}
