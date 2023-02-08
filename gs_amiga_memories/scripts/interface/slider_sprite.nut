
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	SliderSprite
	@author	Scorpheus
*/
class	SliderSprite extends BasicSprite
{		
	text = 0
	unit = 0
	min_value = 0
	max_value = 0
	step = 0
	
	min_relative_pos = 0
	max_relative_pos = 0
	
	current_value = 0

	prev_current_value_string = 0
	
	cursor_down_on_slider = 0

	convert_value_in_hour_text = 0
	convert_value_in_minutes_text = 0
	convert_value_in_percent_text	= 0
	
	////////////////////////////////////////////////////////////////////////
	
	function CallCallback(_value=0.0)
	{
		if(_value != 0.0)
			current_value = _value
				
		array_sprite_relative_pos["slider_part"].x= RangeAdjust(current_value.tofloat(), min_value, max_value, min_relative_pos.tofloat(), max_relative_pos.tofloat())			
		SpriteSetPosition(array_sprite["slider_part"],  pos.x+ array_sprite_relative_pos["slider_part"].x, pos.y+ array_sprite_relative_pos["slider_part"].y)
		
		RefreshValueText(true)
			
		foreach(instance_callback in array_instance_function_callback)
		{
			if(instance_callback.func_name in instance_callback.instance)
			{
				instance_callback.instance[instance_callback.func_name](this, current_value.tofloat())
			}
		}		
	}
	////////////////////////////////////////////////////////////////////////
	
