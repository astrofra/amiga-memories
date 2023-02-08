/*
	File: scripts/thread_handler.nut
	Author: Astrofra
*/

//------------------------------
function	GenericThreadWait(s)
//------------------------------
{
	local	_timeout

	_timeout = g_clock
				
	while ((g_clock - _timeout) < FixedSecToTick(Sec(s)))
		suspend()
}

//------------------------------
function	RawClockThreadWait(s)
//------------------------------
{
	local	_timeout = 0.0
				
	while (_timeout < Sec(s))
	{
		_timeout += g_raw_dt_frame
		suspend()
	}
}

/*!
	@short	ThreadHandler
	@author	Astrofra
*/
class	ThreadHandler
{
	thread_list			=	0
	current_scene		=	0

	//-----------
	constructor()
	//-----------
	{
		thread_list		= []
		current_scene = g_scene
	}

	//------------------
	function	Update()
	//------------------
	{
		HandleThreadList()
	}

	//------------------------------------
	function	CreateThread(_thread_name)
	//------------------------------------
	{
		thread_list.append({name = _thread_name, handle = 0})
		local	_thread = thread_list[thread_list.len() - 1]
		_thread.handle = newthread(_thread.name)
		_thread.handle.call(current_scene)
	}

	//------------------------------------
	function	DestroyThread(_thread_name)
	//------------------------------------
	{
		foreach (idx, _thread in thread_list)
			if (_thread.name == _thread_name)
			{
				_thread.handle = 0
				thread_list.remove(idx)
			}
	}
	
	//-------------------------------
	function	HandleThreadList()
	//-------------------------------
	{
		foreach (_thread in thread_list)
		{
			if (_thread.handle == 0)
				return

			if (_thread.handle.getstatus() == "suspended")
				_thread.handle.wakeup()
			else
			{
				foreach (idx, _thread_to_remove in thread_list)
					if (_thread_to_remove.handle == _thread.handle)
					{
						_thread_to_remove.handle = 0
						thread_list.remove(idx)
					}
			}
		}
	}

}
