/*
	File: scripts/music_tracker.nut
	Author: Astrofra
*/

/*!
	@short	MusicTrack
	@author	Astrofra
*/
class	MusicTrack
{
	music_path			=	0
	music_channel		=	0
	gain				=	1.0
	target_gain			=	1.0

	function	Update()
	{
		gain += (target_gain - gain) * g_dt_frame * 2.0
		gain = Clamp(gain, 0.0, 1.0)
		MixerChannelSetGain(g_mixer, music_channel, gain)
	}

	function	Feed(_current_clip)
	{
		print("MusicTrack::Feed()")
		music_path = 0

		if ("music" in _current_clip)
		{
			print("MusicTrack::Feed() Found 'music' key.")
			if ("command" in _current_clip.music)
			{
				print("MusicTrack::Feed() Found 'command' = " + _current_clip.music.command)
				switch(_current_clip.music.command)
				{
					case "FadeOut":
							target_gain = 0.0
						break

					case "Start":
						if ("file" in _current_clip.music)
						{
							local	_filename
							_filename = "tmp/" + _current_clip.music.file + ".ogg"
							if (!FileExists(_filename))
								_filename = "archived_files/" + _current_clip.music.file + ".ogg"
							if (FileExists(_filename))
							{
								MixerChannelStartStream(g_mixer, music_channel, _filename)
								if ("gain" in _current_clip.music)
								{
									gain = _current_clip.music.gain
									target_gain = gain
									MixerChannelSetGain(g_mixer, music_channel, gain)
								}
							}
							else
								print("MusicTrack::Feed() Cannot find file '" + _filename + "'.")
						}
						else
							print("MusicTrack::Feed() No 'file' key found!")
						break

					case "Stop":
						MixerChannelStop(g_mixer, music_channel)
						break
				}
			}
		}
	}

	function	Delete()
	{
		print("MusicTrack::Delete()")
		MixerChannelStop(g_mixer, music_channel)
		MixerChannelSetGain(g_mixer, music_channel, 1.0)
		MixerChannelUnlock(g_mixer, music_channel)
	}

	constructor()
	{
		print("MusicTrack::constructor()")
		music_channel = MixerChannelLock(g_mixer)
	}

}
