class	BuiltinItemWanderer
{
/*<
	<Script =
		<Name = "Wanderer">
		<Author = "Emmanuel Julien">
		<Description = "Item wanders in a predefined radius around its original position.">
		<Category = "Transformation">
		<Compatibility = <Item>>
	>
	<Parameter =
		<radius = <Name = "Radius"> <Type = "Float"> <Default = 1.0>>
		<wander_on_y = <Name = "Wander on Y."> <Type = "Bool"> <Default = True>>
		<speed = <Name = "Speed (m/s)"> <Type = "Float"> <Default = 0.2>>
		<inertia = <Name = "Inertia"> <Type = "Float"> <Default = 0.99>>
		<fq = <Name = "Delay (s)"> <Description = "Delay before a new random target is selected."> <Type = "Float"> <Default = 1.0>>
	>
>*/
	//-------------------------------------------------------------------------------------
	radius			=	1.0
	wander_on_y		=	true
	speed			=	0.2
	fq				=	1.0
	inertia			=	0.99
	//-------------------------------------------------------------------------------------

	origin			=	Vector(0, 0, 0)
	v				=	Vector(0, 0, 0)
	target			=	Vector(0, 0, 0)
	target_delay	=	0.0

	function	OnUpdate(item)
	{
		target_delay -= g_dt_frame

		if	(target_delay <= 0.0)
		{
			local dt = Vector().Randomize(-radius, radius)
			if	(!wander_on_y)
				dt.y = 0
			target = origin + dt;
			target_delay += fq;
		}

		local	p = ItemGetPosition(item),
				w = (target - p).Normalize(speed)
		local	idt = Min(1.0 / g_dt_frame, 60.0)		// Keep the refresh rate in reasonable ranges.
		v += (w - v) * pow(inertia, idt)
		ItemSetPosition(item, p + v * g_dt_frame)
	}

	function	OnSetup(item)
	{
		origin = ItemGetPosition(item)
	}
}
