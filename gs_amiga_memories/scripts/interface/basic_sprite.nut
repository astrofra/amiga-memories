
/*!
	@short	BasicSprite
	@author	Scorpheus
*/
class	BasicSprite
{		
	id						= 0
	parent 				= 0
	child_array 	= 0

	user_param 	=	0
	
	type 					= 0
	
	skin 					=	0
	hover_animation	=	0
	alignment			=	0
	
	array_sprite	= 0
	array_texture	= 0
	array_picture	= 0
	array_sprite_relative_pos = 0
	array_sprite_blacklist_automatic_show	= 0
	
	pos 					= 0
	width 				= 0
	height				=	0	

	is_shown 			= 0
	is_folded			= 0

	folded_widget		= 0
	folded_path_picture		= 0
	
	original_width 				= 0
	original_height				=	0	

	z_order			=	0
	opacity 		=	0
	
	array_instance_function_callback = 0
	array_right_click_instance_function_callback = 0
	
	decal_sprite_x = 0.0

	pos_click_down = 0
	pos_window_click_down = 0

	fade_timeout = 0

	authorize_move = 0
	authorize_folded = 0
	authorize_resize = 0
	authorize_fadeout = 0
	authorize_click = 0

	signature_key = 0
	authorize_save = 0


	function	SetParent(_new_parent)
	{
		if(parent)
			parent.RemoveChild(id)

		parent = _new_parent
		parent.AppendChild(this)
	}

	////////////////////////////////////////////////////////////////////////
	
	function	MoveParent(_dt_vec)
	{
		if(!authorize_move)
			return

		if(parent)
			parent.MoveParent(_dt_vec)
		else
			SetPos(pos + _dt_vec)

	}
	function	MouseMouseEvent(event, table)
	{
		fade_timeout = g_clock
		if(parent)
			parent.MouseMouseEvent(event, table)

		// if it's right click
		local ui_device = GetInputDevice("mouse")
		if(DeviceIsKeyDown(ui_device, KeyButton1))
			return
		
		if(!pos_click_down || !authorize_move)
			return

		MoveParent( (g_cursor.GetMousePos() - pos) - pos_click_down)

	}
	function	ClickUpEvent(event, table)
	{
		g_WindowsManager.mouse_locked_by_ui = false
		// if it's right click		
		local ui_device = GetInputDevice("mouse")
		if(!DeviceWasKeyDown(ui_device, KeyButton0))
			return

		// call the callback if the sprite didn't move
		if(pos_window_click_down.Dist2(pos) < 0.1 || (pos_click_down && pos_click_down.Dist2(Vector(g_cursor._x * 1280.0, g_cursor._y * 960.0, 0.0) - pos) <= 0.1))
			CallCallback()

		pos_click_down = 0
		pos_window_click_down = 0
	}
	function	ClickDownEvent(event, table)
	{
		g_WindowsManager.mouse_locked_by_ui = true
		// if it's right or left click		
		local ui_device = GetInputDevice("mouse")
		if(DeviceIsKeyDown(ui_device, KeyButton0))
		{			
			pos_click_down = g_cursor.GetMousePos() - pos
			pos_window_click_down = clone(pos)
			g_WindowsManager.PushInFront(this)
		}
		else
			RightClickDownEvent()
	}

	////////////////////////////////////////////////////////////////////////
	
	function	ClickOnFoldedPicture(_sprite)
	{
		// the window Reappear
		folded_widget.Hide(true)
		
		is_folded = false
						
		g_WindowsManager.folded_icon_horizontal_sizer.RemoveChild(folded_widget.id)
		g_WindowsManager.folded_icon_horizontal_sizer.SetSize(g_WindowsManager.folded_icon_horizontal_sizer.width, g_WindowsManager.folded_icon_horizontal_sizer.height)

		// show all the widgets original
		this.Show(true)
	}

	function	SetRightClickCallback(_instance, _func)
	{	
		if(_instance && typeof(_func) == "string" && _func.len() > 0)
			array_right_click_instance_function_callback.append({instance=_instance,func_name=_func})
	}

