
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	BitmapSprite
	@author	Scorpheus
*/
class	BitmapSprite extends BasicSprite
{		
	name_sprite = 0

	scaleX = 0
	scaleY = 0

	authorize_background = 0

	
	////////////////////////////////////////////////////////////////////////
	
	function SetAlpha(_alpha)
	{		
		SpriteSetOpacity(array_sprite["bitmap_part"], _alpha)	
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
	
	function Hide(_with_all_children = false)
	{
		base.Hide(_with_all_children)

		if("middle_part" in array_sprite)
				SpriteSetOpacity(array_sprite["middle_part"], 0.0)
	}
	
	function Show(_with_all_children = false)
	{
		base.Show(_with_all_children)

		if(!authorize_background)
		{			
			if("middle_part" in array_sprite)
				SpriteSetOpacity(array_sprite["middle_part"], 0.0)
		}
		else
		{
			if("middle_part" in array_sprite)
				SpriteSetOpacity(array_sprite["middle_part"], 1.0)
		}
	}
	////////////////////////////////////////////////////////////////////////

	function	RefreshValueText()
	{
	}

	////////////////////////////////////////////////////////////////////////
	
	function	ClickUpEvent(event, table)
	{
		if(!parent || authorize_click)
		{
			base.ClickUpEvent(event, table)
			UIUnlock(g_WindowsManager.current_ui)
		}
		else
		{
			parent.ClickUpEvent(event, table)
		}
	}
	
	function	ClickDownEvent(event, table)
	{
		if(!parent || authorize_click)
		{
			base.ClickDownEvent(event, table)
			UILockToSprite(g_WindowsManager.current_ui, array_sprite["click_part"])
		}
		else
		{
			parent.ClickDownEvent(event, table)
		}
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
		base.SetPos(_pos)	
	}
	function SetSize(_width, _height, _child=0)
	{
		local old_width = width
		
		base.SetSize(_width, _height, _child)	

		SpriteSetOpacity(array_sprite["middle_part"], 0.0)
		
		if(array_sprite.len() > 0)
		{		
			SetPos(pos)
			SpriteSetSize(array_sprite["bitmap_part"], width, height)	

			if(authorize_background)
			{
				SpriteSetOpacity(array_sprite["middle_part"], 1.0)
				SpriteSetSize(array_sprite["middle_part"], width, height)
			}	
			else
				SpriteSetOpacity(array_sprite["middle_part"], 0.0)
		}
		else
			CreateBitmap(text)	
						
	}		
	function SetScale(_scaleX, _scaleY, _child=0)
	{
		scaleX = _scaleX
		scaleY = _scaleY
		if(array_sprite.len() > 0)
		{		
			SpriteSetScale(array_sprite["click_part"], scaleX, scaleY)	
			SpriteSetScale(array_sprite["bitmap_part"], scaleX, scaleY)	
			SpriteSetScale(array_sprite["middle_part"], scaleX, scaleY)	
		}
		else
			CreateBitmap(text)	
						
	}
	function SetRotation(_angle)
	{
		base.SetRotation(_angle)
	}					
	
	////////////////////////////////////////////////////////////////////////
	
	function CreateBitmap( _name_sprite)
	{			
		CleanSprites()

		local middle_texture = ResourceFactoryLoadTexture(g_factory, g_skin[skin].middle_picture)

		// blit the middle part
		{		
			TextureSetWrapping(middle_texture, false,false)
			local relative_pos = Vector(0.0,0,0)
			array_texture.rawset("middle_part", middle_texture)
			array_sprite.rawset("middle_part", UIAddSprite(g_WindowsManager.current_ui, -1, middle_texture, pos.x+relative_pos.x, pos.y+relative_pos.y, 1 , 1))
			array_sprite_relative_pos.rawset("middle_part", relative_pos)			

			array_sprite_blacklist_automatic_show.rawset("middle_part", true)	
			SpriteSetOpacity(array_sprite["middle_part"], 0.0)
		}				

		local bitmap_texture = ResourceFactoryLoadTexture(g_factory, _name_sprite)

		// blit bitmap part
		{
			TextureSetWrapping(bitmap_texture, false,false)
			local relative_pos = Vector(0,0,0)
			array_texture.rawset("bitmap_part", bitmap_texture)
			array_sprite.rawset("bitmap_part", UIAddSprite(g_WindowsManager.current_ui, -1, bitmap_texture, pos.x+relative_pos.x, pos.y+relative_pos.y, TextureGetWidth(bitmap_texture), TextureGetHeight(bitmap_texture)))
			array_sprite_relative_pos.rawset("bitmap_part", relative_pos)			
		}
		
		original_width = width = TextureGetWidth(bitmap_texture)
		original_height = height = TextureGetHeight(bitmap_texture)
				
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
	
	function	constructor(_id = 0, _parent = 0, _instance=0, _func="", _name_sprite ="")
	{	
		type = "BitmapSprite"		
		base.constructor(_id, _parent)	

		scaleX = 1.0
		scaleY = 1.0	

		authorize_background = false
			
		name_sprite = _name_sprite
		CreateBitmap(name_sprite)	
		
		if(_instance && typeof(_func) == "string" && _func.len() > 0)
			array_instance_function_callback.append({instance=_instance,func_name=_func})
	}
}
