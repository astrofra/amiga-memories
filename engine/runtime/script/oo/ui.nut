

/*!
	@short	UI binding.
*/
class		UI
{
	handle			=	0;

	function		LoadFont(font)
	{	WindowSystemLoadFont(font);	}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}
