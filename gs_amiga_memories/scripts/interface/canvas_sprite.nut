
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	CanvasSprite
	@author	Scorpheus
*/
class	CanvasSprite extends BasicSprite
{		

	////////////////////////////////////////////////////////////////////////
	
	function GetTexture()
	{		
		return array_texture["canvas_part"]
	}
	////////////////////////////////////////////////////////////////////////
	
	function CanvasFill(_color)
	{		
		PictureFill(array_picture["canvas_part"], _color)
	}
	////////////////////////////////////////////////////////////////////////
	
	function FillRect(x_start, y_start, x_end, y_end, _color)
	{		
		PictureFillRect(array_picture["canvas_part"], _color, Rect(x_start, y_start, x_end, y_end))
	}
	////////////////////////////////////////////////////////////////////////
	
	function DrawLine(x_start, y_start, x_end, y_end, _color)
	{		
		PictureLine(array_picture["canvas_part"], x_start, y_start, x_end, y_end, _color)
	}
	////////////////////////////////////////////////////////////////////////
	
	function DrawText(_text, x_start, y_start, x_end, y_end)
	{		
		PictureTextRender(array_picture["canvas_part"], Rect(x_start, y_start, x_end, y_end), _text.tostring(), "gui_font" ,{ size = g_size_font_text, color = g_size_font_color_text })												
	}
	////////////////////////////////////////////////////////////////////////
	
	function UpdateLostContent()
	{
		base.UpdateLostContent()
		
		foreach(sprite in array_sprite)
			UIDeleteSprite(g_WindowsManager.current_ui, sprite)
		array_sprite.clear()
		array_sprite_relative_pos.clear()
		CreateBitmap(name_sprite)
	}

	////////////////////////////////////////////////////////////////////////
	
	function Show(_with_all_children = false)
	{
		base.Show(_with_all_children)
		CallCallback()		
	}		
	
	////////////////////////////////////////////////////////////////////////
	
	function Update(_with_all_children = false)
	{
		base.Update(_with_all_children)
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function SerializationLoad(serialization_table)
	{
		name_sprite = serialization_table["name_sprite"]
		base.SerializationLoad(serialization_table)
		
		CreateBitmap(name_sprite)	
	}	
	function SerializationSave()
	{
		local serialization_string = "name_sprite=\""+ name_sprite.tostring()+"\", "
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

	function	RefreshValue()
	{
		if(is_shown)
			TextureUpdate(array_texture["canvas_part"], array_picture["canvas_part"])
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
		UILockToSprite(g_WindowsManager.current_ui, array_sprite["click_part"])
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function	ClickButtonEvent(event, table)
	{
		// if it's right click
		local ui_device = GetInputDevice("mouse")
		if(DeviceIsKeyDown(ui_device, KeyButton1))
			return
		
		CallCallback()
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function SetPos(_pos)
	{		
		local old_pos = pos
		base.SetPos(_pos)	

		foreach(child in child_array)
		{
			child.SetPos(child.pos + (pos-old_pos))
		}

		if("little_shadow_sprite" in array_sprite)
			SpriteSetScale(array_sprite["little_shadow_sprite"], width.tofloat()/ SpriteGetSize(array_sprite["little_shadow_sprite"]).x, 1.0)
	}
	function SetSize(_width, _height, _child=0)
	{
		local old_width = width
		
		base.SetSize(_width, _height, _child)	
		
		if(array_sprite.len() > 0)
		{		
			SetPos(pos)
		}
		else
			CreateCanvas()
						
	}				
	
	////////////////////////////////////////////////////////////////////////
	
	function CreateCanvas()
	{			
		CleanSprites()

		// create the little shadow
		if(!parent)
		{
			local texture_little_shadow = ResourceFactoryLoadTexture(g_factory, "ui/window_bottom_shadow.tga")
			TextureSetWrapping(texture_little_shadow, true,false)
			array_sprite.rawset("little_shadow_sprite", UIAddSprite(g_WindowsManager.current_ui, -1, texture_little_shadow, pos.x, pos.y+height, TextureGetWidth(texture_little_shadow), TextureGetHeight(texture_little_shadow)))
			array_sprite_relative_pos.rawset("little_shadow_sprite", Vector(0.0, height, 0.0))	
		}
		
		local canvas_picture = PictureNew()
		PictureAlloc(canvas_picture, width, height)

		// blit bitmap part
		{
			local texture = ResourceFactoryNewTexture(g_factory)		
			TextureUpdate(texture, canvas_picture)
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(0,0,0)
			array_texture.rawset("canvas_part", texture)
			array_picture.rawset("canvas_part", canvas_picture)
			array_sprite.rawset("canvas_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, width, height))
			array_sprite_relative_pos.rawset("canvas_part", relative_pos)			
		}

		// add click section
		{
			local relative_pos = Vector(0,0,0)
			local sprite = UIAddSprite(g_WindowsManager.current_ui, -1, NullTexture, pos.x+relative_pos.x, pos.y+relative_pos.y, width, height)
			array_sprite.rawset("click_part", sprite)
			array_sprite_relative_pos.rawset("click_part", relative_pos)		
			
			SpriteSetEventHandlerWithContext(sprite, EventCursorDown, this, ClickDownEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorUp, this, ClickUpEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorMove, this, MouseMouseEvent)
			
			SpriteSetEventHandlerWithContext(sprite, EventCursorEnter, this, CursorEnterEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorLeave, this, CursorLeaveEvent)						
		}
	}
		
	////////////////////////////////////////////////////////////////////////
	
	function	constructor(_id = 0, _parent = 0, _instance=0, _func="")
	{	
		type = "CanvasSprite"		
		base.constructor(_id, _parent)	
		
		if(_instance && typeof(_func) == "string" && _func.len() > 0)
			array_instance_function_callback.append({instance=_instance,func_name=_func})

	}
}
