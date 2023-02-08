
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	AnimatedSprite
	@author	Scorpheus
*/
class	AnimatedSprite extends BasicSprite
{		
	name_sprite = 0

	scaleX = 0
	scaleY = 0

	total_animation = 0
	current_animation = 0
	current_timer = 0
	duration_frame = 0
	total_duration = 0

	loop = 0
	hide_when_finish = 0


	////////////////////////////////////////////////////////////////////////
	
	function SetAlpha(_alpha)
	{		
		SpriteSetOpacity(array_sprite["current_bitmap_part"], _alpha)	
	}
	////////////////////////////////////////////////////////////////////////
	
	function UpdateLostContent()
	{
		base.UpdateLostContent()
		
		foreach(sprite in array_sprite)
			UIDeleteSprite(g_WindowsManager.current_ui, sprite)
		array_sprite.clear()
		array_sprite_relative_pos.clear()
		CreateAnimated(name_sprite)
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
		
		CreateAnimated(name_sprite)	
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

	function	RefreshValueText()
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
		base.SetPos(_pos)	
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
			CreateAnimated(name_sprite)	
						
	}		
	function SetScale(_scaleX, _scaleY, _child=0)
	{
		scaleX = _scaleX
		scaleY = _scaleY
		if(array_sprite.len() > 0)
		{		
			SpriteSetScale(array_sprite["click_part"], scaleX, scaleY)	
			SpriteSetScale(array_sprite["current_bitmap_part"], scaleX, scaleY)	
		}
		else
			CreateAnimated(name_sprite)	
						
	}					
	
	////////////////////////////////////////////////////////////////////////
	
	function StartAnim()
	{
		current_timer = 0
		current_animation = 0
	}
	function StopAnim()
	{
		current_animation = total_animation
	}

	function IsFinish()
	{
		if(current_animation >= total_animation)
			return true
		else
			return false
	}

	////////////////////////////////////////////////////////////////////////
	
	function Update(_with_all_children = false)
	{
		base.Update(_with_all_children)

		current_timer += g_dt_frame
		if(current_timer >= duration_frame && current_animation < total_animation)
		{
			current_timer = 0
			++current_animation
			if(loop && current_animation >= total_animation)
				current_animation = 0
			
			if( current_animation < total_animation)
				TextureUpdate(array_texture["current_bitmap_part"], array_picture["bitmap_part_"+current_animation.tostring()])
			else
				if(hide_when_finish)
					Hide(true)
		}
	}

	////////////////////////////////////////////////////////////////////////
	
	function CreateAnimated( _name_sprite)
	{			
		CleanSprites()
		local current_bitmap_picture = PictureNew()
		PictureLoadContent(current_bitmap_picture, _name_sprite+FormatSequenceFilename(0)+".png")

		// blit bitmap part
		{
			local texture = ResourceFactoryNewTexture(g_factory)		
			TextureUpdate(texture, current_bitmap_picture)
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(0,0,0)
			array_texture.rawset("current_bitmap_part", texture)
			array_picture.rawset("current_bitmap_part", current_bitmap_picture)
			array_sprite.rawset("current_bitmap_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, PictureGetRect(current_bitmap_picture).ex, PictureGetRect(current_bitmap_picture).ey))
			array_sprite_relative_pos.rawset("current_bitmap_part", relative_pos)			
		}

		// load all the sequence
		local count = 0
		while(FileExists(_name_sprite+FormatSequenceFilename(count)+".png"))
			// blit bitmap part
			{
				local bitmap_picture = PictureNew()
				PictureLoadContent(bitmap_picture, _name_sprite+FormatSequenceFilename(count)+".png")
				local texture = ResourceFactoryNewTexture(g_factory)		
				TextureUpdate(texture, bitmap_picture)
				TextureSetWrapping(texture, false,false)
				local relative_pos = Vector(0,0,0)
				array_texture.rawset("bitmap_part_"+count.tostring(), texture)
				array_picture.rawset("bitmap_part_"+count.tostring(), bitmap_picture)
				array_sprite.rawset("bitmap_part_"+count.tostring(), UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, PictureGetRect(bitmap_picture).ex, PictureGetRect(bitmap_picture).ey))
				array_sprite_relative_pos.rawset("bitmap_part_"+count.tostring(), relative_pos)		

				SpriteSetOpacity(array_sprite["bitmap_part_"+count.tostring()], 0.0)
  				array_sprite_blacklist_automatic_show.rawset("bitmap_part_"+count.tostring(), true)	
				++count	
			}

		duration_frame = total_duration.tofloat() / count.tofloat()
		total_animation = count
		
		width = PictureGetRect(current_bitmap_picture).ex
		height = PictureGetRect(current_bitmap_picture).ey
						
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
		
	//------------------------------------------
	function			FormatSequenceFilename(n)
	//------------------------------------------
	{
		if 		(n < 10)		return ("0000" + n.tostring())
		if 		(n < 100)		return ("000" + n.tostring())
		if 		(n < 1000)		return ("00" + n.tostring())
		return (n.tostring())
	}
	////////////////////////////////////////////////////////////////////////
	
	function	constructor(_id = 0, _parent = 0, _instance=0, _func="", _name_sprite ="", _total_duration = 1.0)
	{	
		type = "AnimatedSprite"		
		base.constructor(_id, _parent)	

		scaleX = 1.0
		scaleY = 1.0	
		total_duration = _total_duration

		total_animation = 0
		current_animation = 0
		current_timer = 0
		duration_frame = 0

		loop = true
		hide_when_finish = false
				
		name_sprite = _name_sprite
		CreateAnimated(name_sprite)	
		
		if(_instance && typeof(_func) == "string" && _func.len() > 0)
			array_instance_function_callback.append({instance=_instance,func_name=_func})
	}
}
