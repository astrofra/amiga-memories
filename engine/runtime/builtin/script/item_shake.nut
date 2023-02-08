class	BuiltinItemShake
{
/*<
	<Script =
		<Name = "Shake Item">
		<Author = "Emmanuel Julien">
		<Description = "Shake an item position, rotation or scale.">
		<Category = "Transformation">
		<Compatibility = <Item>>
	>
	<Parameter =
		<amplitude = <Name = "Amplitude"> <Type = "Float"> <Default = 0.1>>
		<shake_pos = <Name = "Affect position."> <Type = "Bool"> <Default = True>>
		<shake_rot = <Name = "Affect rotation."> <Type = "Bool"> <Default = False>>
		<shake_scl = <Name = "Affect scale."> <Type = "Bool"> <Default = False>>
	>
>*/
	amplitude	=	0.1
	shake_pos	=	true
	shake_rot	=	false
	shake_scl	=	false

	function	OnUpdate(item)
	{
		local	shake = Vector().Randomize(amplitude)

		if	(shake_pos)
			ItemSetPosition(item, ItemGetPosition(item) + shake)
		if	(shake_rot)
			ItemSetRotation(item, ItemGetRotation(item) + shake)
		if	(shake_scl)
			ItemSetScale(item, ItemGetScale(item) + shake)
	}
}
