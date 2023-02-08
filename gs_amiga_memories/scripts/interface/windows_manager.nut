
Include ("scripts/utils/ui_define.nut")
Include ("scripts/interface/slider_sprite.nut")
Include ("scripts/interface/vertical_sizer_sprite.nut")
Include ("scripts/interface/horizontal_sizer_sprite.nut")
Include ("scripts/interface/click_sprite.nut")
Include ("scripts/interface/prev_next_sprite.nut")
Include ("scripts/interface/bitmap_sprite.nut")
Include ("scripts/interface/canvas_sprite.nut")
Include ("scripts/interface/check_sprite.nut")
Include ("scripts/interface/list_sprite.nut")
Include ("scripts/interface/grid_sprite.nut")
Include ("scripts/interface/animated_sprite.nut")
Include ("scripts/interface/container_sprite.nut")
Include ("scripts/interface/list_check.nut")

/*!
	@short	WindowsManager
	@author	Scorpheus
*/
class	WindowsManager
{	
	array_main_sprite = 0		
	array_all_sprite = 0	
	
	current_ui = 0
	
	mouse_locked_by_ui = false

	folded_icon_horizontal_sizer = 0
		
	function CallCallback(_id, _value=0)
	{
		foreach(sprite in array_all_sprite)
		{
			if(sprite.id == _id)
			{
				sprite.CallCallback(_value)
				break
			}
		}
	}
			
	////////////////////////////////////////////////////////////////////////
	
	function PushInFront(_sprite)
	{		
		//get the lower zorder
		local lower_z_order = 1000000.0
		foreach(sprite in array_main_sprite)
			if(_sprite != sprite && sprite.z_order < lower_z_order)
				lower_z_order = sprite.z_order

		_sprite.SetZOrder(lower_z_order - 2, true)
	}	
			
	////////////////////////////////////////////////////////////////////////
	
	function AppendCallbackForAllClickSprite(_instance, _func)
	{
		foreach(sprite in array_all_sprite)
		{
			if(sprite.type == "ClickSprite")
				sprite.array_instance_function_callback.append({instance=_instance,func_name=_func})
		}
	}
	function AppendCallbackForAllSliderSprite(_instance, _func)
	{
		foreach(sprite in array_all_sprite)
		{
			if(sprite.type == "SliderSprite")
				sprite.array_instance_function_callback.append({instance=_instance,func_name=_func})
		}
	}
	
	////////////////////////////////////////////////////////////////////////

