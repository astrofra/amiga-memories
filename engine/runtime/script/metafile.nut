/* -----------------------------------------------------------------------------
	GSFramework
	Copyright 2001-2013 Emmanuel Julien. All Rights Reserved.
----------------------------------------------------------------------------- */

/*#
	Topic: Metafile
#*/

/*#
	Section: MetaFileSerialization
	Desc: Serialization functions
#*/

//-----------------------------------------------------------------------------
/*#
	Func: serializeArrayToMetatag
	Proto: void:array,Metatag
	Desc: Serialize a script array to a metatag.
#*/
function	serializeArrayToMetatag(object, tag)
{
	foreach (n, value in object)
		serializeObjectToMetatag(value, MetatagAddChild(tag, "#__array__"))
}
/*#
	Func: serializeTableToMetatag
	Proto: void:table,Metatag
	Desc: Serialize a script table to a metatag.
#*/
function	serializeTableToMetatag(object, tag)
{
	foreach (name, value in object)
		serializeObjectToMetatag(value, MetatagAddChild(tag, name))
}
/*#
	Func: serializeTableToMetatag
	Proto: void:object,Metatag
	Desc: Serialize a script object to a metatag.
	Note: This function can serialize all native script types except classes.
	Example:
// Create a new file and tag to serialize a script table.
local file = MetafileNew()
local tag = MetafileAddRoot(file, "my_table")

// Serialize table to tag.
serializeObjectToMetatag(some_table, tag)

// Save file.
MetafileSave(file, "@app/table.save")
#*/
function	serializeObjectToMetatag(value, tag)
{
	local t = typeof(value)

	switch (t)
	{
		case "instance":
			throw("Cannot serialize class instance")
			break

		case "array":
			serializeArrayToMetatag(value, tag)
			break

		case "table":
			serializeTableToMetatag(value, tag)
			break

		default:
			MetatagSetValue(tag, value)
			break
	}
}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
/*#
	Func: deserializeObjectFromMetatag
	Proto: object:Metatag
	Desc: Deserialize a metatag to a script object.
	Example:
// Load the table metafile.
local file = MetafileNew()
MetafileLoad(file, "@app/table.save")

// Get the table metatag.
local tag = MetafileGetTag(file, "my_table")

// Deserialize table from tag.
some_table = deserializeObjectToMetatag(class_tag)
#*/
function	deserializeObjectFromMetatag(tag)
{
	if	(MetatagGetType(tag) == TagTypeNone)
	{
		// Get the children tag list.
		local children = MetatagGetChildren(tag)

		// Assume an empty array, when no children are found.
		if	(children.len() == 0)
			return []

		// Check the first child name to detect a potential array (~hackish).
		if	(MetatagGetName(children[0]) == "#__array__")
		{
			local value = []
			foreach (child in children)
				value.append(deserializeObjectFromMetatag(child))
			return value
		}

		// Output children as table members.
		local value = {}
		foreach (child in children)
			value[MetatagGetName(child)] <- deserializeObjectFromMetatag(child)
		return value
	}
	return MetatagGetValue(tag)
}
//-----------------------------------------------------------------------------
