/*
*/


/*!
	@short	Object binding.
*/
class		Object
{
	handle			=	0;

	/// Get object geometry.
	function		GetGeometry()
	{	return Geometry(ObjectGetGeometry(handle));	}

	/// Get object item.
	function		GetItem()
	{	return Item(ObjectGetItem(handle));	}	
}