	//------------------------------------
	function CreateCheckButton(_parent = 0, _text = "", _checked=true, _instance=0, _func="", _custom_picture_activate_check="", _custom_picture_deactivate_check="")
	{
		local new_check_widget = CheckSprite(array_all_sprite.len(), _parent, _instance, _func, _text, _checked, _custom_picture_activate_check, _custom_picture_deactivate_check)
		new_check_widget.SetSize(new_check_widget.width, new_check_widget.height)		
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_check_widget)				
			new_check_widget.SetPos(Vector(0,0,0))			
		}
		else
		{
			_parent.AppendChild(new_check_widget)
		}
		
		array_all_sprite.append(new_check_widget)
		
		return new_check_widget
	}	
	//------------------------------------
	function CreateCanvasButton(_parent = 0, _width = 1, _height = 1, _instance=0, _func="")
	{
		local new_canvas_widget = CanvasSprite(array_all_sprite.len(), _parent, _instance, _func)
		new_canvas_widget.SetSize(_width, _height)		
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_canvas_widget)				
			new_canvas_widget.SetPos(Vector(0,0,0))			
		}
		else
		{
			_parent.AppendChild(new_canvas_widget)
		}
		
		array_all_sprite.append(new_canvas_widget)
		
		return new_canvas_widget
	}	
	//------------------------------------
	function CreateAnimatedSpriteButton(_parent = 0, _bimap_path = "", _total_duration=1.0, _instance=0, _func="")
	{
		local new_animated_bitmap_widget = AnimatedSprite(array_all_sprite.len(), _parent, _instance, _func, _bimap_path, _total_duration)
		new_animated_bitmap_widget.SetSize(new_animated_bitmap_widget.width, new_animated_bitmap_widget.height)		
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_animated_bitmap_widget)				
			new_animated_bitmap_widget.SetPos(Vector(0,0,0))			
		}
		else
		{
			_parent.AppendChild(new_animated_bitmap_widget)
		}
		
		array_all_sprite.append(new_animated_bitmap_widget)
		
		return new_animated_bitmap_widget
	}	
	//------------------------------------
	function CreateBitmapButton(_parent = 0, _bimap_path = "", _instance=0, _func="", max_width=-1, max_height=-1)
	{
		local new_bitmap_widget = BitmapSprite(array_all_sprite.len(), _parent, _instance, _func, _bimap_path)

		if(max_width != -1 && max_height != -1)
			new_bitmap_widget.SetSize(new_bitmap_widget.width > max_width?max_width:new_bitmap_widget.width, new_bitmap_widget.height > max_height?max_height:new_bitmap_widget.height)		
		else
			new_bitmap_widget.SetSize(new_bitmap_widget.width, new_bitmap_widget.height)		
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_bitmap_widget)				
			new_bitmap_widget.SetPos(Vector(0,0,0))			
		}
		else
		{
			_parent.AppendChild(new_bitmap_widget)
		}
		
		array_all_sprite.append(new_bitmap_widget)
		
		return new_bitmap_widget
	}	
	//------------------------------------
	function CreatePrevNextButtonMinMax(_parent = 0, _text = "", _unit="", _min=0, _max=1, _step=0.1, _default=0, _instance=0, _func="")
	{ 
		local array_value = []
		local current_index = 0
		for(local i=_min; i<=_max; i+=_step)
		{
			local value =  (i * (1.0/_step)).tointeger() * _step
			if(Abs(value - _default) < _step*0.5)
				current_index = array_value.len()
			array_value.append(value)
		}
		return CreatePrevNextButton(_parent, _text, _unit, array_value, current_index, _instance, _func)
	}
	//------------------------------------
	function CreatePrevNextButton(_parent = 0, _text = "", _unit="", _array_value = [], _current_index = 0, _instance=0, _func="")
	{
		local new_prev_next_widget = PrevNextSprite(array_all_sprite.len(), _parent, _instance, _func, _text, _unit, _array_value, _current_index)
		new_prev_next_widget.SetSize(new_prev_next_widget.width, new_prev_next_widget.height)		
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_prev_next_widget)				
			new_prev_next_widget.SetPos(Vector(0,0,0))			
		}
		else
		{
			_parent.AppendChild(new_prev_next_widget)
		}
		
		array_all_sprite.append(new_prev_next_widget)
		
		return new_prev_next_widget
	}	
	//------------------------------------
	function CreateSliderButton(_parent = 0, _text="", _min_value=0.0, _max_value=100.0, _step=1.0, _default_value=0.0, _instance=0, _func="")
	{
		local new_slider_widget = SliderSprite(array_all_sprite.len(), _parent, _instance, _func, _text, _min_value, _max_value, _step, _default_value)
		new_slider_widget.SetSize(new_slider_widget.width, new_slider_widget.height)		
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_slider_widget)				
			new_slider_widget.SetPos(Vector(0,0,0))			
		}
		else
		{
			_parent.AppendChild(new_slider_widget)
		}
		
		array_all_sprite.append(new_slider_widget)
		
		return new_slider_widget
	}	
	//------------------------------------
	function CreateClickButton(_parent = 0, _text = "", _unit= "", _instance=0, _func="")
	{
		local new_click_widget = ClickSprite(array_all_sprite.len(), _parent, _instance, _func, _text, _unit)
		new_click_widget.SetSize(new_click_widget.width, new_click_widget.height)		
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_click_widget)				
			new_click_widget.SetPos(Vector(0,0,0))			
		}
		else
		{
			_parent.AppendChild(new_click_widget)
		}
		
		array_all_sprite.append(new_click_widget)
		
		return new_click_widget
	}	
	//------------------------------------
	function CreateContainer(_parent = 0)
	{		
		local new_container_widget = ContainerSprite(array_all_sprite.len(), _parent)	
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_container_widget)				
			new_container_widget.SetPos(Vector(0,0,0))			
		}
		else
		{
			_parent.AppendChild(new_container_widget)
		}
		
		array_all_sprite.append(new_container_widget)
		
		return new_container_widget
	}
	//------------------------------------
	function CreateListCheck(_parent = 0, _instance=0, _func="", _array_value = {}, _current_index = 0)
	{		
		local new_listcheck_widget = ListCheckSprite(array_all_sprite.len(), _parent, _instance, _func, _array_value, _current_index)
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_listcheck_widget)				
			new_listcheck_widget.SetPos(Vector(0,0,0))			
		}
		else
		{
			_parent.AppendChild(new_listcheck_widget)
		}
		
		array_all_sprite.append(new_listcheck_widget)
		
		return new_listcheck_widget
	}	
	//------------------------------------
	function CreateHorizontalSizer(_parent = 0, _width = 0)
	{		
		local new_horizontal_widget = HorizontalSizerSprite(array_all_sprite.len(), _parent)			
		new_horizontal_widget.SetSize(_width, 0)	
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_horizontal_widget)				
			new_horizontal_widget.SetPos(Vector(0,0,0))			
		}
		else
		{
			_parent.AppendChild(new_horizontal_widget)
		}
		
		array_all_sprite.append(new_horizontal_widget)
		
		return new_horizontal_widget
	}	
	//------------------------------------
	function CreateVerticalSizer(_parent = 0, _height = 0)
	{		
		local new_vertical_widget = VerticalSizerSprite(array_all_sprite.len(), _parent)
		new_vertical_widget.SetSize(0, _height)		
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_vertical_widget)				
			new_vertical_widget.SetPos(Vector(0,0,0))		
		}
		else
		{
			_parent.AppendChild(new_vertical_widget)
		}
		
		array_all_sprite.append(new_vertical_widget)
		
		return new_vertical_widget
	}	
	//------------------------------------
	function CreateListSizer(_parent = 0, _height = 0)
	{		
		local new_list_widget = ListSprite(array_all_sprite.len(), _parent)
		new_list_widget.SetSize(0, _height)		
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_list_widget)				
			new_list_widget.SetPos(Vector(0,0,0))		
		}
		else
		{
			_parent.AppendChild(new_list_widget)
		}
		
		array_all_sprite.append(new_list_widget)
		
		return new_list_widget
	}	
	//------------------------------------
	function CreateGridSizer(_parent = 0, _width = 0, _height = 0)
	{		
		local new_grid_widget = GridSprite(array_all_sprite.len(), _parent)
		new_grid_widget.SetSize(_width, _height)		
			
		if(_parent == 0)
		{
			array_main_sprite.append(new_grid_widget)				
			new_grid_widget.SetPos(Vector(0,0,0))		
		}
		else
		{
			_parent.AppendChild(new_grid_widget)
		}
		
		array_all_sprite.append(new_grid_widget)
		
		return new_grid_widget
	}	
	
	////////////////////////////////////////////////////////////////////////
		
	function SerializationLoad(serialization_string)
	{
		local ArrayStringFunc = compilestring("{return "+serialization_string+"}")
		local _Array = ArrayStringFunc(ArrayStringFunc)
		
		foreach(sprite_array in _Array)
		{			
			local type_sprite = sprite_array["type"]
			
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
			else			
			if(type_sprite == "ContainerSprite"	)
				sprite = ContainerSprite()
			else			
			if(type_sprite == "ListCheckSprite"	)
				sprite = ListCheckSprite()
				
			sprite.SerializationLoad(sprite_array)			
				
			array_main_sprite.append(sprite)	
			array_all_sprite.append(sprite)					
		}
	}
	function SerializationSave()
	{
		local serialization_string = "["
		
		foreach(id, sprite in array_main_sprite)
		{
			serialization_string += "{"
			
			serialization_string += sprite.SerializationSave()	
			
			serialization_string += "}"	
			if(id != array_main_sprite.len()-1)			
				serialization_string += ","				
		}
		
		serialization_string += "]"
		return serialization_string
	}	
	
	function SerializationSave(sprite)
	{
		local serialization_string = "["
		
			serialization_string += "{"
			
			serialization_string += sprite.SerializationSave()	
			
			serialization_string += "}"		
		
		serialization_string += "]"
		return serialization_string
	}	
			
	////////////////////////////////////////////////////////////////////////
	
	function SavePosAuthorizeWidget(_widget_pos_tag)
	{		
		foreach(id, child in array_main_sprite)
			if(child.authorize_save)
			{				
				local	widget_tag = MetatagGetTag(_widget_pos_tag, child.signature_key)
				if	(!MetatagIsValid(widget_tag))
					widget_tag = MetatagAddChild(_widget_pos_tag, child.signature_key)			

				//add the pos			
				{								
					// Grab X, Y tag.
						local	widget_pos = MetatagGetTag(widget_tag, "X")
						if	(!MetatagIsValid(widget_pos))
							widget_pos = MetatagAddChild(widget_tag, "X")
						MetatagSetValue(widget_pos, child.pos.x)

						local	widget_pos = MetatagGetTag(widget_tag, "Y")
						if	(!MetatagIsValid(widget_pos))
							widget_pos = MetatagAddChild(widget_tag, "Y")
						MetatagSetValue(widget_pos, child.pos.y)

						local	widget_pos = MetatagGetTag(widget_tag, "Z")
						if	(!MetatagIsValid(widget_pos))
							widget_pos = MetatagAddChild(widget_tag, "Z")
						MetatagSetValue(widget_pos, child.pos.z)
				}			
			}			
	}
	function LoadPosAuthorizeWidget(widget)
	{		
		if(widget.authorize_save)
		{
//			print("load widget exercices setting")
			local	metafile = MetafileNew()

			// Load param exercice.
			if	(TryLoadMetafile(metafile,  "metafile_save/param_exercice.nml"))
			{
				// Grab exercice config tag.
				local	param_exercice_tag = MetafileGetTag(metafile, "param_exercice")
				if	(MetatagIsValid(param_exercice_tag))
				{
					// Grab exercice tag.
					local	exercice_tag = MetatagGetTag(param_exercice_tag, g_SituationManager.project_script.scene_key)
					if	(MetatagIsValid(exercice_tag))
					{
						local	widget_pos_tag = MetatagGetTag(exercice_tag, "widget_pos_tag")
						if(MetatagIsValid(widget_pos_tag))
						{
							local	widget_tag = MetatagGetTag(widget_pos_tag, widget.signature_key)
							if	(MetatagIsValid(widget_tag))
							{
							// Grab X, Y tag.		
									local temp_pos = Vector(0.0,0.0,0.0)	
									temp_pos.x = MetatagGetValue(MetatagGetTag(widget_tag, "X")).tofloat()
									temp_pos.y = MetatagGetValue(MetatagGetTag(widget_tag, "Y")).tofloat()
									temp_pos.z = MetatagGetValue(MetatagGetTag(widget_tag, "Z")).tofloat()	

								// check pos is not out of the screen
								if(temp_pos.x > g_cursor.GetXScreenSpace(0) && temp_pos.x < g_cursor.GetXScreenSpace(0.9))
									widget.SetPos(temp_pos)
							}
						}
					}
				}
			}

			MetafileDelete(metafile)
		}
	}

	////////////////////////////////////////////////////////////////////////
	
	function UpdateLostContent()
	{
		foreach(child in array_main_sprite)
			child.UpdateLostContent()				
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function Update(_with_all_children = false)
	{
		// update
		foreach(id, child in array_main_sprite)
			child.Update(_with_all_children)	
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function KillWidget(_widget)
	{
		if(!_widget)
			return
		
		// remove the widget from the main list
		foreach(id, child in array_main_sprite)
			if(_widget == child)
				array_main_sprite.remove(id)	

		foreach(id, child in array_all_sprite)
			if(_widget == child)
				array_all_sprite.remove(id)	

		foreach(child in _widget.child_array)
			KillWidget(child)

		_widget.Kill(true)
	}
	function Kill(_with_child)
	{
		foreach(child in array_main_sprite)
			child.Kill(_with_child)		
		array_main_sprite.clear()
		array_all_sprite.clear()

		folded_icon_horizontal_sizer = 0
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function	Setup()
	{
	}

	constructor()
	{
		array_main_sprite = []
		array_all_sprite = []
	}
}