	function RefreshValueText(_force= false)
	{
		if(array_picture.len() <= 0 || (!_force && !is_shown))
			return

		// get the new value
		current_value = (RangeAdjust(array_sprite_relative_pos["slider_part"].x, min_relative_pos, max_relative_pos, min_value, max_value)*(1.0/step)).tointeger()*step
		local	current_value_string
		
		PictureFill(array_picture["text_value_part"], Vector(0.0,0.0,0.0,0.0))

		if(convert_value_in_hour_text)
		{
			local 	hours	= current_value.tointeger()
			local 	minutes	= ((current_value - current_value.tointeger()) * 60.0).tointeger()
			current_value_string = FormatNumberString(hours.tostring(), 2) + ":" + FormatNumberString(minutes.tostring(), 2)
		}
		else
		if(convert_value_in_minutes_text)
		{
			local 	minutes	= (current_value*0.0166).tointeger()
			local	seconds = Mod(current_value, 60.0).tointeger()
			local	hundreth = Mod(current_value * 100.0, 100.0).tointeger()
			current_value_string = FormatNumberString(minutes.tostring(), 2) + ":" + FormatNumberString(seconds.tostring(), 2) + ":" + FormatNumberString(hundreth.tostring(), 2)
		}
		else
		if (convert_value_in_percent_text)
			current_value_string = (current_value * 100.0).tointeger().tostring() + " %"
		else
			current_value_string = current_value + unit

		if(current_value_string.tostring().len() != prev_current_value_string.tostring().len())
		{ 
			local new_rect = TextComputeRect(Rect(0,0,9999,9999), current_value_string.tostring(), "gui_font", { size = g_size_font_text })
			PictureResize(array_picture["text_value_part"], new_rect.ex.tointeger(), SpriteGetSize(array_sprite["text_value_part"]).y.tointeger())
			SpriteSetSize(array_sprite["text_value_part"], new_rect.ex.tointeger(), SpriteGetSize(array_sprite["text_value_part"]).y.tointeger())		

			SetSize(width, height)	
		}

		if(	prev_current_value_string != current_value_string)
		{
			PictureTextRender(array_picture["text_value_part"], Rect(0, 10, SpriteGetSize(array_sprite["text_value_part"]).x, SpriteGetSize(array_sprite["text_value_part"]).y), current_value_string.tostring(), "gui_font" ,{ size = g_size_font_text, color = g_size_font_color_text })		
			TextureUpdate(array_texture["text_value_part"], array_picture["text_value_part"])
		}

		prev_current_value_string = current_value_string
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function UpdateLostContent()
	{
		base.UpdateLostContent()
		
		foreach(sprite in array_sprite)
			UIDeleteSprite(g_WindowsManager.current_ui, sprite)
		array_sprite.clear()
		array_sprite_relative_pos.clear()
		CreateSpriteWithSlider()
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function Update(_with_all_children = false)
	{
		base.Update(_with_all_children)
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function SerializationLoad(serialization_table)
	{
		text = serialization_table["text"]
		min_value = serialization_table["min_value"].tofloat()
		max_value = serialization_table["max_value"].tofloat()
		step = serialization_table["step"].tofloat()
		
		min_relative_pos = serialization_table["min_relative_pos"].tointeger()
		max_relative_pos = serialization_table["max_relative_pos"].tointeger()
		
		current_value = serialization_table["current_value"].tointeger()
		
		base.SerializationLoad(serialization_table)		
		
		CreateSpriteWithSlider()	
		
	}	
	function SerializationSave()
	{		
		local serialization_string = "text=\""+ text.tostring()+"\", "
		serialization_string += "min_value=\""+ min_value.tostring()+"\", "
		serialization_string += "max_value=\""+ max_value.tostring()+"\", "
		serialization_string += "step=\""+ step.tostring()+"\", "
		
		serialization_string += "min_relative_pos=\""+ min_relative_pos.tostring()+"\", "
		serialization_string += "max_relative_pos=\""+ max_relative_pos.tostring()+"\", "
		
		serialization_string += "current_value=\""+ current_value.tostring()+"\", "
		
		serialization_string += base.SerializationSave()
		
		return serialization_string
	}
		
	////////////////////////////////////////////////////////////////////////
	
	function	CursorEnterEvent(event, table)
	{
	}
	function	CursorLeaveEvent(event, table)
	{					
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function	ClickUpEvent(event, table)
	{
		base.ClickUpEvent(event, table)
		UIUnlock(g_WindowsManager.current_ui)
	}
	
	function	ClickDownEvent(event, table)
	{
		base.ClickDownEvent(event, table)
		UILockToSprite(g_WindowsManager.current_ui, array_sprite["text_part"])
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function	ClickSliderButtonEvent(event, table)
	{
		cursor_down_on_slider = (g_cursor.GetMousePos().x - pos.x ) - array_sprite_relative_pos["slider_part"].x
		UILockToSprite(g_WindowsManager.current_ui, array_sprite["slider_part"])
		g_WindowsManager.mouse_locked_by_ui = true
	}
	function	UnClickSliderButtonEvent(event, table)
	{
		cursor_down_on_slider = 0
		UIUnlock(g_WindowsManager.current_ui)
		g_WindowsManager.mouse_locked_by_ui = false
	}
	function	CursorMoveSliderEvent(event, table)
	{
		if(cursor_down_on_slider)
		{			
			// move the slider sprite		
			local mouse_pos = g_cursor.GetMousePos()
			mouse_pos.x -= cursor_down_on_slider

			if((mouse_pos.x - pos.x)  < min_relative_pos)
				array_sprite_relative_pos["slider_part"].x = min_relative_pos
			else
			if((mouse_pos.x - pos.x) > max_relative_pos)
				array_sprite_relative_pos["slider_part"].x = max_relative_pos
			else
				array_sprite_relative_pos["slider_part"].x = (mouse_pos.x - pos.x)
				
			SpriteSetPosition(array_sprite["slider_part"],  pos.x+ array_sprite_relative_pos["slider_part"].x, pos.y+ array_sprite_relative_pos["slider_part"].y)
				
			// get the new value
			current_value = (RangeAdjust(array_sprite_relative_pos["slider_part"].x, min_relative_pos, max_relative_pos, min_value, max_value)*(1.0/step)).tointeger()*step

			// call the callback
			CallCallback(current_value)
		}
	}
	
	////////////////////////////////////////////////////////////////////////	
			
	function SetPos(_pos)
	{		
			base.SetPos(_pos)	
	}
	function SetSize(_width, _height, _child=0)
	{
		local old_width = width
		
		base.SetSize(_width, height, _child)	
		
		if(array_sprite.len() > 0)	
		{			
			array_sprite_relative_pos["right_part"].x += _width -	old_width
		
			// change size of the middle
			local old_width_middle = SpriteGetSize(array_sprite["middle_part"]).x
	
			SpriteSetSize(array_sprite["middle_part"], SpriteGetSize(array_sprite["middle_part"]).x+(_width - old_width), SpriteGetSize(array_sprite["middle_part"]).y)					
	
			SpriteSetSize(array_sprite["click_part"], width, height)	

			max_relative_pos += (_width - old_width)
	
			SetPos(pos)
			
		//	SpriteSetScale(array_sprite[1], (old_width_middle.tofloat()/SpriteGetSize(array_sprite[1]).x.tofloat()), 	1.0)					
		//	WindowSetCommandList(array_sprite[1],"toscale 0.3,1.0,1.0;")
		}
		else
			CreateSpriteWithText(text, _width)				
	}					
		
	////////////////////////////////////////////////////////////////////////
				
	function CreateSpriteWithSlider(_max_width = -1)
	{		
		CleanSprites()
			
		local left_picture = PictureNew()
		PictureLoadContent(left_picture, g_skin[skin].left_picture)
		local middle_picture = PictureNew()
		PictureLoadContent(middle_picture, g_skin[skin].middle_picture)	
		local right_picture = PictureNew()
		PictureLoadContent(right_picture, g_skin[skin].right_picture)
		
		local width_text = 	(TextComputeRect(Rect(0,0,9999,9999), text.tostring(), "gui_font", { size = g_size_font_text }).ex*1.5).tointeger()
		local width_text_part = (TextComputeRect(Rect(0,0,9999,9999), (max_value+step).tostring(), "gui_font", { size = g_size_font_text }).ex*1.5).tointeger()
		local width_slider_part = PictureGetRect(middle_picture).ey*15	
		
		if(width_text < 1)	
			width_text = 1
		if(width_text_part < 1)
			width_text_part = 1	
			
		if(width_slider_part < 1)
			width_slider_part = 1

		local TempRect = Rect(0,0,width_text + width_slider_part + width_text_part,PictureGetRect(middle_picture).ey)
		if(_max_width != -1)
			TempRect.ex = _max_width - (PictureGetRect(left_picture).ex + PictureGetRect(right_picture).ex)
		
		TempRect.ex = TempRect.ex.tointeger()
		TempRect.ey = TempRect.ey.tointeger()
			
		if(TempRect.ex < 1)
			TempRect.ex = 1	
			
		// blit left part
		{
			local texture = ResourceFactoryNewTexture(g_factory)
			TextureUpdate(texture, left_picture)
			TextureSetWrapping(texture, false,false)		
			local relative_pos = Vector(0,0,0)
			array_sprite.rawset("left_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, PictureGetRect(left_picture).ex, PictureGetRect(left_picture).ey))
			array_sprite_relative_pos.rawset("left_part", relative_pos)			
		}
		// blit the middle part
		{		
			local texture = ResourceFactoryNewTexture(g_factory)
			local pict = PictureNew()		
			PictureAlloc(pict, TempRect.ex , TempRect.ey)			
			
			for(local i=0; i<TempRect.ex; ++i)
				PictureBlitRect(middle_picture, pict, PictureGetRect(middle_picture), Rect(i,0, i+PictureGetRect(middle_picture).ex, PictureGetRect(middle_picture).ey), BlendCompose)
			
			TextureUpdate(texture, pict)
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(PictureGetRect(left_picture).ex,0,0)
			array_sprite.rawset("middle_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, TempRect.ex , TempRect.ey))
			array_sprite_relative_pos.rawset("middle_part", relative_pos)			
		}
		// blit right part
		{
			local texture = ResourceFactoryNewTexture(g_factory)		
			TextureUpdate(texture, right_picture)
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(PictureGetRect(left_picture).ex+TempRect.ex,0,0)
			array_sprite.rawset("right_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, PictureGetRect(right_picture).ex, PictureGetRect(right_picture).ey))
			array_sprite_relative_pos.rawset("right_part", relative_pos)			
		}
		
		// blit text part
		{
			local texture = ResourceFactoryNewTexture(g_factory)	
			local pict = PictureNew()					
			PictureAlloc(pict, width_text, TempRect.ey)			
			PictureTextRender(pict, Rect(0, 10, width_text, TempRect.ey), text.tostring(), "gui_font" ,{ size = g_size_font_text, color = g_size_font_color_text })
			
			TextureUpdate(texture, pict)
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(PictureGetRect(left_picture).ex,0,0)
			array_texture.rawset("text_part", texture)
			array_picture.rawset("text_part", pict)
			array_sprite.rawset("text_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, width_text , TempRect.ey))
			array_sprite_relative_pos.rawset("text_part", relative_pos)							

			SpriteSetEventHandlerWithContext(array_sprite["text_part"], EventCursorDown, this, ClickDownEvent)
			SpriteSetEventHandlerWithContext(array_sprite["text_part"], EventCursorUp, this, ClickUpEvent)
			SpriteSetEventHandlerWithContext(array_sprite["text_part"], EventCursorMove, this, MouseMouseEvent)			
		}		
		// blit text value part
		{
			local texture = ResourceFactoryNewTexture(g_factory)	
			local pict = PictureNew()					
			PictureAlloc(pict, width_text_part, TempRect.ey)			
			PictureTextRender(pict, Rect(0, 10, width_text_part, TempRect.ey), current_value.tostring(), "gui_font" ,{ size = g_size_font_text, color = g_size_font_color_text })
			
			TextureUpdate(texture, pict)
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(PictureGetRect(left_picture).ex+width_text,0,0)
			array_texture.rawset("text_value_part", texture)
			array_picture.rawset("text_value_part", pict)
			array_sprite.rawset("text_value_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, width_text_part , TempRect.ey))
			array_sprite_relative_pos.rawset("text_value_part", relative_pos)					

			SpriteSetEventHandlerWithContext(array_sprite["text_value_part"], EventCursorDown, this, ClickDownEvent)
			SpriteSetEventHandlerWithContext(array_sprite["text_value_part"], EventCursorUp, this, ClickUpEvent)
			SpriteSetEventHandlerWithContext(array_sprite["text_value_part"], EventCursorMove, this, MouseMouseEvent)					
		}		
		
		width = PictureGetRect(left_picture).ex + TempRect.ex + PictureGetRect(right_picture).ex
		height = PictureGetRect(right_picture).ey
						
		// add click section
		{
			local relative_pos = Vector(0,0,0)
			local sprite = UIAddSprite(g_WindowsManager.current_ui, -1, NullTexture, pos.x+relative_pos.x, pos.y+relative_pos.y, width, height)
			array_sprite.rawset("click_part", sprite)
			array_sprite_relative_pos.rawset("click_part", relative_pos)			

			SpriteSetEventHandlerWithContext(array_sprite["click_part"], EventCursorDown, this, ClickDownEvent)
			SpriteSetEventHandlerWithContext(array_sprite["click_part"], EventCursorUp, this, ClickUpEvent)
			SpriteSetEventHandlerWithContext(array_sprite["click_part"], EventCursorMove, this, MouseMouseEvent)				
			
			SpriteSetEventHandlerWithContext(sprite, EventCursorEnter, this, CursorEnterEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorLeave, this, CursorLeaveEvent)						
		}
		
		// blit slider part
		{
			local slider_picture = PictureNew()
			PictureLoadContent(slider_picture, g_skin[skin].slider_cursor)
			
			min_relative_pos = PictureGetRect(left_picture).ex+width_text+width_text_part
			max_relative_pos = PictureGetRect(left_picture).ex+width_text+width_text_part+width_slider_part - PictureGetRect(slider_picture).ex
		
			local texture = ResourceFactoryNewTexture(g_factory)	
			TextureUpdate(texture, slider_picture)
			local relative_pos = Vector(RangeAdjust(current_value.tofloat(), min_value, max_value, min_relative_pos.tofloat(), max_relative_pos.tofloat()),(PictureGetRect(middle_picture).ey-PictureGetRect(slider_picture).ey)*0.5,0.0)			
			array_sprite.rawset("slider_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, PictureGetRect(slider_picture).ex , PictureGetRect(slider_picture).ey))
			array_sprite_relative_pos.rawset("slider_part", relative_pos)			
			
			SpriteSetEventHandlerWithContext(array_sprite["slider_part"], EventCursorDown, this, ClickSliderButtonEvent)		
			SpriteSetEventHandlerWithContext(array_sprite["slider_part"], EventCursorUp, this, UnClickSliderButtonEvent)
			SpriteSetEventHandlerWithContext(array_sprite["slider_part"], EventCursorMove, this, CursorMoveSliderEvent)				
		}		
	}
			
	////////////////////////////////////////////////////////////////////////
	
	function	constructor(_id = 0, _parent = 0, _instance=0, _func="", _text="", _min_value=0.0, _max_value=1.0, _step=1, _default_value=0)
	{			
		base.constructor(_id, _parent)
		type = "SliderSprite"		
		
		text = _text
		unit = ""
		min_value = _min_value.tofloat()
		max_value = _max_value.tofloat()
		step = _step
		current_value = _default_value
		prev_current_value_string = ""
					
		min_relative_pos = Vector(0,0,0)
		max_relative_pos = Vector(1,1,0)
	
		cursor_down_on_slider = false

		convert_value_in_hour_text = false
		convert_value_in_minutes_text = false
		
		CreateSpriteWithSlider()	
		
		if(_instance && typeof(_func) == "string" && _func.len() > 0)
			array_instance_function_callback.append({instance=_instance,func_name=_func})
	}
}
