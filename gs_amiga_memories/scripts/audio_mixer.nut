/*
	File: scripts/audio_mixer.nut
	Author: Astrofra
*/

/*!
	@short	AudioMixer
	@author	Astrofra
*/

class	AudioMixer
{
	edit_list			=	0
	sample_library		=	0
	current_track		=	0
	max_track_amount	=	4
	mix_sample_rate		=	44100

	tracks				=	{	voice_over = 0, floppy = 1, paula_0 = 2, paula_1 = 3, paula_2 = 4, paula_3 = 5	}

	constructor()
	{
		print("AudioMixer::constructor()")
		edit_list = array(max_track_amount,0)
		for(local n = 0; n < max_track_amount;n++)
			edit_list[n] = []
		sample_library = {}
	}

	function	Delete()
	{
		for(local n = 0; n < max_track_amount;n++)
		{
			MixerChannelStop(g_mixer, n)
			MixerChannelSetLoopMode(g_mixer, n, LoopNone)
			MixerChannelSetGain(g_mixer, n, 1.0)
			MixerChannelSetPitch(g_mixer, n, 1.0)
			MixerChannelUnlock(g_mixer, n)
		}
	}

	function	PlaySound(sound_filename, timecode, track = -1)
	{
		local	folder_name = "tmp/"

		print("AudioMixer::PlaySound() sound_filename, timecode = " + sound_filename.tostring() + ", " + timecode.tostring())
		if (!FileExists("tmp/" + sound_filename))
		{
			if (FileExists("archived_files/" + sound_filename))
			{
				folder_name = "archived_files/"
			}
			else
			{
				print("AudioMixer::AudioSoundGetDuration() Cannot find '" + "tmp/" + sound_filename + "'")
				return 0
			}
		}

		//	Look for the sound in the library, load it if needed
		if (!(sound_filename in sample_library))
			sample_library.rawset(sound_filename, EngineLoadSound(g_engine, folder_name + sound_filename))

		//	Actually send the sound to the speakers
		if (g_enable_audio_output)	MixerSoundStart(g_mixer, sample_library[sound_filename])

		if (((typeof track) == "string") && (track in tracks))
			current_track = tracks[track]
		else
			current_track = 0

		//	Record it in the edit list
		AppendToEditList(sound_filename, timecode, current_track)
	}

	function	AppendToEditList(sound_filename, timecode, track)
	{
		print("AudioMixer::AppendToEditList() : sound_filename, timecode, track = " + sound_filename + ", " + timecode + ", " + track)

		timecode *= 0.1

		print("AudioMixer::AppendToEditList() : timecode (s) = " + (timecode / 1000.0).tostring())

		local	sound_duration = AudioSoundGetDuration(sound_filename)
		timecode = (timecode * mix_sample_rate / 1000.0).tointeger()
		sound_duration = (sound_duration * mix_sample_rate / 1000.0).tointeger()

		print("AudioMixer::AppendToEditList() : play_in = " + timecode.tostring())
		print("AudioMixer::AppendToEditList() : rec_out = " + sound_duration.tostring())

		edit_list[track].append({	source = sound_filename, 
									play_in = timecode, 
									play_out = timecode + sound_duration,
									rec_in = 0,
									rec_out = sound_duration,
									fade_in = 128,
									fade_out = 128
								})

		print("AudioMixer::AppendToEditList() : edit_list[" + track.tostring() + "].len() = " + edit_list[track].len().tostring())
	}

	function	AudioSoundGetDuration(filename)
	{
		if (!FileExists("tmp/" + filename))
		{
			print("AudioMixer::AudioSoundGetDuration() Cannot find '" + "tmp/" + filename + "'")
			return -1
		}

		local	slen = SoundGetDuration(ResourceFactoryLoadSound(g_factory, "tmp/" + filename))
//		slen = (((slen - 44) / 2.0) * 1000.0) / 16000.0
		print("AudioSoundGetDuration::slen = " + slen)
		return	slen
	}

