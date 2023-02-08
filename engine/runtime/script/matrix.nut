/*
	nEngine	SQUIRREL binding API.
	Copyright 2005~2008 Emmanuel Julien.
*/


// Returns a rotation matrix around the X axis.
function	RotationMatrixX(a)
{
	return Matrix3(
						1.0, 0.0, 0.0,
						0.0, cos(a), sin(a),
						0.0, -sin(a), cos(a)
					);
}
// Returns a rotation matrix around the Y axis.
function	RotationMatrixY(a)
{
	return Matrix3(
						cos(a), 0.0, -sin(a),
						0.0, 1.0, 0.0,
						sin(a), 0.0, cos(a)
					);
}
// Returns a rotation matrix around the Z axis.
function	RotationMatrixZ(a)
{
	return Matrix3(
						cos(a), sin(a), 0.0,
						-sin(a), cos(a), 0.0,
						0.0, 0.0, 1.0
					);
}

// Scaling matrix.
function	ScaleMatrix(s)
{
	local	m = Matrix4();
	m.m00 = m.m11 = m.m22 = s;
	return m;
}

// Offset matrix.
function	OffsetMatrix(o)
{
	local	m = Matrix4();
	m.SetRow(3, o);
	return m;
}
