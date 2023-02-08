class	ManualDrawBuffer
{
	lines		=	0
	triangles	=	0

	function	DrawLine(start, end, color = Vector(1, 1, 1))
	{
		lines.append({ a = start b = end color = color })
	}
	function	DrawTriangle(a, b, c, color = Vector(1, 1, 1), blendop = MaterialBlendNone, renderw = MaterialRenderDoubleSided)
	{
		triangles.append({ a = a b = b c = c color = color blendop = blendop renderw = renderw })
	}

	function	Render()
	{
		RendererSetWorldMatrix(g_render, Matrix4())

		foreach (l in lines)
			RendererDrawLineColored(g_render, l.a, l.b, l.color)
		foreach (t in triangles)
			RendererDrawTriangle(g_render, t.a, t.b, t.c, t.color, t.color, t.color, t.blendop, t.renderw)

		Reset()
	}
	function	Reset()
	{
		lines = []
		triangles = []
	}

	constructor()
	{
		Reset()
	}
}