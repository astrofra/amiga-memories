

/*!
	@short	Texture binding.
*/
class		Texture
{
	handle			=	0;

	function		SetStreamState(state)
	{	TextureSetStreamState(handle, state);	}

	function		GetPicture()
	{	return Picture(TextureGetPicture(handle));	}

	function        LoadContent(path)
	{	return GetPicture().LoadContent(path);	}
	function		Update()
	{	TextureUpdate(handle);	}

	function        Null()
	{	return Texture(NullTexture);	}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}
