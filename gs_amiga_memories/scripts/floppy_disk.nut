/*
	File: scripts/floppy_disk.nut
	Author: Astrofra
*/

/*!
	@short	FloppyDisk
	@author	Astrofra
*/
class	FloppyDisk
{
	current_mode		=	0
	floppy_clock		=	0.0

	led_power			=	false
	led_drive			=	false
	drive_was_stopped	=	false

	//	Private

	led_power_mat		=	0
	led_drive_mat		=	0

	led_power_intensity	=	0.0
	led_drive_intensity	=	0.0

	audio_mixer			=	0
	motor_sound_timer	=	0

	track_read_duration	=	0.0

	constructor(_audio_mixer)
	{
		audio_mixer = _audio_mixer

		local	led_item = SceneFindItem(g_scene, "Power_Drive_Lamp")
		local	geo = ItemGetGeometry(led_item)
		led_power_mat = GeometryGetMaterialFromIndex(geo, 0)
		led_drive_mat = GeometryGetMaterialFromIndex(geo, 1)

		track_read_duration = SoundGetDuration(ResourceFactoryLoadSound(g_factory, "tmp/disk_drive_track-read-16.wav")) * 10.0 * 0.9
	}

	function	SetPowerOff()
	{	led_power = false	}

	function	SetPowerOn()
	{	led_power = true	}

	function	SetDriveOff()
	{
		if (led_drive)
		{
			led_drive = false
			drive_was_stopped = true
		}
	}

	function	SetDriveOn()
	{
		if (!led_drive)
		{
			led_drive = true
			drive_was_stopped = false
			motor_sound_timer = g_clock
		}
	}

	function	Update()
	{
		local	led_tick = (g_dt_frame * 60.0)
		if (led_power)
			led_power_intensity += led_tick
		else	
			led_power_intensity -= led_tick

		led_power_intensity = Clamp(led_power_intensity, 0.0, 1.0)

		if (led_drive)
			led_drive_intensity += led_tick
		else	
			led_drive_intensity -= led_tick

		led_drive_intensity = Clamp(led_drive_intensity, 0.0, 1.0)

		UpdateLedColors()
		UpdateSounds()
	}

	function	UpdateSounds()
	{
		if (led_drive && (g_clock - motor_sound_timer > track_read_duration))
		{
			audio_mixer.PlaySound("disk_drive_track-read-16.wav", g_clock, "floppy")
			motor_sound_timer = g_clock
		}

		if (!led_drive && drive_was_stopped && (g_clock - motor_sound_timer > track_read_duration))
		{
			audio_mixer.PlaySound("disk_drive_motor-stop-16.wav", g_clock, "floppy")
			drive_was_stopped = false
		}
	}

	function	UpdateLedColors()
	{
		MaterialSetSelf(led_power_mat, Vector(0.9,0.1,0).Scale(led_power_intensity))
		MaterialSetSelf(led_drive_mat, Vector(0.2,0.8,0).Scale(led_drive_intensity))
	}
}
