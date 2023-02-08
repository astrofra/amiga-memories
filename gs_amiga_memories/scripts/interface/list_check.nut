
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	ListCheckSprite
	@author	Scorpheus
*/
class	ListCheckSprite extends BasicSprite
{		
	array_pos_base_child = 0
	
	////////////////////////////////////////////////////////////////////////
	
	function UpdateLostContent()
	{
		base.UpdateLostContent()
		
		foreach(sprite in array_sprite)
			UIDeleteSprite(g_WindowsManager.current_ui, sprite)
		array_sprite.clear()
		array_sprite_relative_pos.clear()
	}
	
	////////////////////////////////////////////////////////////////////////

	function ClickListCheckList(_sprite)
	{
		print("ClickListCheckList()")
		foreach(_child in child_array[0].child_array)
		{
			if (_child.type == "CheckSprite" && _child.id != _sprite.id)
				_child.RefreshValueText(false)
			else
				_child.RefreshValueText(true)
		}

		CallCallback(_sprite.text)
	}

	////////////////////////////////////////////////////////////////////////


	////////////////////////////////////////////////////////////////////////
	
	function SetPos(_pos)
	{		
		base.SetPos(_pos)	

		foreach(id_child, child in child_array)
		{
			child.SetPos(pos)
		}
	}

	////////////////////////////////////////////////////////////////////////
	
	function CallCallback(_value=0)
	{
		foreach(instance_callback in array_instance_function_callback)
		{
			if(instance_callback.func_name in instance_callback.instance)
			{
				instance_callback.instance[instance_callback.func_name](this, _value)
			}
		}
	}
	
	function SerializationLoad(serialization_table)
	{/*
		name_sprite = serialization_table["name_sprite"]
		base.SerializationLoad(serialization_table)
			*/
	}	
	function SerializationSave()
	{
		//local serialization_string = "name_sprite=\""+ name_sprite.tostring()+"\", "
		local serialization_string = base.SerializationSave()			
		
		return serialization_string
	}

	////////////////////////////////////////////////////////////////////////
	
	function	constructor(_id = 0, _parent = 0, _instance=0, _func="", _array_value = {}, _current_index = 0)
	{	
		type = "ListCheckSprite"		
		base.constructor(_id, _parent)	

		array_pos_base_child = []

		local	_list = g_WindowsManager.CreateListSizer(this, 400)
		_list.SetMaxSprite(10)

		foreach(_val in _array_value)
			g_WindowsManager.CreateCheckButton(_list, _val.value + _val.unit, _current_index==_val.value?true:false, this, "ClickListCheckList")

		if(_instance && typeof(_func) == "string" && _func.len() > 0)
			array_instance_function_callback.append({instance=_instance,func_name=_func})
	}
}