	function	SaveEditListToFile(filename)
	{
		print("AudioMixer::SaveEditListToFile() : " + filename)
		local	edl	= []

		//	Semplitude EDL Header
		edl.append("Samplitude EDL File Format Version 1.5")
		edl.append("Title: \"Amiga Memories, exported from GameStart3D\"")
		edl.append("Sample Rate: " + mix_sample_rate.tostring())
		edl.append("Output Channels: 2")
		edl.append("\n")

		//	Source list
		edl.append("Source Table Entries: " + sample_library.len())
		local	source_idx = 1
		local	source_idx_table = {}
		foreach(sample_name, sample in sample_library)
		{
			edl.append(_TAB(3) + source_idx.tostring() + " \"" + g_current_path_dos + sample_name + "\"")
			source_idx_table.rawset(sample_name, source_idx)
			source_idx++
		}

		//	Line feed
		edl.append("")

		//	Track list
		local	track_idx 
		for(track_idx = 0; track_idx < max_track_amount; track_idx++)
		{
			print("AudioMixer::SaveEditListToFile() : track_idx = " + track_idx)

			//	Build Track Title
			local	track_idx_str = "Track " + (track_idx + 1).tostring()
			edl.append(track_idx_str + ": \"" +  track_idx_str + "\" Solo: 0 Mute: 0")

			//	Build Data Header
			local	track_header = ""
			track_header += "#Source Track Play-In"
			track_header += (_TAB(5) + "Play-Out")
			track_header += (_TAB(4) + "Record-In")
			track_header += (_TAB(3) + "Record-Out")
			track_header += (_TAB(2) + "Vol(dB)")
			track_header += (_TAB(2) + "MT")
			track_header += (_TAB(1) + "LK")
			track_header += (_TAB(1) + "FadeIn")
			track_header += (_TAB(7) + "%")
			track_header += (_TAB(5) + "CurveType")
			track_header += (_TAB(26) + "FadeOut")
			track_header += (_TAB(6) + "%")
			track_header += (_TAB(5) + "CurveType")
			track_header += (_TAB(26) + "Name ")

			edl.append(track_header)

			//	Build Separator
			local	n,c, track_separator = ""
			for(local n = 0; n < track_header.len(); n++)
			{
				c = track_header.slice(n, n + 1)
				switch(c)
				{
					case "#":
						c = "#"
						break
					default:
						c = "-"
						break
				}

				track_separator += c
			}

			edl.append(track_separator)

			foreach(clip in edit_list[track_idx])
			{
				print("AudioMixer::SaveEditListToFile() : source = " + clip.source)

				local	param = " "
				param += format("%6d", source_idx_table[clip.source])
				param += (" " + format("%5d", track_idx + 1))
				param += (" " + format("%11d", clip.play_in))
				param += (" " + format("%11d", clip.play_out))
				param += (" " + format("%11d", clip.rec_in))
				param += (" " + format("%11d", clip.rec_out))
				param += (" " + format("%8.2f", 0.0))			//	Vol(dB)
				param += (" " + format("%2d", 0))				//	MT
				param += (" " + format("%2d", 0))				//	LK
				param += (" " + format("%12d", clip.fade_in))	//	FadeIn
				param += (" " + format("%5d", 0))				//	%
				param += (" " + ("\"*default\"" + _TAB(24)))	//	CurveType
				param += (" " + format("%12d", clip.fade_out))	//	FadeOut
				param += (" " + format("%5d", 0))				//	%
				param += (" " + ("\"*default\"" + _TAB(24)))	//	CurveType
				param += (" " + "\"" + clip.source + "\"")		//	Name

				edl.append(param)
			}
			
			//	Line feed
			edl.append("")
		}

		//	Write down the list into a TXT file.
		local	str = ""
		foreach(line in edl)
			str += (line + "\r" + "\n")
		
		FileWriteFromString(g_current_path_engine + filename, str)
	}

	function	_TAB(n)
	{
		local	str = ""
		for(local i = 0; i < n; i++)
			str += " "
		return str
	}
}
