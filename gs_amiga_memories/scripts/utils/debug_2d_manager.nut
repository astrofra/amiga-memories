
/*!
	@short	debug 2D maanger
	@author	Movida Production
*/
class	Debug2dManager
{
	pattern_draw = 0

//***************************************************************************************************
	
	function RenderLabel(parm)
	{
		// Create a billboard matrix that will face the current view point and sit at the item position.
		local m = RendererGetViewMatrix(g_render)
		m.SetRow(3, parm.pos)

		// Set the world matrix and write.
		RendererSetWorldMatrix(g_render, m)
		RendererWrite(g_render, g_SimuFont, parm.label, 0, 0, parm.scale, false, WriterAlignMiddle, parm.color)
	}
	function RenderLine(parm)
	{
		RendererDrawLineColored(g_render, parm.pos_a, parm.pos_b, parm.color)	
	}

	function RenderCross(parm)
	{
		RendererDrawCrossColored(g_render, parm.pos_a, parm.color)	
	}

//***************************************************************************************************
	
	function OnRenderUser(scene)
	{	
		RendererSetIdentityWorldMatrix(g_render)
		
		foreach(pattern in pattern_draw)
		{
			this[pattern.callback](pattern.parm)
		}

	//	pattern_draw.clear()
	}

//***************************************************************************************************

	function DrawLabel(_label, _pos, _color=Vector(1,1,1), _scale =4.0)
	{
		pattern_draw.append({callback="RenderLabel", parm={label=_label, pos=_pos, color=_color, scale=_scale}})
	}

	function DrawLine(a, b, _color=Vector(1,1,1))
	{
		pattern_draw.append({callback="RenderLine", parm={pos_a=a, pos_b=b, color=_color}})
	}

	function DrawCross(a, _color=Vector(1,1,1))
	{
		pattern_draw.append({callback="RenderCross", parm={pos_a=a, color=_color}})
	}

//***************************************************************************************************
	
	constructor()
	{
		pattern_draw = []
	}
}
