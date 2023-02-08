class	BuiltinItemRotate
{
/*<
	<Script =
		<Name = "Rotate Item">
		<Author = "Emmanuel Julien">
		<Description = "Rotate an item.">
		<Category = "Transformation">
		<Compatibility = <Item>>
	>
	<Parameter =
		<speed = <Name = "Speed (°/s)"> <Type = "Float"> <Default = 0.1>>
		<rot_y = <Name = "Rotate on Y."> <Type = "Bool"> <Default = True>>
	>
>*/

	speed		=	0.1
	rot_y		=	true

	function	OnUpdate(item)
	{
		if	(rot_y)
				ItemSetRotation(item, ItemGetRotation(item) + Vector(0.0, (speed * 3.141592 / 180.0) * g_dt_frame, 0.0))
		else	ItemSetRotation(item, ItemGetRotation(item) + Vector(0.0, 0.0, (speed * 3.141592 / 180.0) * g_dt_frame))
	}
}
