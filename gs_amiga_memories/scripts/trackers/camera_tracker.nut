/*
	File: scripts/camera_tracker.nut
	Author: Astrofra
*/

/*!
	@short	CameraTrack
	@author	Astrofra
*/
class	CameraTrack
{

	camera_list			=	0
	camera_item			=	0
	prev_camera_item	=	0
	camera_motion		=	0
	speed				=	Mtr(0.4)
	default_speed		=	Mtr(0.4)
	fps					=	30.0

	constructor()
	{
		camera_list = {}
	}

	function	Update()
	{
		if (camera_motion != 0)
			this[camera_motion]()
	}

	function	Feed(_current_clip, fps = 30.0)
	{
		if ("camera" in _current_clip)
		{
			local	_camera_track = _current_clip.camera
			local	_clip_duration = GetSubtitleDuration()

			camera_item = SceneFindItem(g_scene, _camera_track.name)
			SceneSetCurrentCamera(g_scene, ItemCastToCamera(camera_item))

			//	If the camera was not accessed before, store its position & rotation
			if (!(_camera_track.name in camera_list))
			{
				camera_list.rawset(_camera_track.name, {position = 0, rotation = 0})
				camera_list[_camera_track.name].position = ItemGetPosition(camera_item)
				camera_list[_camera_track.name].rotation = ItemGetRotation(camera_item)
			}
			else
			{
				//	Otherwise, 
				//	If the camera changed since the last feed, reset it
				if (ItemGetName(camera_item) != ItemGetName(prev_camera_item))
				{
					ItemSetPosition(camera_item, camera_list[_camera_track.name].position)
					ItemSetRotation(camera_item, camera_list[_camera_track.name].rotation)
				}
			}

			if ("speed" in _camera_track)
				speed = _camera_track.speed
			else
				speed = default_speed

			camera_motion = _camera_track.motion

			prev_camera_item = camera_item
		}
		else
			camera_motion = 0
	}

	//	Public Camera Motions

	function	Idle()
	{
	}

	function	DollyFront()
	{		pDolly(1.0)	}

	function	DollyBack()
	{			pDolly(-1.0)	}

	function	PanRight()
	{		pPan(1.0)	}

	function	PanLeft()
	{		pPan(-1.0)	}

	function	PanUp()
	{		pPanV(1.0)	}

	function	PanDown()
	{		pPanV(1.0)	}


	//	Private Camera Motions
	function	pDolly(direction)
	{
		local	_front = ItemGetMatrix(camera_item).GetFront(),
				_pos = ItemGetPosition(camera_item)
		_pos += _front.Scale(speed / fps * direction * g_dt_frame)
		ItemSetPosition(camera_item, _pos)
	}

	function	pPan(direction)
	{
		local	_front = ItemGetMatrix(camera_item).GetRight(),
				_pos = ItemGetPosition(camera_item)
		_pos += _front.Scale(speed / fps * direction * g_dt_frame)
		ItemSetPosition(camera_item, _pos)
	}

	function	pPanV(direction)
	{
		local	_front = ItemGetMatrix(camera_item).GetUp(),
				_pos = ItemGetPosition(camera_item)
		_pos += _front.Scale(speed / fps * direction * g_dt_frame)
		ItemSetPosition(camera_item, _pos)
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

}
