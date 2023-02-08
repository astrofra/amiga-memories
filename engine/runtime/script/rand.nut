/* -----------------------------------------------------------------------------
	GSFramework
	Copyright 2001-2013 Emmanuel Julien. All Rights Reserved.
----------------------------------------------------------------------------- */

/*#
	Topic: Random
#*/
/*#
	Section: RandGeneral
	Desc: General
#*/
/*#
	Func: Rand
	Proto: float:float min, float max
	Desc: Return a random number in the [min;max] range.
	Example: local v = Rand(5, 8)
#*/
function    Rand(min, max)
{	return SystemRand(RAND_MAX).tofloat() / RAND_MAX * (max - min) + min;		}
/*#
	Func: Irand
	Proto: int:int min, int max
	Desc: Return a random integer in the [min;max] range.
#*/
function	Irand(min, max)
{	return (SystemRand(RAND_MAX) % (max - min)) + min;	}
