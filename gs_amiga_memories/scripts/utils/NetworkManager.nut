
g_NetworkManager <- 0
/*!
	@short	NetworkManager
	@author	Scorpheus
*/
class	NetworkManager
{	
	list_timer_url_request = 0
	list_url_request = 0
	
	/*!
		@short	OnUpdate
		Called each frame.
	*/
	function	OnUpdate(scene)
	{
		HttpUpdate()
		
		// check if there is url to check
		foreach(url_request in list_timer_url_request)
		{
			url_request.current_time -= g_dt_frame
			if(url_request.current_time < 0.0 && !url_request.in_progress)
			{
				url_request.current_time = url_request.timer_ping_sec
				url_request.in_progress = true
				SendHttpRequest(url_request)
			}
		}
	}	
		
	////////////////////////////////////////////////////////////////////////
	
	function	SendHttpRequest(url_request)
	{
//		print("Send Request : "+url_request.url+", "+ url_request.post)
		url_request.id = HttpPost(url_request.url, url_request.post)
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function AppendUrlRequest(_instance_asking, _callback_function, _url, _post)
	{
		local url_request = {instance_asking=_instance_asking, callback_function=_callback_function, url=_url, post=_post, id=-1}
		list_url_request.append(url_request)
		SendHttpRequest(url_request)
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function AppendTimerUrlRequest(_instance_asking, _callback_function, _timer_ping_sec, _url, _post)
	{
		local url_request = {instance_asking=_instance_asking, callback_function=_callback_function, in_progress=false, timer_ping_sec=_timer_ping_sec, url=_url, post=_post, current_time=0.0, id=-1}
		list_timer_url_request.append(url_request)
	}

	////////////////////////////////////////////////////////////////////////
	
	function	HttpRequestComplete(uid, data)
	{	
		local current_request = 0
		foreach(id, request in list_timer_url_request)
		{
			if(uid == request.id)
			{
				current_request = request
				current_request.in_progress = false
				break
			}
		}
		if(current_request == 0)
		{
			foreach(id, request in list_url_request)
			{
				if(uid == request.id)
				{
					current_request = request
					list_url_request.remove(id)
					break
				}
			}
		}
	
		if(current_request != 0 && current_request.callback_function in current_request.instance_asking)
		{
			current_request.instance_asking[current_request.callback_function](data, false)		
		}
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function	HttpRequestError(uid)
	{	
		local current_request = 0
		foreach(id, request in list_timer_url_request)
		{
			if(uid == request.id)
			{
				current_request = request
				break
			}
		}
		if(current_request == 0)
		{
			foreach(id, request in list_url_request)
			{
				if(uid == request.id)
				{
					current_request = request
					list_url_request.remove(id)
					break
				}
			}
		}
	
		if(current_request != 0 && current_request.callback_function in current_request.instance_asking)
		{
			current_request.instance_asking[current_request.callback_function]("", true)
		}
	}

	/*!
		@short	OnExitScene
		Clean everything
	*/
	function OnExitScene()
	{
		g_NetworkManager = 0
	}	
	
	/*!
		@short	OnSetup
		Called when the scene is about to be setup.
	*/
	function	OnSetup(scene)
	{						
	}
	
	function	constructor()
	{						
		g_NetworkManager = this
		list_timer_url_request = []
		list_url_request = []
	}
	
}
