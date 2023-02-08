/*
	nEngine	SQUIRREL binding API.
	Copyright 2005~2008 Emmanuel Julien.
*/


class		TimeoutHandler
{
	event_array			=	0;

	constructor()
	{
		event_array = array(0, 0.0);
	}

	function	HasEventPending(code)
	{
		for	(local n = 0; n < event_array.len(); ++n)
			if	(event_array[n].code == code)
				return true;
		return false;
	}

	function	QueueEvent(time_out, _code, _instance)
	{
		if	(HasEventPending(_code))
		{
			print("** Warning, timeout event not queued. An event with this code already exists in queue.");
			return false;
		}
		event_array.append({ timeout = time_out, code = _code, instance = _instance });
		return true;
	}

	function	CancelEvent(code)
	{
		for	(local n = 0; n < event_array.len(); ++n)
			if	(event_array[n].code == code)
			{
				event_array.remove(n);
				return true;
			}
		return false;
	}

	function	Update()
	{
		// Call elapsed timeout events.
		for	(local n = 0; n < event_array.len(); ++n)
		{
			event_array[n].timeout -= g_dt_frame;
			if	(event_array[n].timeout <= 0.0)
				event_array[n].instance.timeout_callback(event_array[n].code);
		}

		// Purge array.
		for	(local n = 0; n < event_array.len(); ++n)
			if	(event_array[n].timeout <= 0.0)
			{
				event_array.remove(n);
				n--;	// So that we do not skip an event.
			}
	}
}
