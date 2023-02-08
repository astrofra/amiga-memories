/* -----------------------------------------------------------------------------
	GSFramework
	Copyright 2001-2013 Emmanuel Julien. All Rights Reserved.
----------------------------------------------------------------------------- */

/*#
	Topic: Vector2
	Type: Vector2
	Desc: A 2D vector.
#*/
class 	Vector2
{
/*#
	Section: Vec2General
	Desc: General
#*/
	/*#
		Func: constructor
		Proto: Rect:float x = 0.0,float y = 0.0
	#*/
	constructor(_x = 0.0, _y = 0.0)
	{   x = _x; y = _y	}

	/*#
		Func: Set
		Proto: void:float x, float y
		Desc: Initialize the vector.
	#*/
	function	Set(u, v)	{	x = u; y = v	}

	/*#
		Func: Scale
		Proto: void:float k
		Desc: Scale the vector by a given factor.
	#*/
	function	Scale(k)		{	return Vector2(x * k, y * k);		}

	/*#
		Func: Len2
		Proto: float:
		Desc: Returns the vector squared length.
	#*/
	function	Len2()			{	return x * x + y * y;	}
	/*#
		Func: Len
		Proto: float:
		Desc: Returns the vector length.
	#*/
	function	Len()			{	local l = Len2(); return l ? sqrt(l) : 0.0;	}

	/*#
		Func: Dist
		Proto: float:Vector2 b
		Desc: Return the length of the vector formed by substracting this vector to another vector b.
	#*/
	function    Dist(b)         {	return (b - this).Len();	}

	/*#
		Func: Max
		Proto: Vector2:Vector2 b
		Desc: Return the vector formed by performing a Max operation on each components of this vector and another vector b.
	#*/
	function	Max(b)			{	return Vector2(x > b.x ? x : b.x, y > b.y ? y : b.y);	}
	/*#
		Func: Min
		Proto: Vector2:Vector2 b
		Desc: Return the vector formed by performing a Min operation on each components of this vector and another vector b.
	#*/
	function	Min(b)			{	return Vector2(x < b.x ? x : b.x, y < b.y ? y : b.y);	}
	/*#
		Func: Abs
		Proto: Vector2:
		Desc: Return the vector formed by performing an Abs operation on each of its components.
	#*/
	function	Abs()			{	return Vector2(x < 0 ? -x : x, y < 0 ? -y : y);	}

	/*#
		Func: Abs
		Proto: Vector2:float min, float max
		Desc: Return the vector formed by performing a Clamp operation on each of its components.
	#*/
	function	Clamp(min, max)
	{	return Vector2(::Clamp(x, min, max), ::Clamp(y, min, max));	}
	/*#
		Func: Abs
		Proto: Vector2:Vector2 min, Vector2 max
		Desc: Return the vector formed by performing a Clamp operation on each of its components using the components of two min and max vectors as the range.
	#*/
	function	Clamp2d(vmin, vmax)
	{	return Vector2(::Clamp(x, vmin.x, vmax.x), ::Clamp(y, vmin.y, vmax.y));	}
	/*#
		Func: ClampMagnitude
		Proto: Vector2:float max_magnitude
		Desc: Return a vector of the same direction as this vector but clamp its magnitude to a maximum value.
	#*/
	function	ClampMagnitude(mag)
	{
		local 	l = Len2();
		if	(l < (mag * mag))
			return this;
		if	(l < 0.000001)
			return this;
		l = sqrt(l);
		return this.MulReal(mag / l);
	}

	/*#
		Func: Randomize
		Proto: Vector2:float min, float max
		Desc: Return a vector with random components in the range [min;max].
	#*/
	function	Randomize(a, b)
	{	return Vector2(Rand(a, b), Rand(a, b));	}

	/*#
		Func: Lerp
		Proto: Vector2:Vector2 b
		Desc: Linearly interpolate between this vector and another vector b.
	#*/
	function	Lerp(k, b)
	{
		local ik = 1.0 - k;
		return Vector2(x * k + b.x * ik, y * k + b.y * ik);
	}

	/*#
		Func: Normalize
		Proto: Vector2:float norm = 1.0
		Desc: Return a normalized version of this vector.
	#*/
	function	Normalize(length = 1.0)
	{
		local k = Len();
		if	(k < 0.000001)
				k = 0.0;
		else	k = length / k;
		return Vector2(x * k, y * k);
	}

	/*#
		Func: ApplyMatrix
		Proto: Vector2:Matrix3 matrix
		Desc: Transform this vector by a 3x3 matrix.
	#*/
	function	ApplyMatrix(m)
	{
		return Vector2	(
							x * m.m00 + y * m.m01 + m.m02,
							x * m.m10 + y * m.m11 + m.m12
						);
	}
	/*#
		Func: ApplyRotationMatrix
		Proto: Vector2:Matrix3 matrix
		Desc: Transform this vector by a 3x3 matrix, only apply rotation.
	#*/
	function	ApplyRotationMatrix(m)
	{
		return Vector2	(
							x * m.m00 + y * m.m01,
							x * m.m10 + y * m.m11	
						);
	}

	/*#
		Func: Reverse
		Proto: Vector2:
		Desc: Returns the opposite vector to this vector.
	#*/
	function	Reverse()		{	return Vector2(-x, -y);	}

	function	_add(v)
	{
		switch (typeof(v))
		{
			case "integer":
			case "float":
				return Vector2(x + v, y + v);
		}
		return Vector2(x + v.x, y + v.y);
	}
	function	_sub(v)
	{
		switch (typeof(v))
		{
			case "integer":
			case "float":
				return Vector2(x - v, y - v);
		}
		return Vector2(x - v.x, y - v.y);
	}
	function	_mul(v)
	{
		switch (typeof(v))
		{
			case "integer":
			case "float":
				return Vector2(x * v, y * v);
		}
		return Vector2(x * v.x, y * v.y);
	}
	function	_div(v)
	{
		switch (typeof(v))
		{
			case "integer":
			case "float":
				return Vector2(x / v, y / v);
		}
		return Vector2(x / v.x, y / v.y);
	}
	function	_unm(v)
	{	return Vector2(-x, -y);	}

	/*#
		Func: Print
		Proto: void:String name = "Vec2"
		Desc: Print this vector to the script log.
	#*/
	function	Print(name = "Vec2")
	{	::print(name + ": X = " + x + ", Y = " + y + ".\n");	}

	x = 0.0; y = 0.0;
}
