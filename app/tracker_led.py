# 
#	File: scripts/led_tracker.nut
#	Author: Astrofra
# 

# Include("scripts/floppy_disk.nut")

# !
#	@short	LedTrack
#	@author	Astrofra
# 
class	LedTrack:

	def __init__(self, _audio_mixer):
		self.audio_mixer = _audio_mixer
		self.leds_handler = FloppyDisk(self.audio_mixer)
		self.leds_handler.SetDriveOff()
		self.leds_handler.SetPowerOff()
		self.list_led = []		
		self.current_led =	0
		self.current_led_index =	0
		self.led_clock =	0.0
		self.all_done =	False


	def Update(self):
		self.leds_handler.Update()

		_clock = g_clock - self.led_clock
		if self.all_done:
			return

		if (_clock > self.current_led.last_time)
			self.GetNextLeds()


	def GetNextLeds(self):
		print("LedTrack::GetNextLeds()")
		if self.current_led_index < self.list_led.len():
			self.current_led = self.list_led[self.current_led_index]

			if self.current_led.power:
				self.leds_handler.SetPowerOn()
			else:
				self.leds_handler.SetPowerOff()

			if self.current_led.drive:
				self.leds_handler.SetDriveOn()
			else:
				self.leds_handler.SetDriveOff()

			self.current_led_index += 1
		else:
			self.all_done = true


	def Feed(self, _current_clip):
		print("LedTrack::Feed()")
		clip_duration, key
		text = _current_clip.text
		key = SHA1(text)
		self.all_done = False
		LipSyncNutInclude(key)
		self.led_clock = g_clock
		clip_duration = GetSubtitleDuration()

		self.list_led = []
		self.current_led_index = 0
		led_time = 0.0

		if "led" in _current_clip:
			for _led in _current_clip.led:
				led_time += clip_duration / (_current_clip.len().tofloat())
				self.list_led.append({power = _led.power, drive = _led.drive, last_time = led_time})

		self.GetNextLeds()


	def GetSubtitleDuration(self):
		print("SubtitleTrack::GetSubtitleDuration()")
		_last_idx = list_phoneme.len() - 1
		clip_duration = 0.0
		if _last_idx >= 0:
			list_phoneme[_last_idx].last_time += FixedSecToTick(Sec(0.5))
			clip_duration = list_phoneme[_last_idx].last_time

		return	clip_duration
