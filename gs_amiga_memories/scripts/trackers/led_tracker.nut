/*
	File: scripts/led_tracker.nut
	Author: Astrofra
*/

Include("scripts/floppy_disk.nut")

/*!
	@short	LedTrack
	@author	Astrofra
*/
class	LedTrack
{

	leds_handler			=	0
	audio_mixer				=	0
	list_led				=	0
	current_led				=	0
	current_led_index		=	0
	led_clock				=	0.0
	all_done				=	false

	function	Update()
	{
		leds_handler.Update()

		local	_clock = g_clock - led_clock
		if (all_done)
			return

		if (_clock > current_led.last_time)
			GetNextLeds()
	}

	function	GetNextLeds()
	{
		print("LedTrack::GetNextLeds()")
		if (current_led_index < list_led.len())
		{
			current_led = list_led[current_led_index]

			if (current_led.power)
				leds_handler.SetPowerOn()
			else
				leds_handler.SetPowerOff()

			if (current_led.drive)
				leds_handler.SetDriveOn()
			else
				leds_handler.SetDriveOff()

			current_led_index++
		}
		else
			all_done = true
	}

	function	Feed(_current_clip)
	{
		print("LedTrack::Feed()")
		local	clip_duration, key
		local	text = _current_clip.text
		key = SHA1(text)
		all_done = false
		LipSyncNutInclude(key)
		led_clock = g_clock
		clip_duration = GetSubtitleDuration()

		list_led = []
		current_led_index = 0
		local	led_time = 0.0

		if ("led" in _current_clip)
		{
			foreach(_led in _current_clip.led)
			{
				led_time += clip_duration / (_current_clip.len().tofloat())
				list_led.append({power = _led.power, drive = _led.drive, last_time = led_time})
			}
		}

		GetNextLeds()

	}

	//-------------------------
	function	GetSubtitleDuration()
	//-------------------------
	{
		print("SubtitleTrack::GetSubtitleDuration()")
		local _last_idx = list_phoneme.len() - 1
		local	clip_duration = 0.0
		if (_last_idx >= 0)
		{
			list_phoneme[_last_idx].last_time += FixedSecToTick(Sec(0.5))
			clip_duration = list_phoneme[_last_idx].last_time
		}

		return	clip_duration
	}

	constructor(_audio_mixer)
	{
		audio_mixer = _audio_mixer
		leds_handler = FloppyDisk(audio_mixer)
		leds_handler.SetDriveOff()
		leds_handler.SetPowerOff()
		list_led = []
	}

}
