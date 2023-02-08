/* -----------------------------------------------------------------------------
	GSFramework
	Copyright 2001-2013 Emmanuel Julien. All Rights Reserved.
----------------------------------------------------------------------------- */

/*#
	Topic: Math
#*/
/*#
	Section: MathUnit
	Desc: Unit
#*/
/*#
	Func: Deg
	Proto: float:float v
	Desc: Returns a number of degrees.
	Example: local angle = Deg(20)	// 20 degrees
#*/
function	Deg(deg)
{	return deg * PI / 180.0;	}
/*#
	Func: Rad
	Proto: float:float v
	Desc: Returns a number of radians.
	Note: This is the unit the engine works with.
	Example: local angle = Rad(3.14)	// 3.14 radians
#*/
function	Rad(rad)
{	return rad;	}
/*#
	Func: DegreeToRadian
	Proto: float:float degrees
	Desc: Convert from degrees to radians.
	Example: local rad = DegreeToRadian(degrees)
#*/
function	DegreeToRadian(deg)
{	return Deg(deg);	}
/*#
	Func: RadianToDegree
	Proto: float:float radian
	Desc: Convert from radians to degrees.
#*/
function	RadianToDegree(rad)
{	return rad * 180.0 / PI;	}

/*#
	Func: Tn
	Proto: float:float v
	Desc: Returns a number of tons.
#*/
function	Tn(v)	{	return v * 1000.0;	}
/*#
	Func: Kg
	Proto: float:float v
	Desc: Returns a number of kilograms.
#*/
function	Kg(v)	{	return v;	}
/*#
	Func: Gr
	Proto: float:float v
	Desc: Returns a number of grams.
#*/
function	Gr(v)	{	return v * 0.001;	}

/*#
	Func: Km
	Proto: float:float v
	Desc: Returns a number of kilometers.
#*/
function	Km(v)	{	return v * 1000.0;	}
/*#
	Func: MtrToKm
	Proto: float:float v
	Desc: Convert frommeters to kilometers.
#*/
function	MtrToKm(v)	{	return v / 1000.0;	}
/*#
	Func: Mtr
	Proto: float:float v
	Desc: Returns a number of meters.
	Note: This is the unit the engine works with.
#*/
function	Mtr(v)	{	return v;	}
/*#
	Func: Km
	Proto: float:float v
	Desc: Returns a number of kilometers.
#*/
function	Cm(v)	{	return v * 0.01;	}
/*#
	Func: Km
	Proto: float:float v
	Desc: Returns a number of kilometers.
#*/
function	Mm(v)	{	return v * 0.001;	}

/*#
	Func: Sec
	Proto: float:float v
	Desc: Returns a number of seconds.
	Note: This is the unit the engine works with.
#*/
function	Sec(v)	{	return v;	}
/*#
	Func: SecToTick
	Proto: float:float v
	Desc: Convert seconds to ticks. The tick is the unit of the engine clock.
#*/
function	SecToTick(v)
{	return v * SystemClockFrequency;	}
/*#
	Func: TickToSec
	Proto: float:float v
	Desc: Convert ticks to seconds. The tick is the unit of the engine clock.
#*/
function	TickToSec(v)
{	return v / SystemClockFrequency;	}

/*#
	Func: Mtrs
	Proto: float:float v
	Desc: Returns a number of meters per second.
#*/
function	Mtrs(v)	{	return v;	}
/*#
	Func: Kmh
	Proto: float:float v
	Desc: Returns a number of kilometers per hour.
#*/
function	Kmh(v)	{	return v / 3.6;	}

/*#
	Func: KmhToMtrs
	Proto: float:float v
	Desc: Convert kilometers per hour to meters per second.
#*/
function	KmhToMtrs(v)
{	return v / 3.6;		}
/*#
	Func: MtrsToKmh
	Proto: float:float v
	Desc: Convert meters per second to kilometers per hour.
#*/
function	MtrsToKmh(v)
{	return v * 3.6;		}

function	HintKmh(v)
{	return v;	}

