/*
	nEngine	SQUIRREL binding API.
	Copyright 2005~2008 Emmanuel Julien.
*/


function	VectorToRGBHex(v)
{	return ((v.x.tointeger() & 255) << 24) + ((v.y.tointeger() & 255) << 16) + ((v.z.tointeger() & 255) << 8) + (v.w.tointeger() & 255)	}

function	VectorFromRGBHex(rgb, argb = false)
{
	if  (argb)
		return Vector(rgb & 255, (rgb >> 24) & 255, (rgb >> 16) & 255, (rgb >> 8) & 255)
	return Vector((rgb >> 24) & 255, (rgb >> 16) & 255, (rgb >> 8) & 255, rgb & 255)
}

g_identity_vector	<-	Vector(1.0, 1.0, 1.0)
g_zero_vector		<-	Vector(0.0, 0.0, 0.0)
