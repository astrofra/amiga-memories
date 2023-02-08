
g_AndroidInterfaceConnection <- 0

/*!
	@short	android_interface_connection
	@author	Scorpheus
*/
class	android_interface_connection
{
	current_sprite = 0

	function SendFormToAndroid()
	{
		// serialize the window
		local string_window
		if(current_sprite)
			string_window = g_WindowsManager.SerializationSave(current_sprite)
		else
			string_window = g_WindowsManager.SerializationSave()
		
		// send it to the android		
		g_NetworkManager.AppendUrlRequest(this, "", "http://212.51.180.186:22056/simu/?client=s&type=save", string_window)		
	}
	
	/////////////////////////////////////////////////////////////////////////////////
	
	function RequestFromAndroid(_data, _error)
	{
		if (typeof _data != "string" || _data == null)
			_data = ""
						
//		print("Receive from the android : "+_data)
		
		if(_error)
			print("ARGGG error on retrieve android")			
		
		if(!_error && _data.len() > 0 && _data.find("FAIL") == null)
		{
			if(_data == "IAMEMPTY")
			{
				SendFormToAndroid()
			}
			else
			{
				local ArrayStringFunc = compilestring("{return "+_data+"}")
				local _Array = ArrayStringFunc(ArrayStringFunc)
				
				foreach(val in _Array)
				{
					if("value" in val)
						g_WindowsManager.CallCallback(val.id.tointeger(), val.value)
					else
						g_WindowsManager.CallCallback(val.id.tointeger())
				}			
			}
		}
	}
	
	/*!
		@short	CheckRequstFromAndroid
		Called when we want to know what the android want or status
	*/
	function	SetRepeatRequestFromAndroid()
	{					
		// Create a url request timer to check if the simu want some change 
		if(g_NetworkManager)
		{
			g_NetworkManager.AppendTimerUrlRequest(this, "RequestFromAndroid", 2.0, "http://212.51.180.186:22056/simu/?client=s&type=ask", "youpi")			
		}
	}
}

