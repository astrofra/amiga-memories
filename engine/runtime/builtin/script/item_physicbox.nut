class	BuiltinItemPhysicbox
{
/*<
	<Script =
		<Name = "Physic Box">
		<Author = "Francois Gutherz">
		<Description = "Automatically creates a  physic box adapted to the item.">
		<Category = "Physics">
	>
	<Parameter =
		<mass = <Name = "Mass (Kg)"> <Description = "Shape mass in Kg."> <Type = "Float"> <Default = 1.0>>
	>
>*/

	//--------------------------------------------------------------------------
	mass			=	1.0

	//--------------------------------------------------------------------------

	function	OnSetup(item)
	{
		ItemSetPhysicMode(item, PhysicModeDynamic)
		local	_shape	= ItemAddCollisionShape(item)
		local	_size	= Vector(0,0,0),
			_pos	= Vector(0,0,0),
			_scale	= Vector(0,0,0)

		local	_mm = ItemGetMinMax(item)
		
		_scale = ItemGetScale(item)
		
		if ((_scale.x != 1.0) ||  (_scale.x != 1.0) || (_scale.x != 1.0))
			print("BuiltinItemPhysicbox::OnSetup() : Warning, item '" + ItemGetName(item) + "' has a scale factor != 1.0. Physic result might be wrong.")

		_size.x = _mm.max.x -  _mm.min.x
		_size.y = _mm.max.y -  _mm.min.y
		_size.z = _mm.max.z -  _mm.min.z

		_pos = (_mm.max).Lerp(0.5, _mm.min)

		ShapeSetBox(_shape, _size)
		ShapeSetPosition(_shape, _pos)

		ShapeSetMass(_shape, mass)
		ItemWake(item)
	}
}
