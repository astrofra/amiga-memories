/* -----------------------------------------------------------------------------
	GSFramework
	Copyright 2001-2012 Emmanuel Julien. All Rights Reserved.
----------------------------------------------------------------------------- */

/*#
	Topic: MinMax
	Type: MinMax
	Desc: Describe an axis-aligned bounding volume.
#*/
class	MinMax
{
	min			=	0
	max			=	0

/*#
	Section: MinMaxGeneral
	Desc: General
#*/
	/*#
		Func: Grow
		Proto: MinMax:MinMax minmax
		Desc: Return a new MinMax as the union of two volumes.
	#*/
	function        Grow(mm)
	{   return MinMax(min.Min(mm.min), max.Max(mm.max))		}

	/*#
		Func: Set
		Proto: void:Vector min,Vector max
	#*/
	function        Set(_min = Vector(), _max = Vector())
	{
		min = _min
		max = _max
	}

	constructor(_min = Vector(), _max = Vector())
	{   Set(_min, _max);    }
}
