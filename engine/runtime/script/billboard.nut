/*
	GameStart SQUIRREL binding API.
	Copyright 2010 Emmanuel Julien.
*/

MaterialBlendNone <- 0

function	DrawBillboardQuad(matrix, center, size, color = Vector(1, 1, 1), blend = MaterialBlendNone, flag = MaterialRenderDefault)
{
	local	v0 = center + (matrix.GetLeft() + matrix.GetUp()) * size,
			v1 = center + (matrix.GetRight() + matrix.GetUp()) * size,
			v2 = center + (matrix.GetRight() + matrix.GetDown()) * size,
			v3 = center + (matrix.GetLeft() + matrix.GetDown()) * size

	RendererDrawTriangle(g_render, v0, v1, v2, color, color, color, flag)
	RendererDrawTriangle(g_render, v0, v2, v3, color, color, color, flag)
}

function	DrawBillboardQuadTextured(matrix, center, size, texture, uvmin = UV(0, 0), uvmax = UV(1, 1), color = Vector(1, 1, 1), blend = MaterialBlendNone, flag = MaterialRenderDefault)
{
	local	v0 = center + (matrix.GetLeft() + matrix.GetUp()) * size,
			v1 = center + (matrix.GetRight() + matrix.GetUp()) * size,
			v2 = center + (matrix.GetRight() + matrix.GetDown()) * size,
			v3 = center + (matrix.GetLeft() + matrix.GetDown()) * size

	local	uv0 = uvmin,
			uv1 = UV(uvmax.u, uvmin.v),
			uv2 = uvmax,
			uv3 = UV(uvmin.u, uvmax.v)

	RendererDrawTriangleTextured(g_render, v0, v1, v2, texture, uv0, uv1, uv2, color, color, color, blend, flag)
	RendererDrawTriangleTextured(g_render, v0, v2, v3, texture, uv0, uv2, uv3, color, color, color, blend, flag)
}
