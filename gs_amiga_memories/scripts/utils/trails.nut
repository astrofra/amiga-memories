/*
	File: scripts/utils/trails.nut
	Author: P. Blanche - F. Gutherz
*/

/*!
	@short	Trails
	@author	P. Blanche - F. Gutherz
*/
class	Trails
{

	item					=	0
	point_list				=	0
	max_points				=	50
	base_color				=	0
	record_clock			=	0

	half_width				=	0.6

	emitter_exponent		=	12.0

	emitter_timeout			=	0.0

	constructor(_item, _color = Vector(1,1,1,1))
	{
		item = _item
		point_list = []
		base_color = _color
		record_clock = g_clock
		half_width = ItemGetScale(item).x * 0.5
	}

	function	RecordPoint()
	{
		emitter_timeout = (g_clock - record_clock) / SecToTick(Sec(0.05))
		if	(emitter_timeout <= 1.0)
			return

		record_clock = g_clock
		emitter_timeout = 0.0

		point_list.append({ p = ItemGetWorldPosition(item) y = ItemGetRotationMatrix(item).GetRow(1) })
		if	(point_list.len() > max_points)
			point_list.remove(0)
	}

	function	AppendSection(t, sections, prev_p, p, y)
	{
		local v = (p - prev_p).Normalize()
//		local u = v.Cross(y).Normalize(half_width + sin(t * 4.0) * 0.29)	// smoke like, pretty cool
		local u = v.Cross(y).Normalize(half_width)	// beam like

		// TODO add UV here
		sections.append({p = p - u})
		sections.append({p = p + u})
	}

	function	RenderTrail(trail)
	{
		local point_count = trail.len()

		// Setup trail quad sections.
		local sections = []
		for (local n = 1; n < point_count; ++n)
			AppendSection(n.tofloat() / point_count, sections, trail[n - 1].p, trail[n].p, trail[n].y)
		AppendSection(1.0, sections, trail[point_count - 1].p, ItemGetWorldPosition(item), ItemGetRotationMatrix(item).GetRow(1))

		// Draw quads.
		local section_count = sections.len() / 2
		local alpha = 1.0, step = 1.0 / section_count

		for (local n = 0; n < (sections.len() - 2); n += 2)
		{
			local color_a = Vector(0.0, 0.7, 1, 1.0 - alpha)
			alpha = Max(0.0, alpha - step)
			local color_b = Vector(0.0, 0.7, 1, 1.0 - alpha)

			RendererDrawTriangle(g_render, sections[n].p, sections[n + 1].p, sections[n + 3].p, color_a, color_a, color_b, MaterialBlendAdd, MaterialRenderDoubleSided | MaterialRenderNoDepthWrite)
			RendererDrawTriangle(g_render, sections[n].p, sections[n + 3].p, sections[n + 2].p, color_a, color_b, color_b, MaterialBlendAdd, MaterialRenderDoubleSided | MaterialRenderNoDepthWrite)
		}
	}

	function	AdjustTrail(exponent)
	{
		local adjusted_trail = []

		local c_p = ItemGetWorldPosition(item),
			  c_z = ItemGetRotationMatrix(item).GetRow(2).Normalize()

		local step = 1.0 / point_list.len()
		local t = (1.0 - emitter_timeout) * step

		foreach(point in point_list)
		{
			local original_p = point.p
			local distance_to_emitter = original_p.Dist(c_p)
			local straigth_p = c_p - c_z * distance_to_emitter

			local k = Pow(t, exponent)
			t += step

			local new_p = straigth_p * k + original_p * (1.0 - k)

			adjusted_trail.append({p = new_p y = point.y})
		}

		return adjusted_trail
	}

	function	RenderUser(scene)
	{
		if	(point_list.len() < 2)
			return

		if	(emitter_exponent > 0.0)
			RenderTrail(AdjustTrail(emitter_exponent))
		else
			RenderTrail(point_list)
	}
}
