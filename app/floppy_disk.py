#
#	File: scripts/floppy_disk.nut
#	Author: Astrofra
#

#!
#	@short	FloppyDisk
#	@author	Astrofra
#

class	FloppyDisk:

	def __init__(self, _audio_mixer):
		self.current_mode		=	0
		self.floppy_clock		=	0.0

		self.led_power			=	False
		self.led_drive			=	False
		self.drive_was_stopped	=	False

		# 	Private
		self.led_power_intensity	=	0.0
		self.led_drive_intensity	=	0.0

		self.motor_sound_timer	=	0

		self.audio_mixer = _audio_mixer

		local	led_item = SceneFindItem(g_scene, "Power_Drive_Lamp")
		local	geo = ItemGetGeometry(led_item)
		self.led_power_mat = GeometryGetMaterialFromIndex(geo, 0)
		self.led_drive_mat = GeometryGetMaterialFromIndex(geo, 1)

		self.track_read_duration = SoundGetDuration(ResourceFactoryLoadSound(g_factory, "tmp/disk_drive_track-read-16.wav")) * 10.0 * 0.9

	function	SetPowerOff()
	{	self.led_power = False	}

	function	SetPowerOn()
	{	self.led_power = true	}

	function	SetDriveOff()
	{
		if (self.led_drive)
		{
			self.led_drive = False
			self.drive_was_stopped = true
		}
	}

	function	SetDriveOn()
	{
		if (!self.led_drive)
		{
			self.led_drive = true
			self.drive_was_stopped = False
			self.motor_sound_timer = g_clock
		}
	}

	function	Update()
	{
		local	led_tick = (g_dt_frame * 60.0)
		if (self.led_power)
			self.led_power_intensity += led_tick
		else	
			self.led_power_intensity -= led_tick

		self.led_power_intensity = Clamp(self.led_power_intensity, 0.0, 1.0)

		if (self.led_drive)
			self.led_drive_intensity += led_tick
		else	
			self.led_drive_intensity -= led_tick

		self.led_drive_intensity = Clamp(self.led_drive_intensity, 0.0, 1.0)

		UpdateLedColors()
		UpdateSounds()
	}

	function	UpdateSounds()
	{
		if (self.led_drive && (g_clock - self.motor_sound_timer > self.track_read_duration))
		{
			self.audio_mixer.PlaySound("disk_drive_track-read-16.wav", g_clock, "floppy")
			self.motor_sound_timer = g_clock
		}

		if (!self.led_drive && self.drive_was_stopped && (g_clock - self.motor_sound_timer > self.track_read_duration))
		{
			self.audio_mixer.PlaySound("disk_drive_motor-stop-16.wav", g_clock, "floppy")
			self.drive_was_stopped = False
		}
	}

	function	UpdateLedColors()
	{
		MaterialSetSelf(self.led_power_mat, Vector(0.9,0.1,0).Scale(self.led_power_intensity))
		MaterialSetSelf(self.led_drive_mat, Vector(0.2,0.8,0).Scale(self.led_drive_intensity))
	}
}