/*#
	Section: MathTools
	Desc: Tools
#*/
/*#
	Func: Clamp
	Proto: float:float v, float min, float max
	Desc: Clamp a value to specified range.
	Note: The range is inclusive [min;max].
	Example: local v = Clamp(105, 10, 64)	// will return 64 
#*/
function	Clamp(v, min, max)
{
	if	(v < min)
		return min;
	if	(v > max)
		return max;
	return v;
}
/*#
	Func: Loop
	Proto: float:float v, float min, float max
	Desc: Loop a value within a specified range.
	Note: The range is inclusive [min;max].
#*/
function	Loop(v, min, max)
{
	if	(max < min)
		return v;
	if	(min == max)
		return min;

	local dt = max - min + 1;

	while (v < min)
		v += dt;
	while (v > max)
		v -= dt;
	return v;
}
/*#
	Func: Wrap
	Proto: float:float v, float min, float max
	Desc: Wrap a value within a specified range.
	Note: This function is an alias for Loop.
	See: Loop
#*/
function	Wrap(v, min, max)
{	return Loop(v, min, max)	}

/*#
	Func: Min
	Proto: float:float a, float b
	Desc: Returns the smallest of two values.
	Example: local v = Min(6, 8)	// will return 6
#*/
function	Min(a, b)
{	return a < b ? a : b;	}
/*#
	Func: Max
	Proto: float:float a, float b
	Desc: Returns the largest of two values.
#*/
function	Max(a, b)
{	return a > b ? a : b;	}
/*#
	Func: Lerp
	Proto: float:float k, float a, float b
	Desc: Linearly interpolate between a and b.
	Note: k = 0 returns a, k = 1 returns b.
	Example: local avg = Lerp(0.5, 1.0, 3.0)	// will return 2.0
#*/
function	Lerp(k, a, b)
{	return (b - a) * k + a;		}
/*#
	Func: RangeAdjust
	Proto: float:float v, float old_range_start, float old_range_end, float new_range_start, new_range_end
	Desc: Map a value from a range to another.
	Example: local w = RangeAdjust(3, 0.0, 10.0, 0.0, 100.0)	// will return 30.0
#*/
function	RangeAdjust(k, a, b, u, v)
{	return (k - a) / (b - a) * (v - u) + u;	}
/*#
	Func: RangeAdjustClamped
	Proto: float:float v, float old_range_start, float old_range_end, float new_range_start, new_range_end
	Desc: Map a value from a range to another then clamp the resulting value to the new range.
#*/
function	RangeAdjustClamped(k, a, b, u, v)
{	return Clamp((k - a) / (b - a) * (v - u) + u, u, v);	}

/*#
	Func: Pow
	Proto: float:float value, float exponent
	Desc: Returns a value raised to the exponent.
#*/

/*#
	Func: SignedPow
	Proto: float:float value, float exponent
	Desc: Returns a value raised to the exponent and preserve the sign of the value.
#*/
function	SignedPow(v, e)
{
	local neg = v < 0 ? true : false;
	v = Pow(Abs(v), e);
	return neg ? -v : v;
}
/*#
	Func: RoundFloatValue
	Proto: float:float value, float precision = 100.0
	Desc: Round a float value.
#*/
function    RoundFloatValue(v, precision = 100.0)
{	return floor(v * precision) / precision;	}

/*#
	Func: Sign
	Proto: float:float value
	Desc: Returns the sign of a value. -1 if the value is negative, 1 otherwise.
#*/
function	Sign(v)
{	return v < 0.0 ? -1.0 : 1.0;	}
/*#
	Func: Normalize
	Proto: float:float value, float range_start, float range_end
	Desc: Normalize a value within a specified range.
	Example: local n = Normalize(6.0, 0.0, 10.0) // will return 0.6
#*/
function	Normalize(v, a, b)
{	return Clamp((v - a) / (b - a), 0.0, 1.0);	}

/*#
	Func: Mod
	Proto: float:float value, float divider
	Desc: Returns the remainder of the division between v and divider (the modulo).
	Example: local n = Mod(7.0, 3.0) // will return 1.0
#*/
function	Mod(v, m)
{	return v - floor(v / m) * m;	}
/*#
	Func: Abs
	Proto: float:float value
	Desc: Returns the absolute of a value.
#*/
function	Abs(v)
{	return v < 0.0 ? -v : v;	}

Euler_XYZ <- 0;
Euler_XZY <- 1;
Euler_YXZ <- 2;
Euler_YZX <- 3;
Euler_ZXY <- 4;
Euler_ZYX <- 5;
Euler_YX <- 6;
Euler_Default <- Euler_ZXY;
