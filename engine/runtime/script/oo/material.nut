

/*!
	@short	Material binding.
*/
class		Material
{
	handle			=	0;

	/// Set channel texture.
	function		ChannelSetTexture(channel, texture)
	{	MaterialChannelSetTexture(handle, texture.GetHandle(), channel);	}
	/// Get channel texture.
	function		ChannelGetTexture(channel)
	{	return Texture(MaterialChannelGetTexture(handle, channel));	}

	/// UV Matrix
	function		ChannelGetUVMatrix(channel)
	{	return MaterialChannelGetUVMatrix(handle, channel);	}

	function		ChannelSetUVMatrix(channel, matrix)
	{	return MaterialChannelSetUVMatrix(handle, channel, matrix);	}
	
	function		Update()
	{	MaterialUpdate(handle);	}

	/// Set self-illumination color.
	function		SetSelfIllum(color)
	{	MaterialSetSelfIllum(handle, color);	}

	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}
