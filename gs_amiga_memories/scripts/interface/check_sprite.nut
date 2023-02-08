
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	CheckSprite
	@author	Scorpheus
*/
class	CheckSprite extends BasicSprite
{		
	text = 0
	checked = 0

	custom_picture_activate_check = 0
	custom_picture_deactivate_check = 0
	
	////////////////////////////////////////////////////////////////////////
	
	function UpdateLostContent()
	{
		base.UpdateLostContent()
		
		foreach(sprite in array_sprite)
			UIDeleteSprite(g_WindowsManager.current_ui, sprite)
		array_sprite.clear()
		array_sprite_relative_pos.clear()
		CreateCheckSprite(text, checked) 
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
		checked = serialization_table["checked"]
		custom_picture_activate_check = serialization_table["checked_picture"]
		custom_picture_deactivate_check = serialization_table["unchecked_picture"]

		base.SerializationLoad(serialization_table)
		
		CreateCheckSprite(text, checked)	
	}	
	function SerializationSave()
	{
		local serialization_string = "text=\""+ text.tostring()+"\", "
		serialization_string += "checked=\""+ checked.tostring()+"\", "

		if(custom_picture_activate_check.len() > 0)
			serialization_string += "checked_picture=\""+ custom_picture_activate_check.tostring()+"\", "
		else
			serialization_string += "checked_picture=\""+  g_skin[skin].check_picture.tostring()+"\", "

		if(custom_picture_deactivate_check.len() > 0)
			serialization_string += "unchecked_picture=\""+ custom_picture_deactivate_check.tostring()+"\", "
		else
			serialization_string += "unchecked_picture=\""+  g_skin[skin].uncheck_picture.tostring()+"\", "

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
				instance_callback.instance[instance_callback.func_name](this)
			}
		}
	}

	////////////////////////////////////////////////////////////////////////
	
	function RefreshValueText(_checked, _force=false)
	{
		if(is_shown && (_checked != checked || _force))
		{
			if(_checked)
			{
				if(custom_picture_activate_check.len() > 0)
					PictureLoadContent(array_picture["check_part"], custom_picture_activate_check)
				else
					PictureLoadContent(array_picture["check_part"], g_skin[skin].check_picture)
			}
			else		
			{
				if(custom_picture_deactivate_check.len() > 0)	
					PictureLoadContent(array_picture["check_part"], custom_picture_deactivate_check)	
				else
					PictureLoadContent(array_picture["check_part"], g_skin[skin].uncheck_picture)	
			}

			TextureUpdate(array_texture["check_part"], array_picture["check_part"])		
			checked = _checked

			if("text_part" in array_sprite_relative_pos)
			{
				PictureFill(array_picture["text_part"], Vector(0.0,0.0,0.0,0.0))
				PictureTextRender(array_picture["text_part"], Rect(0, 10, SpriteGetSize(array_sprite["text_part"]).x, SpriteGetSize(array_sprite["text_part"]).y),  text.tostring(), "gui_font" ,{ size = g_size_font_text, color = g_size_font_color_text })					
				TextureUpdate(array_texture["text_part"], array_picture["text_part"])			
			}
		}

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
		UILockToSprite(g_WindowsManager.current_ui, array_sprite["middle_part"])
	}
	
	function	ClickCheckButtonEvent(event, table)
	{
		// if it's right click
		local ui_device = GetInputDevice("mouse")
		if(DeviceIsKeyDown(ui_device, KeyButton1))
			return
		
		checked = !checked

		RefreshValueText(checked, true)

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
			
			if("text_part" in array_sprite_relative_pos)
			{
				if(alignment == "left")
					array_sprite_relative_pos["text_part"] = Vector(SpriteGetSize(array_sprite["left_part"]).x+SpriteGetSize(array_sprite["check_part"]).x,0,0)
				else
				if(alignment == "center")
					array_sprite_relative_pos["text_part"] = Vector(SpriteGetSize(array_sprite["left_part"]).x+SpriteGetSize(array_sprite["check_part"]).x+width*0.5-SpriteGetSize(array_sprite["text_part"]).x*0.5,0,0)
				else
				if(alignment == "right")
					array_sprite_relative_pos["text_part"] = Vector(width-SpriteGetSize(array_sprite["text_part"]).x,0,0)
			}
			SetPos(pos)
			
		//	SpriteSetScale(array_sprite[1], (old_width_middle.tofloat()/SpriteGetSize(array_sprite[1]).x.tofloat()), 1.0)					
		//	WindowSetCommandList(array_sprite[1],"toscale 0.3,1.0,1.0;")
		}
		else
			CreateCheckSprite(text, array_value, width)	
						
	}					
	
	////////////////////////////////////////////////////////////////////////
	
	function CreateCheckSprite(_text, _check, _max_width = -1)
	{				
		CleanSprites()

		local left_texture = ResourceFactoryLoadTexture(g_factory, g_skin[skin].left_picture)
		local middle_texture = ResourceFactoryLoadTexture(g_factory, g_skin[skin].middle_picture)
		local right_texture = ResourceFactoryLoadTexture(g_factory, g_skin[skin].right_picture)

		local check_picture = PictureNew()

		if(_check)
		{	
			if(custom_picture_activate_check.len() > 0)
				PictureLoadContent(check_picture, custom_picture_activate_check)
			else
				PictureLoadContent(check_picture, g_skin[skin].check_picture)
		}
		else		
		{	
			if(custom_picture_deactivate_check.len() > 0)	
				PictureLoadContent(check_picture, custom_picture_deactivate_check)	
			else
				PictureLoadContent(check_picture, g_skin[skin].uncheck_picture)	
		}
		local text_rect = TextComputeRect(Rect(0,0,9999,9999), _text, "gui_font", { size = g_size_font_text })

		// get the rect occupied by the text
		local MiddleRect = Rect(0,0,9999,9999)
		MiddleRect.ex = text_rect.ex + PictureGetRect(check_picture).ex
		MiddleRect.ey = TextureGetHeight(middle_texture)

		if(_max_width != -1)
			MiddleRect.ex = _max_width - (TextureGetWidth(left_texture) + TextureGetWidth(right_texture) + PictureGetRect(check_picture).ex)
		
		MiddleRect.ex = MiddleRect.ex.tointeger()
		MiddleRect.ey = MiddleRect.ey.tointeger()
			
		if(MiddleRect.ex < 1)
			MiddleRect.ex = 1


		width = TextureGetWidth(left_texture) + text_rect.ex+ PictureGetRect(check_picture).ex +TextureGetWidth(right_texture)
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

		// blit check part
		{
			local texture = ResourceFactoryNewTexture(g_factory)	

			TextureUpdate(texture, check_picture)
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(TextureGetWidth(left_texture) ,5,0)
			array_texture.rawset("check_part", texture)
			array_picture.rawset("check_part", check_picture)
			array_sprite.rawset("check_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, PictureGetRect(check_picture).ex, PictureGetRect(check_picture).ey))
			array_sprite_relative_pos.rawset("check_part", relative_pos)							
		}	
		
		// blit text part
		if(text_rect.ex > 0)
		{			
			local texture = ResourceFactoryNewTexture(g_factory)	
			local pict = PictureNew()					
			PictureAlloc(pict, text_rect.ex , MiddleRect.ey)			
			PictureTextRender(pict, Rect(0, 10, text_rect.ex, MiddleRect.ey), _text, "gui_font" ,{ size = g_size_font_text, color = g_size_font_color_text })
			
			TextureUpdate(texture, pict)
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(TextureGetWidth(left_texture) + PictureGetRect(check_picture).ex,0,0)
			array_texture.rawset("text_part", texture)
			array_picture.rawset("text_part", pict)
			array_sprite_relative_pos.rawset("text_part", relative_pos)							

			if(alignment == "left")
				array_sprite_relative_pos["text_part"] = Vector(SpriteGetSize(array_sprite["left_part"]).x+SpriteGetSize(array_sprite["check_part"]).x,0,0)
			else
			if(alignment == "center")
				array_sprite_relative_pos["text_part"] = Vector(SpriteGetSize(array_sprite["left_part"]).x+SpriteGetSize(array_sprite["check_part"]).x+width*0.5- text_rect.ex*0.5,0,0)
			else
			if(alignment == "right")
				array_sprite_relative_pos["text_part"] = Vector(width-text_rect.ex,0,0)
				
			array_sprite.rawset("text_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+array_sprite_relative_pos["text_part"].x, pos.y+array_sprite_relative_pos["text_part"].y, text_rect.ex , MiddleRect.ey))
			
			SpriteSetEventHandlerWithContext(array_sprite["text_part"], EventCursorDown, this, ClickDownEvent)
			SpriteSetEventHandlerWithContext(array_sprite["text_part"], EventCursorUp, this, ClickUpEvent)
			SpriteSetEventHandlerWithContext(array_sprite["text_part"], EventCursorMove, this, MouseMouseEvent)

		}			
		// add click check section
		{
			local relative_pos = Vector(TextureGetWidth(left_texture),0,0)
			local sprite = UIAddSprite(g_WindowsManager.current_ui, -1, NullTexture, pos.x+relative_pos.x, pos.y+relative_pos.y, PictureGetRect(check_picture).ex, height)
			array_sprite.rawset("click_check_part", sprite)
			array_sprite_relative_pos.rawset("click_check_part", relative_pos)		
			
			SpriteSetEventHandlerWithContext(sprite, EventCursorDown, this, ClickCheckButtonEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorEnter, this, CursorEnterEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorLeave, this, CursorLeaveEvent)						
		}	
	}
			
	////////////////////////////////////////////////////////////////////////
	
	function	constructor(_id = 0, _parent = 0, _instance=0, _func="", _text ="", _checked="", _custom_picture_activate_check="", _custom_picture_deactivate_check="")
	{	
		type = "CheckSprite"		
		base.constructor(_id, _parent)		
		
		custom_picture_activate_check = _custom_picture_activate_check
		custom_picture_deactivate_check = _custom_picture_deactivate_check
		
		text = _text
		checked = _checked
		CreateCheckSprite(text, checked)	

		if(_instance && typeof(_func) == "string" && _func.len() > 0)
			array_instance_function_callback.append({instance=_instance,func_name=_func})
	}
}