	function	RightClickDownEvent()
	{	
		if(is_folded)
			return

		//call right click callback		
		foreach(instance_callback in array_right_click_instance_function_callback)
		{
			if(instance_callback.func_name in instance_callback.instance)
			{
				instance_callback.instance[instance_callback.func_name](this)
			}
		}

		if(!authorize_folded)
			return

		if(parent)
			parent.RightClickDownEvent()
		else
		{
			// it's a right click, so fold this windows
			this.Hide(true)
			this.Update(true)

			is_folded = true

			// look if the manager have the horizontal sizer ready
			if(!g_WindowsManager.folded_icon_horizontal_sizer)
			{
				g_WindowsManager.folded_icon_horizontal_sizer = g_WindowsManager.CreateHorizontalSizer(0, 1024)	
				g_WindowsManager.folded_icon_horizontal_sizer.authorize_background = false
				g_WindowsManager.folded_icon_horizontal_sizer.SetPos(Vector(0, 60, 0))		
				g_WindowsManager.folded_icon_horizontal_sizer.authorize_folded = false	
				g_WindowsManager.folded_icon_horizontal_sizer.array_sprite_blacklist_automatic_show.rawset("little_shadow_sprite", true)	
				SpriteSetOpacity(g_WindowsManager.folded_icon_horizontal_sizer.array_sprite["little_shadow_sprite"], 0.0)				
			}

			// show the little window and place it at the top of the screen
			if(!folded_widget)
			{
				folded_widget = g_WindowsManager.CreateBitmapButton(0, folded_path_picture, this, "ClickOnFoldedPicture")	
				folded_widget.authorize_resize = false	
				folded_widget.authorize_folded = false					
			}

			g_WindowsManager.folded_icon_horizontal_sizer.AppendChild(folded_widget)
			folded_widget.Show(true)
		}
	}
	////////////////////////////////////////////////////////////////////////
	
	function SetZOrder(_z_order, _go_to_parent=false)
	{
		if(parent && _go_to_parent)
		{
			parent.SetZOrder(_z_order, true)
		}
		else
		{
			z_order = _z_order

			foreach(sprite in array_sprite)
				SpriteSetZOrder(sprite, _z_order)

			foreach(child in child_array)
				child.SetZOrder(_z_order)
		}
	}	
	////////////////////////////////////////////////////////////////////////
	
	function SetOpacity(_opacity, _go_to_parent=false)
	{
		if(parent && _go_to_parent)
		{
			parent.SetOpacity(_opacity, true)
		}
		else
		{
			opacity = _opacity
			foreach(sprite in array_sprite)
				WindowSetOpacity(sprite, opacity)

			foreach(child in child_array)
				child.SetOpacity(opacity)	
		}	
	}

	////////////////////////////////////////////////////////////////////////
	
