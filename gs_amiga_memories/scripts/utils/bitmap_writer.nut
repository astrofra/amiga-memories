//----------------------------------------------------------------------------------------------------
function	WriterWrapper(font, text, x, y, size, color = Vector(1, 1, 1, 1), align = WriterAlignLeft)
//----------------------------------------------------------------------------------------------------
{//print(text)
	local	viewport = RendererGetOutputDimensions(g_render)
	local	vw = viewport.x, vh = viewport.y
	local	k_ar = vh / vw

	local	sx = (x - (1280.0 * 0.5)) / (1280.0 * 0.5) * k_ar + 0.5
	local	sy = y / 960.0

	RendererWrite(g_render, font, text, sx, sy, size, true, align, color)
}


/* EXEMPLE : 

		//	Loading
		font_bitmap = RendererLoadWriterFont(EngineGetRenderer(g_engine), "ui/profont.nml", "ui/profont")

		//	Utilisation
		function	OnRenderUI(scene)
		{
			WriterWrapper(font_bitmap, "blabla", x, y, zoom_factor, color) 
			// color = vector(1,1,1,1)
		}

*/