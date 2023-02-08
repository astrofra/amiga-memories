//------------
class	CCursor
//------------
{
	/*<
	<Script =
		<Name = "CCursor">
		<Author = "Thomas Simonnet">
		<Description = "Cursor on the screen">
		<Category = "">
		<Compatibility = <Scene>>
	>
	<Parameter =
		<path_cursor = <Name = "path_cursor"> <Type = "String"> <Default = "cursor.tga">>
	>
>*/
	
	//--------------------------------------------------------------------------
	path_cursor		= "ui/cursor.tga"
	//--------------------------------------------------------------------------
	
	_x				=	0
	_y				=	0

	ui				=	0
	cursor_sprite	=	0

	cursor_prev_x	=	0
	cursor_prev_y	=	0

	_dx	=	0
	_dy	=	0

	fade_timeout	=	0
	cursor_opacity	=	1.0
	
	ui_cursor = 0

	function	GetXScreenSpace(_percent_width)
	{
		local	viewport = RendererGetOutputDimensions(g_render)

		local	viewport_ar = viewport.x / viewport.y
		local	reference_ar = 1280.0 / 960.0

		local	kx = viewport_ar / reference_ar

		return ((_percent_width - 0.5) * kx + 0.5)*1280.0
	}
	function	GetYScreenSpace(_percent_width)
	{
		local	ky = 1.0

		return ((_percent_width - 0.5) * ky + 0.5) * 960.0
	}
	
	function GetMousePos()
	{
		return Vector(_x * 1280.0, _y * 960.0, 0.0)
	}

	//--------------
	function Setup()
	//--------------
	{
		if(cursor_sprite)
			UIDeleteSprite(SceneGetUI(g_scene), cursor_sprite)

		g_cursor = this		
		
		ui_cursor				=	UICreateCursor(0)
	
		ui = SceneGetUI(g_scene)
		
		//if (!cursor_sprite)
		{
			local	_texture = ResourceFactoryLoadTexture(g_factory, path_cursor)

			cursor_sprite = UIAddSprite(ui, -1, _texture, 0, 0, TextureGetWidth(_texture),	TextureGetHeight(_texture))
			WindowSetStyle(cursor_sprite, StyleNonSensitive)
			WindowSetScale(cursor_sprite, 1.5, 1.5)
			WindowSetZOrder(cursor_sprite, -20000000)
		}

		fade_timeout = g_clock
		cursor_opacity	=	1.0

	}

	function	FadeTimeout()
	{
		if ((g_clock - fade_timeout) > SecToTick(Sec(5.0)))
			cursor_opacity = Clamp((cursor_opacity - g_dt_frame), 0.0, 1.0)
		else
			cursor_opacity = Clamp((cursor_opacity + 10.0 * g_dt_frame), 0.0, 1.0)

		WindowSetOpacity(cursor_sprite, cursor_opacity)	
	}

	//------------------------
	function	Update()
	//------------------------
	{
		local ui_device = GetInputDevice("mouse")

		local temp_x = DeviceInputValue(ui_device, DeviceAxisX)
		local temp_y = DeviceInputValue(ui_device, DeviceAxisY)

		if(DeviceIsKeyDown(ui_device, KeyButton1))
			UISetCursorState(ui, ui_cursor, temp_x, temp_y, DeviceIsKeyDown(ui_device, KeyButton1))
	
		UISetCursorState(ui, ui_cursor, temp_x, temp_y, DeviceIsKeyDown(ui_device, KeyButton0))
	
		_dx = (temp_x - cursor_prev_x)
		_dy = (temp_y - cursor_prev_y)

		cursor_prev_x = temp_x
		cursor_prev_y = temp_y

		//	Actual desktop cursor
		local	dr = RendererGetOutputDimensions(g_render)

		local	viewport_ar = dr.x / dr.y
		local	reference_ar = 1280.0 / 960.0

		local	kx = viewport_ar / reference_ar, ky = 1.0

		_x = (temp_x - 0.5) * kx + 0.5
		_y = (temp_y - 0.5) * ky + 0.5
		WindowSetPosition(cursor_sprite, _x * 1280.0, _y * 960.0)
	
		if ((Abs(_dx) > 0.0) || (Abs(_dx) > 0.0))
			fade_timeout = g_clock

		FadeTimeout()	
	}
	/*!
		@short	OnExitScene
		Clean everything
	*/
	function OnExitScene()
	{
		SpriteSetOpacity(cursor_sprite, 0.0)
		cursor_sprite = 0
		g_cursor = 0
		_x				=	0.0
		_y				=	0.0
	}
}

