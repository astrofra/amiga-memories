/*
	File: scripts/video_tracker.nut
	Author: Astrofra
*/

/*!
	@short	VideoTrack
	@author	Astrofra
*/
class	VideoTrack
{
	video_tracks		=	0
	video_slot			=	{	screen = "", screen_material_name = "", 
								screen_material = 0, file = "", fps = 60, 
								frame_idx = 0, prev_frame_idx = -1, 
								playing = false	}
/*
	screen_material		=	0
	video_path			=	0
	frame_idx			=	0.0
	prev_frame_idx		=	-1.0
	fps					=	60
*/

	default_screen			=	"monitor_screen"
	default_material_name	=	"assets/monitor_screen.nmm"
	default_fps				=	60

	function	Update()
	{
		if (video_tracks == 0 || video_tracks.len() == 0)
			return

		foreach (_video_track in video_tracks)
		{
			if (_video_track.playing)
			{
				_video_track.frame_idx += (g_dt_frame * _video_track.fps)
				if (_video_track.frame_idx.tointeger() != _video_track.prev_frame_idx)
					ShowVideoFrame(_video_track)

				_video_track.prev_frame_idx = _video_track.frame_idx.tointeger()	
			}
		}		
	}

	function	ShowVideoFrame(_video_track)
	{
		local	video_frame, fname
		fname = (_video_track.frame_idx.tointeger()).tostring()
		if (_video_track.frame_idx < 10)	fname = "0" + fname
		if (_video_track.frame_idx < 100)	fname = "0" + fname
		if (_video_track.frame_idx < 1000)	fname = "0" + fname
		fname = "png-in/" + _video_track.file + "/" + "frame_" + fname + ".jpg"
		if (FileExists("tmp/" + fname))
		{
			video_frame = EngineLoadTexture(g_engine, "tmp/" + fname)
			MaterialSetTexture(_video_track.screen_material, 0, video_frame)
		}
		else
		{
			if (FileExists("archived_files/" + fname))
			{
				video_frame = EngineLoadTexture(g_engine, "archived_files/" + fname)
				MaterialSetTexture(_video_track.screen_material, 0, video_frame)
			}
		}
	}

	function	Feed(_current_clip, _fps)
	{
		print("VideoTrack::Feed()")

		//	By default, we assume that all the existing video tracks
		//	Are set to "STOP".
		foreach (_video_track in video_tracks)
			_video_track.playing = false

		if ("video" in _current_clip)
		{
			print("VideoTrack::Feed() Found a 'video' array, len = " + _current_clip.video.len().tostring() + ".")

			foreach(_video_track in _current_clip.video)
			{
				local	_video_slot_key = ""
				local	_new_video_slot = clone(video_slot)

				if ("screen" in _video_track)
				{
					_video_slot_key += _video_track.screen
					_new_video_slot.screen = _video_track.screen
				}
				else
				{
					_video_slot_key += default_screen
					_new_video_slot.screen = _video_track.screen
				}

				_video_slot_key += "_"

				if ("screen_material" in _video_track)
				{
					_video_slot_key += _video_track.screen_material
					_new_video_slot.screen_material_name = _video_track.screen_material
				}
				else
				{
					_video_slot_key += default_screen
					_new_video_slot.screen_material_name = _video_track.default_material_name
				}

				_video_slot_key += "_"

				if ("file" in _video_track)
				{
					_video_slot_key += _video_track.file
					_new_video_slot.file = _video_track.file

					_video_slot_key += "_"
				}

				if ("fps" in _video_track)
				{
					_video_slot_key += _video_track.fps.tostring()
					_new_video_slot.fps = _video_track.fps
				}
				else
				{
					_video_slot_key += default_fps.tostring()
					_new_video_slot.fps = default_fps
				}

				if ("frame" in _video_track)
					_new_video_slot.frame_idx = _video_track.frame

/*				_video_slot_key = StringReplace(_video_slot_key, "/", "_")
				_video_slot_key = StringReplace(_video_slot_key, ".", "_")
				_video_slot_key = StringReplace(_video_slot_key, "-", "_")
*/
				_video_slot_key = SHA1(_video_slot_key)
				print("VideoTrack::Feed() : _video_slot_key = " + _video_slot_key)

				if (!(_video_slot_key in video_tracks))
				{
					print("VideoTrack::Feed() : Creating new video track : " + _video_slot_key)
					local	geo
					geo = ItemGetGeometry(SceneFindItem(g_scene, _new_video_slot.screen))
					_new_video_slot.screen_material = GeometryGetMaterial(geo, _new_video_slot.screen_material_name)	//	GeometryGetMaterialFromIndex(geo, 0)

					video_tracks.rawset(_video_slot_key, _new_video_slot)
				}

				video_tracks[_video_slot_key].playing = true				
/*
			video_path = _current_clip.video
			fps = _fps
			if ("frame" in _current_clip)
				frame_idx = _current_clip.frame
*/			}
		}
		else
			print("VideoTrack::Feed() : No video found.")

		print("VideoTrack::Feed() Setup " + video_tracks.len().tostring() + " tracks.")
	}

	constructor()
	{
		video_tracks = {}
/*
		local	geo, mat
		geo = ItemGetGeometry(SceneFindItem(g_scene, "monitor_screen"))
		screen_material = GeometryGetMaterialFromIndex(geo, 0)
*/
	}

}
