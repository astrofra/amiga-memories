

/*!
	@short	Mixer binding.
*/
class		Mixer
{
	handle			=	0;
	
	function        SoundStart(sound)
	{	MixerSoundStart(handle, sound.GetHandle());	}
	function        ChannelLock()
	{	return	MixerChannelLock(handle);	}
	function        ChannelStart(channel, sound)
	{	MixerChannelStart(handle, channel, sound.GetHandle());	}
	function        ChannelStop(channel)
	{	MixerChannelStop(handle, channel);	}
	function        ChannelStopAll()
	{	MixerChannelStopAll(handle);	}
	
	function		GetHandle()
	{	return handle;	}
	constructor(h)
	{	handle = h;	}
}
