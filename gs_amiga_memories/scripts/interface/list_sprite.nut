
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	ListSprite
	@author	Scorpheus
*/
class	ListSprite extends BasicSprite
{					
	max_sprite = 0	

	percent_scrollbar = 0
	start_id = 0
	
	cursor_down_on_scrollbar = 0

	total_height_child = 0
	
	////////////////////////////////////////////////////////////////////////
	
	function SetMaxSprite(_max_sprite)
	{
		max_sprite = _max_sprite
	}
	
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
	
	function SetZOrder(_z_order, _go_to_parent=false)
	{
		base.SetZOrder(_z_order, _go_to_parent)
		
		SpriteSetZOrder(array_sprite["list_scrollbar"], -100)

	}	
	////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////
	
	function 	SetSelectedChild(_id)
	{
		if(start_id < 0)
			start_id = 0
		if(start_id >= child_array.len())
			start_id = child_array.len() -1

		percent_scrollbar = start_id.tofloat() / (child_array.len() - max_sprite) 

		array_sprite_relative_pos["list_scrollbar"].y = (total_height_child-SpriteGetSize(array_sprite["list_scrollbar"]).y)*percent_scrollbar
			
		SpriteSetPosition(array_sprite["list_scrollbar"],  pos.x+ array_sprite_relative_pos["list_scrollbar"].x, pos.y+ array_sprite_relative_pos["list_scrollbar"].y)

		Show(true)
		SetPos(pos)
	}

	////////////////////////////////////////////////////////////////////////
	
	function	ClickSliderButtonEvent(event, table)
	{
		cursor_down_on_scrollbar = true		
		UILockToSprite(g_WindowsManager.current_ui, array_sprite["list_scrollbar"])
		g_WindowsManager.mouse_locked_by_ui = true
	}
	function	UnClickSliderButtonEvent(event, table)
	{
		cursor_down_on_scrollbar = false
		UIUnlock(g_WindowsManager.current_ui)
		g_WindowsManager.mouse_locked_by_ui = false
	}
	function	CursorMoveSliderEvent(event, table)
	{
		if(cursor_down_on_scrollbar)
		{			
			// move the slider sprite		
			local mouse_pos = g_cursor.GetMousePos()

			if((mouse_pos.y - pos.y)  < 0.0)
				percent_scrollbar = 0.0
			else
			if((mouse_pos.y - pos.y) > total_height_child)
				percent_scrollbar = 1.0
			else
				percent_scrollbar = (mouse_pos.y - pos.y)/total_height_child

			array_sprite_relative_pos["list_scrollbar"].y = (total_height_child-SpriteGetSize(array_sprite["list_scrollbar"]).y)*percent_scrollbar

			start_id = ((child_array.len() - max_sprite) * percent_scrollbar).tointeger()
				
			SpriteSetPosition(array_sprite["list_scrollbar"],  pos.x+ array_sprite_relative_pos["list_scrollbar"].x, pos.y+ array_sprite_relative_pos["list_scrollbar"].y)
				
			Show(true)
			SetPos(pos)
		}
	}
		
	////////////////////////////////////////////////////////////////////////
	
	function Hide(_with_all_children = false)
	{
		base.Hide(_with_all_children)
		SpriteSetOpacity(array_sprite["list_scrollbar"], 0.0)
	}

	function Show(_with_all_children = false)
	{
		base.Show(_with_all_children)
		
		foreach(id, child in child_array)
			if(id < start_id || id > max_sprite+start_id-1)
				child.Hide(true)

		if(child_array.len() <= max_sprite)
			SpriteSetOpacity(array_sprite["list_scrollbar"], 0.0)
		else
			SpriteSetOpacity(array_sprite["list_scrollbar"], 1.0)
	}		
	////////////////////////////////////////////////////////////////////////
	
