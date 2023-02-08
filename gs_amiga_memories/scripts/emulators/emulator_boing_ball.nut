/*
	File: scripts/emulators/emulator_boing_ball.nut
	Author: Astrofra
*/

Include("scripts/audio_mixer.nut")
Include("scripts/paths.nut")
Include("scripts/base_emulator.nut")

if (!("g_enable_audio_output" in getroottable()))
	g_enable_audio_output <-	true

/*!
	@short	EmulatorBoingBall
	@author	Astrofra
*/
class	EmulatorBoingBall	extends	EmulatorBase
{
	ball_radius			=	Mtr(1.25 * 4.80 / 2.0)
	field_width			=	Mtr(15.0)
	field_height		=	Mtr(11.0)
	ball_pos			=	0
	speed				=	0
	ball_mesh_item		=	0
	ball_rotation		=	0
	phase				=	0.0
	last_impact_timeout	=	0.0
	audio_mixer			=	0
	setup_done			=	false
	current_track		=	0

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function	OnUpdate(item)
	{
		if (!setup_done)
			this.OnSetup(item)

		if ("OnUpdate" in base)
			base.OnUpdate(item)

		if (paused)
			return

		//	Translation
		ball_pos += speed * g_dt_frame
		if (ball_pos.x + ball_radius > field_width * 0.5)
		{
			ball_pos.x = (field_width * 0.5) - ball_radius
			speed.x *= -1.0
			PlayImpactSoundAtTimeCode(g_clock)
		}
		else
		if (ball_pos.x - ball_radius < field_width * -0.5)
		{
			ball_pos.x = (field_width * -0.5) + ball_radius
			speed.x *= -1.0
			PlayImpactSoundAtTimeCode(g_clock)
		}

		phase += (g_dt_frame * DegreeToRadian(45.0))
		local	_sin = speed.y * sin(phase)
		if (_sin < 0.0)
		{
			speed.y *= -1.0
			_sin *= speed.y
			PlayImpactSoundAtTimeCode(g_clock)
		}

		ball_pos.y = (_sin * (field_height - (ball_radius * 2.0 * 0.875))) + (ball_radius * 0.875)

		ItemSetPosition(item, ball_pos)

		//	Rotation
		ball_rotation.y += DegreeToRadian(speed.x) * g_dt_frame * 60.0
		ItemSetRotation(ball_mesh_item, ball_rotation)
	}

	function	PlayImpactSoundAtTimeCode(_tc = 0.0)
	{
		if ((g_clock - last_impact_timeout) < SecToTick(Sec(1.0/30.0)))
			return

		current_track++
		if (current_track > 1)	current_track = 0

		audio_mixer.PlaySound("boing_impact-16.wav", _tc, "paula_" + current_track.tostring())
		last_impact_timeout = g_clock
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		if ("OnSetup" in base)
			base.OnSetup(item)

		ball_mesh_item = ItemGetChild(item, "boing_ball")
		ball_rotation = clone(g_zero_vector)
		ball_pos = ItemGetPosition(item)
		speed = clone(g_zero_vector)
		speed.x = ball_radius
		speed.y = 1.0
		if ("audio_mixer" in SceneGetScriptInstance(g_scene))
			audio_mixer = SceneGetScriptInstance(g_scene).audio_mixer
		else
			audio_mixer = AudioMixer()
		last_impact_timeout = g_clock
		setup_done = true
	}
}