	function CenterPivot()
	{
		foreach(sprite in array_sprite)
			SpriteSetPivot(sprite, SpriteGetSize(sprite).x * 0.5, SpriteGetSize(sprite).y * 0.5)
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function SetRotation(_angle)
	{
		foreach(sprite in array_sprite)
			SpriteSetRotation(sprite, _angle)

		foreach(child in child_array)
			child.SetRotation(_angle)
	}

	////////////////////////////////////////////////////////////////////////
	
	function SetScale(_scale_X, _scale_Y)
	{
		foreach(sprite in array_sprite)
			SpriteSetScale(sprite, _scale_X, _scale_Y)

		foreach(child in child_array)
			child.SetScale(_scale_X, _scale_Y)
	}	
	////////////////////////////////////////////////////////////////////////
	
	function SetAnimation(_animation_name)
	{
		hover_animation	=	_animation_name
	}	
	////////////////////////////////////////////////////////////////////////
	
	function SetSkin(_skin_name)
	{
		skin	=	_skin_name
		UpdateLostContent()
	}
	////////////////////////////////////////////////////////////////////////
	
	function SetAlignment(_alignment_name)
	{
		alignment	=	_alignment_name
		UpdateLostContent()
//		if(parent)
//			parent.SetSize(parent.width, parent.height)
	}	

	
	////////////////////////////////////////////////////////////////////////
	
	function CallCallback(_value=0)
	{
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function RefreshValueText()
	{}

	////////////////////////////////////////////////////////////////////////
	
	function Show(_with_all_children = false)
	{
		if(folded_widget)
		{
			folded_widget.Hide(true)

			g_WindowsManager.folded_icon_horizontal_sizer.RemoveChild(folded_widget.id)
			g_WindowsManager.folded_icon_horizontal_sizer.SetSize(g_WindowsManager.folded_icon_horizontal_sizer.width, g_WindowsManager.folded_icon_horizontal_sizer.height)
		}
		
		is_folded  = false

		if(_with_all_children)
			foreach(child in child_array)
				child.Show(true)		
						
		is_shown = true
	}

	////////////////////////////////////////////////////////////////////////
	
	function Hide(_with_all_children = false)
	{
		if(is_folded)
		{
			folded_widget.Hide(true)

			g_WindowsManager.folded_icon_horizontal_sizer.RemoveChild(folded_widget.id)
			g_WindowsManager.folded_icon_horizontal_sizer.SetSize(g_WindowsManager.folded_icon_horizontal_sizer.width, g_WindowsManager.folded_icon_horizontal_sizer.height)
		}
		
		if(_with_all_children)
			foreach(child in child_array)
				child.Hide(true)				
			
		is_shown = false
	}
	
	////////////////////////////////////////////////////////////////////////

	function	FadeTimeout()
	{
		if ((g_clock - fade_timeout) > SecToTick(Sec(2.0)))
			opacity = Clamp((opacity - g_dt_frame), 0.3, 1.0)
		else
			opacity = Clamp((opacity + 10.0 * g_dt_frame), 0.3, 1.0)

		SetOpacity(opacity, true)	
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function UpdateLostContent()
	{
		foreach(child in child_array)
			child.UpdateLostContent()				
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function Update(_with_all_children = false)
	{
		if(_with_all_children)
			foreach(child in child_array)
				child.Update(true)	

		if(is_folded)
			return 

		// check show or hide
		if(array_sprite.len() > 0)
		{	
			local first_is_shown = false		
			foreach(id, sprite in array_sprite)
			{
				if(!(id in array_sprite_blacklist_automatic_show))
				{
					first_is_shown = (SpriteGetOpacity(sprite) != 0.0)
					break
				}
			}
			if(first_is_shown != is_shown)		
			{
				foreach(id, sprite in array_sprite)
				{
					if(!(id in array_sprite_blacklist_automatic_show))
					{
						if(is_shown)
							SpriteSetOpacity(sprite, 1.0)
						else
							SpriteSetOpacity(sprite, 0.0)
					}
				}
			}
		}

		if(authorize_fadeout)
		{
			// if the  cursor is on it
			FadeTimeout()
		}
		
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function SerializationLoad(serialization_table)
	{	
		id = serialization_table["id"].tointeger()
		width = serialization_table["width"].tointeger()
		height = serialization_table["height"].tointeger()

		authorize_resize = (serialization_table["authorize_resize"] == "true")
		authorize_fadeout = (serialization_table["authorize_fadeout"] == "true")
		authorize_folded = (serialization_table["authorize_folded"] == "true")
		authorize_move = (serialization_table["authorize_move"] == "true")
		authorize_save = (serialization_table["authorize_save"] == "true")
		
		SetSize(width, height)		
						
		SetPos(Vector(serialization_table["pos"]["x"].tointeger(), serialization_table["pos"]["y"].tointeger(), 0))		
				
		original_width = serialization_table["original_width"].tointeger()
		original_height = serialization_table["original_height"].tointeger()		
		
		if(serialization_table["child"].len() > 0)
		{
			foreach(child_table in serialization_table["child"])
			{					
				local type_sprite = child_table["type"]
				local sprite				
				if(type_sprite == "ClickSprite"	)
					sprite = ClickSprite()
				else			
				if(type_sprite == "SliderSprite"	)
					sprite = SliderSprite()
				else			
				if(type_sprite == "HorizontalSizerSprite"	)
					sprite = HorizontalSizerSprite()
				else			
				if(type_sprite == "VerticalSizerSprite"	)
					sprite = VerticalSizerSprite()
				else			
				if(type_sprite == "PrevNextSprite"	)
					sprite = PrevNextSprite()
				else			
				if(type_sprite == "CheckSprite"	)
					sprite = CheckSprite()
				else			
				if(type_sprite == "BitmapSprite"	)
					sprite = BitmapSprite()
				else			
				if(type_sprite == "ListSprite"	)
					sprite = ListSprite()
				else			
				if(type_sprite == "GridSprite"	)
					sprite = GridSprite()
				else			
				if(type_sprite == "CanvasSprite"	)
					sprite = CanvasSprite()
					
				sprite.SerializationLoad(child_table)							
				
				g_WindowsManager.array_all_sprite.append(sprite)	
				AppendChild(sprite)		
			}
		}
	}	
	function SerializationSave()
	{
		// save the type
		local serialization_string = "type=\""+ type.tostring()+"\", "
		
		serialization_string += "id=\""+ id.tostring()+"\", "
		serialization_string += "pos={x=\""+ pos.x.tostring()+"\", y=\""+pos.y.tostring()+"\"}, "		
		
		serialization_string += "width=\""+ width.tostring()+"\", "
		serialization_string += "height=\""+ height.tostring()+"\", "
		serialization_string += "original_width=\""+ original_width.tostring()+"\", "
		serialization_string += "original_height=\""+ original_height.tostring()+"\", "

		serialization_string += "authorize_resize=\""+ authorize_resize.tostring()+"\", "
		serialization_string += "authorize_fadeout=\""+ authorize_fadeout.tostring()+"\", "
		serialization_string += "authorize_folded=\""+ authorize_folded.tostring()+"\", "
		serialization_string += "authorize_move=\""+ authorize_move.tostring()+"\", "
		serialization_string += "authorize_save=\""+ authorize_save.tostring()+"\", "
		
		serialization_string += "child=["
		// add the child
		foreach(id, child_sprite in child_array)
		{
			serialization_string += "{"			
			serialization_string += child_sprite.SerializationSave()				
			serialization_string += "}"		
			if(id != child_array.len()-1)			
				serialization_string += ","					
		}
		serialization_string += "]"
		
		return serialization_string
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function AppendChild(_child)
	{
		_child.parent = this
		child_array.append(_child)		
	}
	function RemoveChild(_id)
	{		
		foreach(id_child, child in child_array)
			if(child.id == _id)
			{
				child_array.remove(id_child)
				break
			}				
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function SetBasicPos(_BasicPos)
	{
	}	
	////////////////////////////////////////////////////////////////////////
	
	function SetPos(_pos)
	{		
		if(_pos == 0)
			return
			
		foreach(id, sprite in array_sprite)
		{
			WindowSetPosition(sprite, _pos.x+array_sprite_relative_pos[id].x, _pos.y+array_sprite_relative_pos[id].y)
		//	WindowSetCommandList(sprite,  "toposition 0.0,"+SpriteGetPosition(sprite).x+","+SpriteGetPosition(sprite).y+";toposition 0.3,"+(_pos.x+array_sprite_relative_pos[id].x)+","+(_pos.y+array_sprite_relative_pos[id].y)+";")
		}
			
		pos = clone(_pos)
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function SetSize(_width, _height, _child=0)
	{		
		if(authorize_resize)
		{		
			width 				= _width
			height				=	_height
		}
		
		if(!original_width)
		{
			original_width 				= _width
			original_height				=	_height	
		}
		
	//	foreach(id, sprite in array_sprite)
	//		WindowSetCommandList(sprite, "toscale 0.3,1.0,1.0;")
	}					
			
	////////////////////////////////////////////////////////////////////////
	
	function CleanSprites()
	{
		foreach(sprite in array_sprite)
			UIDeleteSprite(g_WindowsManager.current_ui, sprite)
			
		array_sprite.clear()
		array_texture.clear()
		array_picture.clear()
		array_sprite_relative_pos.clear()
		array_sprite_blacklist_automatic_show.clear()

		if(folded_widget)
		{
			if(g_WindowsManager.folded_icon_horizontal_sizer)
			{
				g_WindowsManager.folded_icon_horizontal_sizer.RemoveChild(folded_widget.id)
				g_WindowsManager.folded_icon_horizontal_sizer.SetSize(g_WindowsManager.folded_icon_horizontal_sizer.width, g_WindowsManager.folded_icon_horizontal_sizer.height)
			}
			folded_widget.CleanSprites()
		}
	}

	function Kill(_with_child)
	{
		if(_with_child)
		{
			foreach(child in child_array)
				child.Kill(_with_child)		
			child_array.clear()
		}
		array_instance_function_callback.clear()
		array_right_click_instance_function_callback.clear()
		
		//Hide(_with_child)
		
		CleanSprites()
			
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function	constructor(_id = 0, _parent = 0)
	{			
		id				= _id
		parent 			= _parent
		child_array 	= []

		user_param = {}


		is_shown 			= true
		is_folded			= false

		folded_widget		= 0 
		folded_path_picture	= "ui/default_folded_sprite.png"

		authorize_move 		= true
		authorize_resize 	= true
		authorize_folded = true
		authorize_fadeout = false
		authorize_save = false
		authorize_click = true

		signature_key = ""
		
		skin 					=	"default_skin"		
		hover_animation	=	"no_animation"		
		alignment			=	"left"
		
		array_sprite	=	{}
		array_texture	=	{}
		array_picture	=	{}
		array_sprite_relative_pos = {}
		array_sprite_blacklist_automatic_show = {}
		
		pos 				= Vector(0,0,0)
		width 				= 0
		height				=	0
		
		original_width 				= 0
		original_height				=	0	
				
		array_instance_function_callback = []
		array_right_click_instance_function_callback = []

		pos_click_down = 0
		pos_window_click_down = 0

		z_order			=	0
		opacity 		=	1.0
	}
}
