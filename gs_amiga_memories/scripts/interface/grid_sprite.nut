
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	GridSprite
	@author	Scorpheus
*/
class	GridSprite extends BasicSprite
{		
	max_sprite_H = 0	
	max_sprite_V = 0	

	percent_scrollbar = 0
	start_id = 0
	skip_scroll_line = 0
	
	cursor_down_on_scrollbar = 0

	total_height_header = 0
	total_height_child = 0

	show_column_array = 0
	
	////////////////////////////////////////////////////////////////////////
	
	function ShowColumn(_id_column, _show)
	{
		if(_id_column >= 0 && _id_column < max_sprite_H)
			show_column_array[_id_column] = _show
	}
	function SetSkipScrollLine(_skip_scroll_line)
	{
		skip_scroll_line = _skip_scroll_line
	}
	function SetMaxSprite(_max_sprite_H, _max_sprite_V)
	{
		max_sprite_H = _max_sprite_H
		max_sprite_V = _max_sprite_V
		show_column_array = array(max_sprite_H, true)
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

	function	ClickSliderButtonEvent(event, table)
	{
		cursor_down_on_scrollbar = (g_cursor.GetMousePos().y - pos.y ) - array_sprite_relative_pos["list_scrollbar"].y	
		UILockToSprite(g_WindowsManager.current_ui, array_sprite["list_scrollbar"])
		g_WindowsManager.mouse_locked_by_ui = true
	}
	function	UnClickSliderButtonEvent(event, table)
	{
		cursor_down_on_scrollbar = 0
		UIUnlock(g_WindowsManager.current_ui)
		g_WindowsManager.mouse_locked_by_ui = false
	}
	function	CursorMoveSliderEvent(event, table)
	{
		if(cursor_down_on_scrollbar)
		{			
			// move the slider sprite		
			local mouse_pos = g_cursor.GetMousePos()
			mouse_pos.y -= cursor_down_on_scrollbar

			if((mouse_pos.y - (pos.y+total_height_header) )  < 0.0)
				percent_scrollbar = 0.0
			else
			if((mouse_pos.y - (pos.y+total_height_header)) > (total_height_child-total_height_header))
				percent_scrollbar = 1.0
			else
				percent_scrollbar = (mouse_pos.y - (pos.y+total_height_header))/(total_height_child-total_height_header)

			array_sprite_relative_pos["list_scrollbar"].y = total_height_header + (total_height_child-total_height_header- SpriteGetSize(array_sprite["list_scrollbar"]).y)*percent_scrollbar 

			start_id = (((child_array.len()+1)/max_sprite_H - (skip_scroll_line+max_sprite_V)) * percent_scrollbar).tointeger()
			if(start_id < 0)
				start_id = 0

			Show(true)
			SetPos(pos)
		}
	}
		
	////////////////////////////////////////////////////////////////////////
	
	function Show(_with_all_children = false)
	{
		base.Show(_with_all_children)

		foreach(id, child in child_array)
			if(!show_column_array[id%max_sprite_H] || (id >= skip_scroll_line*max_sprite_H && (id < (skip_scroll_line+start_id)*max_sprite_H || id >= (skip_scroll_line+max_sprite_V+start_id)*max_sprite_H)))
				child.Hide(true)

		if(child_array.len() <= (max_sprite_V+ skip_scroll_line)*max_sprite_H )
			SpriteSetOpacity(array_sprite["list_scrollbar"], 0.0)
		else
			SpriteSetOpacity(array_sprite["list_scrollbar"], 1.0)
	}	
	function Hide(_with_all_children = false)
	{
		base.Hide(_with_all_children)

		SpriteSetOpacity(array_sprite["list_scrollbar"], 0.0)
	}		
	////////////////////////////////////////////////////////////////////////
	
	function SetPos(_pos)
	{
		base.SetPos(_pos)
		
		// all child has space, put them at good distance
		local temp_pos = clone(pos)		
		local counter_child = 0.0		
		for(local row=0; counter_child < child_array.len(); ++row)
		{
			if(row < skip_scroll_line || (row >= skip_scroll_line+start_id && row < skip_scroll_line+max_sprite_V+start_id))
			{
				for(local column=0; column < max_sprite_H && counter_child < child_array.len(); ++column)
				{
					// check if the column is authorized
					if(show_column_array[column])
					{
						child_array[counter_child].SetPos(temp_pos)

						temp_pos.x += child_array[counter_child].width
					}	
					counter_child += 1.0
				}
				temp_pos.x = pos.x
				if(counter_child-1.0 >= 0 && counter_child < child_array.len())
					temp_pos.y += child_array[counter_child-1.0].height
			}
			else
				counter_child += max_sprite_H
		}
			
		if(child_array.len() > 0)
		{
			total_height_header = child_array[0].height * skip_scroll_line
			total_height_child = child_array[0].height * (skip_scroll_line+max_sprite_V)
			original_height = child_array[0].height * (child_array.len() /max_sprite_H)

			if(original_height > total_height_child)
				original_height = total_height_child
		}
		else
		{
			total_height_child = 0
			original_height = 0
		}

		if("little_shadow_sprite" in array_sprite)
		{			
			SpriteSetScale(array_sprite["little_shadow_sprite"], width.tofloat()/ SpriteGetSize(array_sprite["little_shadow_sprite"]).x, 1.0)
			array_sprite_relative_pos["little_shadow_sprite"].y = total_height_child
		}


		base.SetPos(_pos)
	}
	////////////////////////////////////////////////////////////////////////
	
	function SetSize(_width, _height, _child=0)
	{
		base.SetSize(_width, _height, _child)

		// check the biggest size by column
		local size_column = array(max_sprite_H, 0.0)
		for(local column=0; column < max_sprite_H; ++column)
		{
			// check if the column is authorized
			if(show_column_array[column])
				for(local child_id = column; child_id < child_array.len(); child_id += max_sprite_H)
				{
					if(size_column[column] < child_array[child_id].original_width)
						size_column[column] = child_array[child_id].original_width
				}
		}

		local width_total_child = 0.0
		foreach(size in size_column)
			width_total_child += size
			
		if(width_total_child > 0)
		{
			for(local column=0; column < max_sprite_H; ++column)
			{
				// check if the column is authorized
				if(show_column_array[column])
					for(local child_id = column; child_id < child_array.len(); child_id += max_sprite_H)
					{
							child_array[child_id].SetSize((size_column[column] * width.tofloat()) / width_total_child.tofloat(), child_array[0].height)
					}	
			}		
			array_sprite_relative_pos["list_scrollbar"].y = child_array[0].height * skip_scroll_line	
		}

		array_sprite_relative_pos["list_scrollbar"].x = width


		// all child has space, put them at good distance	
		SetPos(pos)
	}		
	
	////////////////////////////////////////////////////////////////////////
	
	function AppendChild(_child)
	{
		base.AppendChild(_child)
		
//		SetSize(width, height)
		
		if(parent)
			parent.SetSize(parent.width, parent.height, this)

		if(child_array.len() >= max_sprite_H * max_sprite_V )
		{
			_child.Hide(true)
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
		type = "GridSprite"		
		
		max_sprite_H = 5
		max_sprite_V = 5
		show_column_array = array(max_sprite_H, true)
		percent_scrollbar = 0.0
		start_id = 0
		skip_scroll_line = 0
	
		cursor_down_on_scrollbar = false
		total_height_header = 0
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

			array_sprite_relative_pos.rawset("list_scrollbar", Vector(width, (total_height_child-SpriteGetSize(array_sprite["list_scrollbar"]).y)*percent_scrollbar, 0.0))	

			array_sprite_blacklist_automatic_show.rawset("list_scrollbar", true)

			SpriteSetEventHandlerWithContext(array_sprite["list_scrollbar"], EventCursorDown, this, ClickSliderButtonEvent)		
			SpriteSetEventHandlerWithContext(array_sprite["list_scrollbar"], EventCursorUp, this, UnClickSliderButtonEvent)
			SpriteSetEventHandlerWithContext(array_sprite["list_scrollbar"], EventCursorMove, this, CursorMoveSliderEvent)		
		}

	}
}
