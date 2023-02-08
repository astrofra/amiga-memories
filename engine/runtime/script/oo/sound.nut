

/*!
	@short	Sound binding.
*/
class		Sound
{
	handle			=	0;

	function        GetDuration()
	{	return SoundGetDuration(handle);	}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}
