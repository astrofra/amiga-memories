
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	HorizontalSizerSprite
	@author	Scorpheus
*/
class	HorizontalSizerSprite extends BasicSprite
{					
	width_total_child = 0

	authorize_background = 0
	
	////////////////////////////////////////////////////////////////////////
	
	function Update(_with_all_children = false)
	{
		base.Update(_with_all_children)
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function SerializationLoad(serialization_table)
	{
		base.SerializationLoad(serialization_table)
	}	
	function SerializationSave()
	{
		local serialization_string = base.SerializationSave()
		return serialization_string
	}
		
	////////////////////////////////////////////////////////////////////////
	
	function Show(_with_all_children = false)
	{
		base.Show(_with_all_children)

		if(child_array.len() > 0 && "middle_part" in array_sprite)			
			SpriteSetOpacity(array_sprite["middle_part"], 1.0)
	}

	////////////////////////////////////////////////////////////////////////
	
	function Hide(_with_all_children = false)
	{
		base.Hide(_with_all_children)
		
		if("middle_part" in array_sprite)
			SpriteSetOpacity(array_sprite["middle_part"], 0.0)
	}

	////////////////////////////////////////////////////////////////////////
	
	function SetPos(_pos)
	{
		base.SetPos(_pos)
		
		// all child has space, put them at good distance
		local temp_pos = clone(pos)				
		foreach(child in child_array)
		{
			child.SetPos(temp_pos)
			temp_pos.x += child.width + decal_sprite_x
		}				

		if("little_shadow_sprite" in array_sprite)
			SpriteSetScale(array_sprite["little_shadow_sprite"], width.tofloat()/ SpriteGetSize(array_sprite["little_shadow_sprite"]).x, 1.0)
	}
	function SetSize(_width, _height, _child=0)
	{
		base.SetSize(_width, height, _child)
				
		if(child_array.len() > 0)
		{		
			local max_width = width
			width_total_child = 0
			foreach(child in child_array)
				if(child.authorize_resize)
					width_total_child += child.original_width
				else
					max_width -= child.original_width

			if("little_shadow_sprite" in array_sprite)
			{
				local max_height = 0
				foreach(child in child_array)
					if(max_height < child.original_height)
						max_height = child.original_height

				array_sprite_relative_pos.rawset("little_shadow_sprite", Vector(0.0, max_height, 0.0))	
			}
					
			if(width_total_child > 0)
			{
				foreach(child in child_array)
				{
					child.SetSize((child.original_width * max_width) / width_total_child, height)
				}				
			}
			
			// all child has space, put them at good distance
			SetPos(pos)

			local max_height = 0
			local total_width = 0
			foreach(child in child_array)
			{
				if(max_height < child.original_height)
					max_height = child.original_height

				total_width += child.width
			}

			if(authorize_background)
			{
				if("middle_part" in array_sprite)
				{
					SpriteSetOpacity(array_sprite["middle_part"], 1.0)
					SpriteSetSize(array_sprite["middle_part"], total_width, max_height)	
				}
				SpriteSetSize(array_sprite["click_part"], total_width, max_height)	
			}	
			else
				if("middle_part" in array_sprite)				
					SpriteSetOpacity(array_sprite["middle_part"], 0.0)
		}	
		else
		{
			if("middle_part" in array_sprite)
				SpriteSetOpacity(array_sprite["middle_part"], 0.0)
		}	
	}		
	
	////////////////////////////////////////////////////////////////////////
	
	function AppendChild(_child)
	{
		base.AppendChild(_child)
		
		// check if the child has bigger height
		if(_child.height > height)
			original_height = height = _child.height
		
		SetSize(width, height)
		
		if(parent)
			parent.SetSize(parent.width, parent.height, this)
	}
	function RemoveChild(_id)
	{		
		base.RemoveChild(_id)
		
	}

	////////////////////////////////////////////////////////////////////////
	
	function CreateSprite()
	{			
		CleanSprites()

		local middle_picture = PictureNew()
		PictureLoadContent(middle_picture, g_skin[skin].middle_picture)	

		// blit the middle part
		{		
			local texture = ResourceFactoryNewTexture(g_factory)	
			local pict = PictureNew()		
			PictureAlloc(pict, PictureGetRect(middle_picture).ex, PictureGetRect(middle_picture).ey)			
			
			PictureBlitRect(middle_picture, pict, PictureGetRect(middle_picture), Rect(0,0, PictureGetRect(middle_picture).ex, PictureGetRect(middle_picture).ey), BlendCompose)
			
			TextureUpdate(texture, pict)
			TextureSetWrapping(texture, true,true)
			local relative_pos = Vector(0.0,0,0)
			array_texture.rawset("middle_part", texture)
			array_sprite.rawset("middle_part", UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, 1 , 1))
			array_sprite_relative_pos.rawset("middle_part", relative_pos)		

			array_sprite_blacklist_automatic_show.rawset("middle_part", true)
		}
		// add click section
		{
			local texture = ResourceFactoryNewTexture(g_factory)	
			TextureSetWrapping(texture, false,false)
			local relative_pos = Vector(0,0,0)
			array_texture.rawset("click_part", texture)
			local sprite = UIAddSprite(g_WindowsManager.current_ui, -1, texture, pos.x+relative_pos.x, pos.y+relative_pos.y, PictureGetRect(middle_picture).ex, PictureGetRect(middle_picture).ey)
			array_sprite.rawset("click_part", sprite)
			array_sprite_relative_pos.rawset("click_part", relative_pos)		
			
			SpriteSetEventHandlerWithContext(sprite, EventCursorDown, this, ClickDownEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorUp, this, ClickUpEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorMove, this, MouseMouseEvent)		
		}	
	}
	/*
	function CreateSprite()
	{			
		CleanSprites()

		local middle_texture = ResourceFactoryLoadTexture(g_factory, g_skin[skin].middle_picture)

		// blit the middle part
		{		
			TextureSetWrapping(middle_texture,  true, true)
			local relative_pos = Vector(0.0,0,0)
			array_texture.rawset("middle_part", middle_texture)
			array_sprite.rawset("middle_part", UIAddSprite(g_WindowsManager.current_ui, -1, middle_texture, pos.x+relative_pos.x, pos.y+relative_pos.y, 1 , 1))
			array_sprite_relative_pos.rawset("middle_part", relative_pos)			

			array_sprite_blacklist_automatic_show.rawset("middle_part", true)
		}		
		// add click section
		{
			local relative_pos = Vector(0,0,0)
			local sprite = UIAddSprite(g_WindowsManager.current_ui, -1, NullTexture, pos.x+relative_pos.x, pos.y+relative_pos.y, TextureGetWidth(middle_texture), TextureGetHeight(middle_texture))
			array_sprite.rawset("click_part", sprite)
			array_sprite_relative_pos.rawset("click_part", relative_pos)		
			
			SpriteSetEventHandlerWithContext(sprite, EventCursorDown, this, ClickDownEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorUp, this, ClickUpEvent)
			SpriteSetEventHandlerWithContext(sprite, EventCursorMove, this, MouseMouseEvent)		
		}	
	}
		*/
	////////////////////////////////////////////////////////////////////////
	
	function Kill(_with_child)
	{
		base.Kill(_with_child)
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function	constructor( _id = 0, _parent = 0)
	{			
		base.constructor(_id, _parent)
		type = "HorizontalSizerSprite"	

		width_total_child = 0

		authorize_background = true

		CreateSprite()

		// create the little shadow
		if(!parent)
		{
			local texture_little_shadow = ResourceFactoryLoadTexture(g_factory, "ui/window_bottom_shadow.tga")
			TextureSetWrapping(texture_little_shadow, true,false)
			array_sprite.rawset("little_shadow_sprite", UIAddSprite(g_WindowsManager.current_ui, -1, texture_little_shadow, pos.x, pos.y+height, TextureGetWidth(texture_little_shadow), TextureGetHeight(texture_little_shadow)))
			array_sprite_relative_pos.rawset("little_shadow_sprite", Vector(0.0, height, 0.0))	
		}
	}
}
