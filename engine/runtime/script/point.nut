/* -----------------------------------------------------------------------------
	GSFramework
	Copyright 2001-2013 Emmanuel Julien. All Rights Reserved.
----------------------------------------------------------------------------- */

/*#
	Topic: Point
	Type: Point
	Desc: Describes a 2D point.
#*/
class Point
{
/*#
	Section: PointGeneral
	Desc: General
#*/
	/*#
		Func: constructor
		Proto: Point:float x,float y
	#*/
	constructor(...)
	{
		assert((vargc == 0) || (vargc == 2));
		if	(vargc == 2)
		{	x = vargv[0]; y = vargv[1];		}
	}
	x = 0.0; y = 0.0;
}
