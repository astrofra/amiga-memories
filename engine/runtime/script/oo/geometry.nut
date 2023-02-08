

/*!
	@short	Geometry binding.
*/
class		Geometry
{
	handle			=	0;

	function		IsValid()
	{	return GeometryIsValid(handle);	}
	function		GetMaterial(id)
	{	return Material(GeometryGetMaterial(handle, id));	}
	function		GetMaterialFromIndex(idx)
	{	return Material(GeometryGetMaterialFromIndex(handle, idx));	}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}