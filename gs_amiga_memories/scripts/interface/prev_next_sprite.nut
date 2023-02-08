
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	PrevNextSprite
	@author	Scorpheus
*/
class	PrevNextSprite extends BasicSprite
{		
	text = 0
	unit = 0
	array_value = 0
	current_index = 0
	
	////////////////////////////////////////////////////////////////////////
	
	function UpdateLostContent()
	{
		base.UpdateLostContent()
		
		foreach(sprite in array_sprite)
			UIDeleteSprite(g_WindowsManager.current_ui, sprite)
		array_sprite.clear()
		array_sprite_relative_pos.clear()
		CreateSpriteWithText(text, array_value)
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
		array_value.clear()
		foreach(value in serialization_table["array_value"])
			array_value.append(value)
		base.SerializationLoad(serialization_table)
		
		CreateSpriteWithText(text, array_value)	
	}	
	function SerializationSave()
	{
		local serialization_string = "text=\""+ text.tostring()+"\", "
		serialization_string += "array_value=["
		foreach(value in array_value)		
			serialization_string += value.tostring()+","
		serialization_string += "],"
		serialization_string += base.SerializationSave()			
		
		return serialization_string
	}
		
	////////////////////////////////////////////////////////////////////////
	
	function	CursorEnterEvent(event, table)
	{
		if(hover_animation == "expand")
		{
			//	print("enter")
				original_width += 50
				SetSize(original_width, height)
				
			if(parent)
				parent.SetSize(parent.width, parent.height, this)
		}
	}
	function	CursorLeaveEvent(event, table)
	{			
		if(hover_animation == "expand")
		{		
			//	print("leave")
				original_width -= 50
				SetSize(original_width, height)
				
			if(parent)
				parent.SetSize(parent.width, parent.height, this)
		}
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function CallCallback(_value=0)
	{
		foreach(instance_callback in array_instance_function_callback)
		{
			if(instance_callback.func_name in instance_callback.instance)
			{
				instance_callback.instance[instance_callback.func_name](this, array_value[current_index])
			}
		}
	}

	////////////////////////////////////////////////////////////////////////

	function FindNewIndexAndRefresh(_value)
	{
		foreach(id, value in array_value)
		{
			if(value == _value)
			{
				current_index = id
				break
			}
		}

		RefreshValueText(true)	
	}
	
	function RefreshValueText(_force = false)
	{
		if(!_force && !is_shown)
			return
		
		PictureFill(array_picture["value_part"], Vector(0.0,0.0,0.0,0.0))
		PictureTextRender(array_picture["value_part"], Rect(0, 10, SpriteGetSize(array_sprite["value_part"]).x, SpriteGetSize(array_sprite["value_part"]).y), array_value[current_index].tostring()+" "+unit.tostring(), "gui_font" ,{ size = g_size_font_text, color = g_size_font_color_text })					
		TextureUpdate(array_texture["value_part"], array_picture["value_part"])		
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
	
	function	ClickPrevButtonEvent(event, table)
	{
		// if it's right click
		local ui_device = GetInputDevice("mouse")
		if(DeviceIsKeyDown(ui_device, KeyButton1))
			return
		
		--current_index
		if(current_index < 0)
			current_index = array_value.len()-1

		RefreshValueText()

		CallCallback()
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function	ClickNextButtonEvent(event, table)
	{
		// if it's right click
		local ui_device = GetInputDevice("mouse")
		if(DeviceIsKeyDown(ui_device, KeyButton1))
			return
		
		++current_index
		if(current_index >= array_value.len())
			current_index = 0

		RefreshValueText()

		CallCallback()
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
			array_sprite_relative_pos["right_part"].x += width - old_width
		
			// change size of the middle
			local old_width_middle = SpriteGetSize(array_sprite["middle_part"]).x
			SpriteSetSize(array_sprite["middle_part"], SpriteGetSize(array_sprite["middle_part"]).x+(width - old_width) , SpriteGetSize(array_sprite["middle_part"]).y)	

			SpriteSetSize(array_sprite["prev_part"], SpriteGetSize(array_sprite["prev_part"]).x+(width - old_width) , SpriteGetSize(array_sprite["prev_part"]).y)
			SpriteSetSize(array_sprite["value_part"], SpriteGetSize(array_sprite["value_part"]).x+(width - old_width) , SpriteGetSize(array_sprite["value_part"]).y)
			SpriteSetSize(array_sprite["next_part"], SpriteGetSize(array_sprite["next_part"]).x+(width - old_width) , SpriteGetSize(array_sprite["next_part"]).y)
			
			SpriteSetSize(array_sprite["click_prev_part"], SpriteGetSize(array_sprite["click_prev_part"]).x, SpriteGetSize(array_sprite["click_prev_part"]).y)
			SpriteSetSize(array_sprite["click_next_part"], SpriteGetSize(array_sprite["click_next_part"]).x, SpriteGetSize(array_sprite["click_next_part"]).y)


			PictureResize(array_picture["value_part"],  SpriteGetSize(array_sprite["value_part"]).x.tointeger(), SpriteGetSize(array_sprite["value_part"]).y.tointeger())
			
			if(alignment == "left")
				array_sprite_relative_pos["text_part"] = Vector(SpriteGetSize(array_sprite["left_part"]).x,0,0)
			else
			if(alignment == "center")
				array_sprite_relative_pos["text_part"] = Vector(SpriteGetSize(array_sprite["left_part"]).x+width*0.5-SpriteGetSize(array_sprite["text_part"]).x*0.5,0,0)
			else
			if(alignment == "right")
				array_sprite_relative_pos["text_part"] = Vector(width-SpriteGetSize(array_sprite["text_part"]).x,0,0)
				
			// push to the left the selector prev next
			array_sprite_relative_pos["prev_part"].x += (width - old_width) 	
			array_sprite_relative_pos["value_part"].x += (width - old_width) 	
			array_sprite_relative_pos["next_part"].x += (width - old_width) 	

			array_sprite_relative_pos["click_prev_part"].x += (width - old_width) 	
			array_sprite_relative_pos["click_next_part"].x += (width - old_width) 	

			SetPos(pos)
			
		//	SpriteSetScale(array_sprite[1], (old_width_middle.tofloat()/SpriteGetSize(array_sprite[1]).x.tofloat()), 1.0)					
		//	WindowSetCommandList(array_sprite[1],"toscale 0.3,1.0,1.0;")
		}
		else
			CreateSpriteWithText(text, array_value, width)	
						
	}					
	
	////////////////////////////////////////////////////////////////////////
	
	function CreateSpriteWithText(_text, _array_value, _max_width = -1)
	{				
		CleanSprites()

		local left_texture = ResourceFactoryLoadTexture(g_factory, g_skin[skin].left_picture)
		local middle_texture = ResourceFactoryLoadTexture(g_factory, g_skin[skin].middle_picture)
		local right_texture = ResourceFactoryLoadTexture(g_factory, g_skin[skin].right_picture)
		
		local prev_texture = ResourceFactoryLoadTexture(g_factory, g_skin[skin].prev_picture)
		local next_texture = ResourceFactoryLoadTexture(g_factory, g_skin[skin].next_picture)
		
		local prev_next_rectangle_width = 0
		foreach(value in _array_value)
		{
			local width_value = TextComputeRect(Rect(0,0,9999,9999), value.tostring()+" "+unit.tostring(), "gui_font", { size = g_size_font_text }).ex
			if(width_value > prev_next_rectangle_width)
				prev_next_rectangle_width = width_value
		}

		local text_rect = TextComputeRect(Rect(0,0,9999,9999), _text, "gui_font", { size = g_size_font_text })

		// get the rect occupied by the text
		local MiddleRect = Rect(0,0,9999,9999)
		MiddleRect.ex = text_rect.ex + TextureGetWidth(prev_texture) + prev_next_rectangle_width + TextureGetWidth(next_texture)
		MiddleRect.ey = TextureGetHeight(middle_texture)

		if(_max_width != -1)
			MiddleRect.ex = _max_width - (TextureGetWidth(left_texture) + TextureGetWidth(right_texture) + TextureGetWidth(prev_texture) + TextureGetWidth(next_texture))
		
		MiddleRect.ex = MiddleRect.ex.tointeger()
		MiddleRect.ey = MiddleRect.ey.tointeger()
			
		if(MiddleRect.ex < 1)
			MiddleRect.ex = 1
	
		
		width = TextureGetWidth(left_texture) + text_rect.ex+ TextureGetWidth(prev_texture) + prev_next_rectangle_width + TextureGetWidth(next_texture) + TextureGetWidth(right_texture)
		height = TextureGetHeight(right_texture)

		// blit left part
		{
			TextureSetWrapping(left_texture, false,false)
			local relative_pos = Vector(0,0,0)
			array_texture.rawset("left_part", left_texture)
			array_sprite.rawset("left_part", UIAddSprite(g_WindowsManager.current_ui, -1, left_texture, pos.x+relative_pos.x, pos.y+relative_pos.y, TextureGetWidth(left_texture), TextureGetHeight(left_texture)))
			array_sprite_relative_pos.rawset("left_part", relative_pos)			
		}
		// blit the middle part				
		{		
			TextureSetWrapping(middle_texture, true,false)
			local relative_pos =  Vector(TextureGetWidth(left_texture),0,0)
			array_texture.rawset("middle_part", middle_texture)
			array_sprite.rawset("middle_part", UIAddSprite(g_WindowsManager.current_ui, -1, middle_texture, pos.x+relative_pos.x, pos.y+relative_pos.y, MiddleRect.ex , MiddleRect.ey))
			array_sprite_relative_pos.rawset("middle_part", relative_pos)			
			
			SpriteSetEventHandlerWithContext(array_sprite["middle_part"], EventCursorDown, this, ClickDownEvent)
			SpriteSetEventHandlerWithContext(array_sprite["middle_part"], EventCursorUp, this, ClickUpEvent)
			SpriteSetEventHandlerWithContext(array_sprite["middle_part"], EventCursorMove, this, MouseMouseEvent)
		}			
		// blit right part
		{
			TextureSetWrapping(right_texture, false,false)
			local relative_pos = Vector(TextureGetWidth(left_texture)+MiddleRect.ex,0,0)
			array_texture.rawset("right_part", right_texture)
			array_sprite.rawset("right_part", UIAddSprite(g_WindowsManager.current_ui, -1, right_texture, pos.x+relative_pos.x, pos.y+relative_pos.y, TextureGetWidth(right_texture), TextureGetHeight(right_texture)))
			array_sprite_relative_pos.rawset("right_part", relative_pos)			
		}

		// blit text part
		{
			local texture = ResourceFactoryNewTexture(g_factory)	
			local pict = PictureNew()					
			PictureAlloc(pict, text_rect.ex , MiddleRect.ey)			
			PictureTextRender(pict, Rect(0, 10, text_rect.ex, MiddleRect.ey), _text, "gui_font" ,{ size = g_size_font_text, color = g_size_font_color_text })
			
			TextureUpdate(texture, pict)
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(TextureGetWidth(left_texture),0,0)
			array_texture.rawset("text_part", texture)
			array_picture.rawset("text_part", pict)		
			array_sprite_relative_pos.rawset("text_part", relative_pos)	

			if(alignment == "left")
				array_sprite_relative_pos["text_part"] = Vector(SpriteGetSize(array_sprite["left_part"]).x,0,0)
			else
			if(alignment == "center")
				array_sprite_relative_pos["text_part"] = Vector(SpriteGetSize(array_sprite["left_part"]).x+width*0.5- text_rect.ex*0.5,0,0)
			else
			if(alignment == "right")
				array_sprite_relative_pos["text_part"] = Vector(width-text_rect.ex ,0,0)
				
			array_sprite.rawset("text_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+array_sprite_relative_pos["text_part"].x, pos.y+array_sprite_relative_pos["text_part"].y, text_rect.ex , MiddleRect.ey))		

			SpriteSetEventHandlerWithContext(array_sprite["text_part"], EventCursorDown, this, ClickDownEvent)
			SpriteSetEventHandlerWithContext(array_sprite["text_part"], EventCursorUp, this, ClickUpEvent)
			SpriteSetEventHandlerWithContext(array_sprite["text_part"], EventCursorMove, this, MouseMouseEvent)					
		}	
		// blit prev part
		{
			TextureSetWrapping(prev_texture, false,false)
			local relative_pos = Vector(TextureGetWidth(left_texture) + text_rect.ex,0,0)
			array_texture.rawset("prev_part", prev_texture)
			array_sprite.rawset("prev_part", UIAddSprite(g_WindowsManager.current_ui, -1, prev_texture, pos.x+relative_pos.x, pos.y+relative_pos.y, text_rect.ex , MiddleRect.ey))
			array_sprite_relative_pos.rawset("prev_part", relative_pos)							
		}	
		// blit value part
		{
			local texture = ResourceFactoryNewTexture(g_factory)	
			local pict = PictureNew()					
			PictureAlloc(pict, prev_next_rectangle_width , MiddleRect.ey)			
			PictureTextRender(pict, Rect(0, 10, prev_next_rectangle_width, MiddleRect.ey), _array_value[current_index].tostring()+" "+unit.tostring(), "gui_font" ,{ size = g_size_font_text, color = g_size_font_color_text })
			
			TextureUpdate(texture, pict)
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(TextureGetWidth(left_texture) + text_rect.ex + TextureGetWidth(prev_texture),0,0)
			array_texture.rawset("value_part", texture)
			array_picture.rawset("value_part", pict)
			array_sprite.rawset("value_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, prev_next_rectangle_width , MiddleRect.ey))
			array_sprite_relative_pos.rawset("value_part", relative_pos)							
		}	
		// blit next part
		{
			TextureSetWrapping(next_texture, false,false)
			local relative_pos = Vector(TextureGetWidth(left_texture) + text_rect.ex + TextureGetWidth(prev_texture) + prev_next_rectangle_width,0,0)
			array_texture.rawset("next_part", next_texture)
			array_sprite.rawset("next_part", UIAddSprite(g_WindowsManager.current_ui, -1, next_texture, pos.x+relative_pos.x, pos.y+relative_pos.y, text_rect.ex , MiddleRect.ey))
			array_sprite_relative_pos.rawset("next_part", relative_pos)							
		}	
					
		// add click prev section
		{
			local relative_pos = Vector(TextureGetWidth(left_texture) + text_rect.ex,0,0)
			local sprite = UIAddSprite(g_WindowsManager.current_ui, -1, NullTexture, pos.x+relative_pos.x, pos.y+relative_pos.y, TextureGetWidth(prev_texture), height)
			array_sprite.rawset("click_prev_part", sprite)
			array_sprite_relative_pos.rawset("click_prev_part", relative_pos)		
			
			SpriteSetEventHandlerWithContext(sprite, EventCursorDown, this, ClickPrevButtonEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorEnter, this, CursorEnterEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorLeave, this, CursorLeaveEvent)						
		}	
		// add click next section
		{
			local relative_pos = Vector(TextureGetWidth(left_texture) + text_rect.ex + TextureGetWidth(prev_texture) + prev_next_rectangle_width,0,0)
			local sprite = UIAddSprite(g_WindowsManager.current_ui, -1, NullTexture, pos.x+relative_pos.x, pos.y+relative_pos.y, TextureGetWidth(next_texture), height)
			array_sprite.rawset("click_next_part", sprite)
			array_sprite_relative_pos.rawset("click_next_part", relative_pos)		
			
			SpriteSetEventHandlerWithContext(sprite, EventCursorDown, this, ClickNextButtonEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorEnter, this, CursorEnterEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorLeave, this, CursorLeaveEvent)						
		}
	}
			
	////////////////////////////////////////////////////////////////////////
	
	function	constructor(_id = 0, _parent = 0, _instance=0, _func="", _text ="", _unit="", _array_value = {}, _current_index = 0)
	{	
		type = "PrevNextSprite"		
		base.constructor(_id, _parent)		
		
		text = _text
		unit = _unit
		array_value = _array_value		
		current_index = _current_index
		CreateSpriteWithText(text, array_value)	
		
		if(_instance && typeof(_func) == "string" && _func.len() > 0)
			array_instance_function_callback.append({instance=_instance,func_name=_func})
	}
}
