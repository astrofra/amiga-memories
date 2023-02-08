/* -----------------------------------------------------------------------------
	GSFramework
	Copyright 2001-2013 Emmanuel Julien. All Rights Reserved.
----------------------------------------------------------------------------- */

/*#
	Topic: Rect
	Type: Rect
	Desc: Describes a 2D rectangle.
#*/
class Rect
{
	sx = 0.0; sy = 0.0; ex = 0.0; ey = 0.0;

/*#
	Section: RectGeneral
	Desc: General
#*/
	/*#
		Func: constructor
		Proto: Rect:float left,float top,float right,float bottom
	#*/
	constructor(...)
	{
		local vargc = vargv.len();
		assert((vargc == 0) || (vargc == 4));
		if	(vargc == 4)
		{	sx = vargv[0]; sy = vargv[1]; ex = vargv[2]; ey = vargv[3];	}
	}

	/*#
		Func: IsInside
		Proto: bool:Vector2 point
		Desc: Returns true if the point is inside the rectangle.
		Example:
// Test if a point is inside a given rectangle.
local r = Rect(20, 20, 120, 80).IsInside(Vector2(50, 50))

// r equals true
	#*/
	function	IsInside(p)
	{	return (p.x > sx) && (p.y > sy) && (p.x < ex) && (p.y < ey);	}

	/*#
		Func: Set
		Proto: void:float left,float top,float right,float bottom
		Desc: Initialize rectangle.
	#*/
	function	Set(u, v, s, t)	{	sx = u; sy = v; ex = s; ey = t;	}

	/*#
		Func: Print
		Proto: void:void
		Desc: Output the rectangle coordinates to the script log.
	#*/
	function	Print()
	{	::print("left = " + sx + ", top = " + sy + ", right = " + ex + ", bottom = " + ey + ".\n");	}

	/*#
		Func: GetLeft
		Proto: float:void
		Desc: Return the rectangle left coordinate.
	#*/
	function	GetLeft()
	{	return sx;	}
	/*#
		Func: GetTop
		Proto: float:void
		Desc: Return the rectangle top coordinate.
	#*/
	function	GetTop()
	{	return sy;	}
	/*#
		Func: GetRight
		Proto: float:void
		Desc: Return the rectangle right coordinate.
	#*/
	function	GetRight()
	{	return ex;	}
	/*#
		Func: GetBottom
		Proto: float:void
		Desc: Return the rectangle bottom coordinate.
	#*/
	function	GetBottom()
	{	return ey;	}

	/*#
		Func: GetWidth
		Proto: float:void
		Desc: Return the rectangle width.
	#*/
	function	GetWidth()
	{	return ex - sx;		}
	/*#
		Func: GetHeight
		Proto: float:void
		Desc: Return the rectangle height.
	#*/
	function	GetHeight()
	{	return ey - sy;		}

	/*#
		Func: GetSize
		Proto: Vector2:void
		Desc: Return the rectangle size.
	#*/
	function	GetSize()
	{	return Vector2(GetWidth(), GetHeight());	}

	/*#
		Func: Contract
		Proto: Rect:float size
		Desc: Return the rectangle reduced by a given amount.
		Note: Contracting a rectangle is equivalent to expanding it by the same negative amount.
		See: Expand
	#*/
	function	Contract(s)
	{	return Rect(sx + s, sy + s, ex - s, ey - s);	}
	/*#
		Func: Expand
		Proto: Rect:float size
		Desc: Return the rectangle expanded by a given amount.
		See: Contract
		Example:
// Expand a rectangle by 30 units.
local r = Rect(50, 60, 100, 120).Expand(30)
	#*/
	function	Expand(s)
	{	return Contract(-s);	}

	/*#
		Func: Offset
		Proto: Rect:float x,float y
		Desc: Return the rectangle offseted by a given delta.
	#*/
	function	Offset(x, y)
	{	return Rect(sx + x, sy + y, ex + x, ey + y);	}

	/*#
		Func: CenterIn
		Proto: Rect:Rect child_rect
		Desc: Return a rectangle centered in this rectangle.
	#*/
	function	CenterIn(r)
	{
		local _sx = ((r.ex - r.sx) - (ex - sx)) * 0.5 + r.sx,
			  _sy = ((r.ey - r.sy) - (ey - sy)) * 0.5 + r.sy;
		return Rect(_sx, _sy, _sx + (ex - sx), _sy + (ey - sy));
	}

	/*#
		Func: GetCenter
		Proto: Vector2:void
		Desc: Return the rectangle center as a point.
		Example:
// Get the center of a rectangle.
local c = Rect(50, 50, 70, 70).GetCenter()

// c equals Vector2(60, 60)
	#*/
	function	GetCenter()
	{	return Vector2((sx + ex) * 0.5, (sy + ey) * 0.5);		}
}
