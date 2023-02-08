

/*!
	@short	Engine binding.
*/
class		Engine
{
	handle			=	0;

	function		ResetClock()
	{	EngineResetClock(handle);	}
	function		SetClockScale(scale)
	{	EngineSetClockScale(handle, scale);	}
	function		GetClockScale()
	{	return EngineGetClockScale();	}
	function		SetFixedDeltaFrame(delta)
	{	EngineSetFixedDeltaFrame(handle, delta);	}

	function		LoadTexture(path)
	{	return Texture(EngineLoadTexture(handle, path));	}
	function		LoadTextureBypassCache(path)
	{	return Texture(EngineLoadTextureBypassCache(handle, path));	}
	function		CreateTexture(width, height, render_target)
	{	return Texture(EngineCreateTexture(handle, width, height, render_target));	}

	function        LoadSound(path)
	{	return Sound(EngineLoadSound(handle, path));	}

	function		DeleteTexture(texture)
	{	EngineDeleteTexture(handle, texture.GetHandle());   }

	function		GetHandle()
	{	return handle;	}
	constructor()
	{	handle = g_engine;	}
}
