
Include ("scripts/interface/basic_sprite.nut")
/*!
	@short	ContainerSprite
	@author	Scorpheus
*/
class	ContainerSprite extends BasicSprite
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
	
	function SetPos(_pos)
	{		
		base.SetPos(_pos)	

		foreach(id_child, child in child_array)
		{
			child.SetPos(pos + array_pos_base_child[id_child])
		}
	}
	////////////////////////////////////////////////////////////////////////
	
	function AppendChild(_child)
	{
		_child.parent = this
		child_array.append(_child)		
		array_pos_base_child.append(_child.pos)		
	}
	function RemoveChild(_id)
	{		
		foreach(id_child, child in child_array)
			if(child.id == _id)
			{
				child_array.remove(id_child)
				array_pos_base_child.remove(id_child)
				break
			}				
	}
	
	////////////////////////////////////////////////////////////////////////
	
	function	constructor(_id = 0, _parent = 0)
	{	
		type = "ContainerSprite"		
		base.constructor(_id, _parent)	

		array_pos_base_child = []
	}
}
