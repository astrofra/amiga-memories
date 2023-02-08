class	BuiltinItemTrail
{
/*<
	<Script =
		<Name = "Item trail">
		<Author = "Emmanuel Julien">
		<Description = "Display a trail aligned to an item X axis.">
		<Category = "Effect">
		<Compatibility = <Item>>
	>
	<Parameter =
		<max_points = <Name = "Trail length"> <Type = "Int"> <Default = 25>>
		<half_width = <Name = "Width (m)"> <Type = "Float"> <Default = 0.5>>
		<delay = <Name = "Sample Delay (s)"> <Type = "Float"> <Default = 0.025>>
	>
>*/
	point_list			=	0

	max_points			=	25
	half_width			=	0.5

	base_color			=	0

	record_clock		=	0
	delay				=	Sec(0.025)
	emitter_timeout		=	0.0

	identity_matrix		=	0

	//----------------------------------------------------------------------------
	function	AppendSection(t, sections, prev_p, p, x)
	{
		local v = (p - prev_p).Normalize()
		local w = half_width	// beam like

		// TODO add UV here
		sections.append({p = p - x * w})
		sections.append({p = p + x * w})
	}
	function	OnRenderUser(item)
	{
		local point_count = point_list.len()
		if	(point_count < 2)
			return

		// Setup trail quad sections.
		local m = ItemGetMatrix(item)

		local sections = []
		for (local n = 1; n < point_count; ++n)
			AppendSection(n.tofloat() / point_count, sections, point_list[n - 1].p, point_list[n].p, point_list[n].x)
		AppendSection(1.0, sections, point_list[point_count - 1].p, m.GetRow(3), m.GetRow(0))

		// Draw quads.
		local section_count = sections.len() / 2
		local step = 1.0 / (section_count - 2), alpha = 0.0

		RendererSetWorldMatrix(g_render, identity_matrix)

		for (local n = 0; n < (sections.len() - 2); n += 2)
		{
			local color_a = Vector(0.0, 0.7, 1, alpha)
			alpha = Min(1.0, alpha + step)
			local color_b = Vector(0.0, 0.7, 1, alpha)

			RendererDrawTriangle(g_render, sections[n].p, sections[n + 1].p, sections[n + 3].p, color_a, color_a, color_b, MaterialBlendAdd, MaterialRenderDoubleSided | MaterialRenderNoDepthWrite)
			RendererDrawTriangle(g_render, sections[n].p, sections[n + 3].p, sections[n + 2].p, color_a, color_b, color_b, MaterialBlendAdd, MaterialRenderDoubleSided | MaterialRenderNoDepthWrite)
		}
	}
	//----------------------------------------------------------------------------

	//----------------------------------------------------------------------------
	function	OnUpdate(item)
	{
		emitter_timeout = (g_clock - record_clock) / SecToTick(delay)
		if	(emitter_timeout <= 1.0)
			return

		record_clock = g_clock
		emitter_timeout = 0.0

		local m = ItemGetMatrix(item)
		point_list.append({p = m.GetRow(3) x = m.GetRow(0)})
		if	(point_list.len() > max_points)
			point_list.remove(0)
	}
	function	OnSetup(item)
	{
		point_list = []
		base_color = Vector(1, 1, 1)

		identity_matrix = Matrix4()

		record_clock = g_clock
	}
	//----------------------------------------------------------------------------
}
