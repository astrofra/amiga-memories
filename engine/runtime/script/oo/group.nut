

/*!
	@short	Group binding.
*/
class		Group
{
	handle			=	0;

	/// Setup all group items.
	function	Setup()
	{	GroupSetup(handle);	}
	/// Reset all group items.
	function	Reset()
	{	GroupReset(handle);	}

	/// Get group root item.
	function	GetRootItem()
	{	GroupGetRootItem(handle);	}
	/// Set group root item.
	function	SetRootItem(item)
	{	GroupSetRootItem(handle, item);	}

	/// Activate/deactivate all items in group.
	function	Activate(activate)
	{	GroupActivate(handle, activate);	}
	/// Find item in group from its identifier.
	function	FindItem(id)
	{	return Item(GroupFindItem(handle, id));	}
	/// Find a physic constraint in group.
	function	FindConstraint(id)
	{	return GroupFindConstraint(handle, id);	}

	/// Test if an item is a member of the group.
	function	ItemIsMember(item)
	{	return GroupItemIsMember(handle, item.GetHandle());	}
	/// Offset group by a 4x4 matrix.
	function	OffsetMatrix(matrix)
	{	GroupOffsetMatrix(handle, matrix);	}

	/// Set group as invisible.
	function	SetInvisible(invisible)
	{	GroupSetInvisible(handle, invisible);	}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}