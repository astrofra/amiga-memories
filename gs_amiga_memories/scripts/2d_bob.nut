/*
	File: scripts/emu_bob.nut
	Author: Astrofra
*/

/*!
	@short	EmuBob
	@author	Astrofra
*/
class	EmuBob
{
	texture			=	0
	height			=	0
	width			=	0
	position		=	0
	texel_size		=	0.1
	uv_offset		=	0

	constructor()
	{
		position = Vector()
		uv_offset = Vector()
		height = 0
		width =	0
	}

	function	SetTexture(path)
	{
		texture = ResourceFactoryLoadTexture(g_factory, path)
		height = TextureGetHeight(texture) * texel_size
		width = TextureGetWidth(texture) * texel_size	
	}

	function	SetPosition(pos)
	{
		position = clone(pos)
	}

	function	GetPosition()
	{
		return clone(position)
	}

	function	SetUVOffset(_offset)
	{
		uv_offset = clone(_offset)
	}

	function	GetUVOffset()
	{
		return uv_offset
	}

	function	Draw()
	{
		local	col = Vector(1,1,1,1)
		local	pos = position - Vector(width * 0.5, height * 0.5, 0.0)

		local	uv00, uv01, uv11, uv10
		uv00 = UV(uv_offset.x, uv_offset.y)
		uv01 = UV(uv_offset.x, 1.0 + uv_offset.y)
		uv11 = UV(1.0 + uv_offset.x, 1.0 + uv_offset.y)
		uv10 = UV(1.0 + uv_offset.x, uv_offset.y)

		RendererDrawTriangleTextured(g_render, pos, pos + Vector(0,-height,0), pos + Vector(width,-height,0), texture, uv00, uv01, uv11, col, col, col, MaterialBlendAlpha , MaterialRenderDoubleSided)
		RendererDrawTriangleTextured(g_render, pos, pos + Vector(width,0,0), pos + Vector(width,-height,0), texture, uv00, uv10, uv11, col, col, col, MaterialBlendAlpha, MaterialRenderDoubleSided)
	}
}