	function SetPos(_pos)
	{
		base.SetPos(_pos)
		
		// all child has space, put them at good distance
		local temp_pos = clone(pos)				
		foreach(id, child in child_array)
		{
			if(id >= start_id && id < max_sprite+start_id)
			{
				child.SetPos(temp_pos)
				temp_pos.y += child.height
			}
			else
				child.Hide(true)
		}				

		if("little_shadow_sprite" in array_sprite)
			SpriteSetScale(array_sprite["little_shadow_sprite"], width.tofloat()/ SpriteGetSize(array_sprite["little_shadow_sprite"]).x, 1.0)
	}
	function SetSize(_width, _height, _child=0)
	{
		base.SetSize(_width, _height, _child)

		total_height_child = 0.0
		foreach(id, child in child_array)		
		{
			child.SetSize(width, child.height)
			if(id >= start_id && id < max_sprite+start_id)
				total_height_child += child.height
		}	

		array_sprite_relative_pos["list_scrollbar"] = Vector(-30.0, (total_height_child-SpriteGetSize(array_sprite["list_scrollbar"]).y)*percent_scrollbar, 0.0)

		if("little_shadow_sprite" in array_sprite)
			array_sprite_relative_pos["little_shadow_sprite"].y = total_height_child	
	
		// all child has space, put them at good distance	
		SetPos(pos)
	}		
	
	////////////////////////////////////////////////////////////////////////
	
	function AppendChild(_child)
	{
		base.AppendChild(_child)
		
		// check if the child has bigger width
		if(_child.width > width)
			original_width = width = _child.width
			
		SetSize(width, height)
		
		if(parent)
			parent.SetSize(parent.width, parent.height, this)

		if(child_array.len() >= max_sprite)
		{
			_child.Hide(true)
			SpriteSetOpacity(array_sprite["list_scrollbar"], 1.0)
		}
	}
	function RemoveChild(_id)
	{		
		base.RemoveChild(_id)		
	}
		
	////////////////////////////////////////////////////////////////////////
	
	function Kill(_with_child)
	{
		base.Kill(_with_child)
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function	constructor( _id = 0, _parent = 0)
	{			
		base.constructor(_id, _parent)
		type = "ListSprite"		
		
		max_sprite = 5
		percent_scrollbar = 0.0
		start_id = 0
	
		cursor_down_on_scrollbar = false
		total_height_child = 0	

		// create the little shadow
		if(!parent)
		{
			local texture_little_shadow = ResourceFactoryLoadTexture(g_factory, "ui/window_bottom_shadow.tga")
			TextureSetWrapping(texture_little_shadow, true,false)
			array_sprite.rawset("little_shadow_sprite", UIAddSprite(g_WindowsManager.current_ui, -1, texture_little_shadow, pos.x, pos.y+height, TextureGetWidth(texture_little_shadow), TextureGetHeight(texture_little_shadow)))
			array_sprite_relative_pos.rawset("little_shadow_sprite", Vector(0.0, height, 0.0))	
		}


		//create the slide bar
		{
			local texture_list_scrollbar = ResourceFactoryLoadTexture(g_factory, g_skin[skin].vertical_scroll_picture)
			TextureSetWrapping(texture_list_scrollbar, false,false)
			array_sprite.rawset("list_scrollbar", UIAddSprite(g_WindowsManager.current_ui, -1, texture_list_scrollbar, pos.x + width -TextureGetWidth(texture_list_scrollbar), pos.y, TextureGetWidth(texture_list_scrollbar), TextureGetHeight(texture_list_scrollbar)))
			SpriteSetOpacity(array_sprite["list_scrollbar"], 0.0)

			array_sprite_relative_pos.rawset("list_scrollbar", Vector(-30.0, (total_height_child-SpriteGetSize(array_sprite["list_scrollbar"]).y)*percent_scrollbar, 0.0))	

			array_sprite_blacklist_automatic_show.rawset("list_scrollbar", true)

			SpriteSetZOrder(array_sprite["list_scrollbar"], -100)

			SpriteSetEventHandlerWithContext(array_sprite["list_scrollbar"], EventCursorDown, this, ClickSliderButtonEvent)		
			SpriteSetEventHandlerWithContext(array_sprite["list_scrollbar"], EventCursorUp, this, UnClickSliderButtonEvent)
			SpriteSetEventHandlerWithContext(array_sprite["list_scrollbar"], EventCursorMove, this, CursorMoveSliderEvent)		
		}
	}
}
