class	ItemLabel3D
{
/*<
	<Script =
		<Name="Item Label">
		<Author="Emmanuel Julien">
		<Description="Display a 3D label at the location of an item.">
		<Category = "FX">
	>
	<Parameter=
		<label = <Name = "Label"> <Type = "String"> <Default = "Label">>
		<x = <Name = "Position X"> <Type = "Float"> <Default = 0.5>>
		<y = <Name = "Position Y"> <Type = "Float"> <Default = 0.5>>
		<k = <Name = "Scale"> <Type = "Float"> <Default = 1.0>>
	>
>*/
	raster_font		=	0

	label			=	"Label"
	x				=	0.5
	y				=	0.5
	k				=	1.0
	
	function	OnRenderUser(item)
	{
		// Create a billboard matrix that will face the current view point and sit at the item position.
		local m = RendererGetViewMatrix(g_render)
		m.SetRow(3, ItemGetWorldPosition(item))

		// Set the world matrix and write.
		RendererSetWorldMatrix(g_render, m)
		RendererWrite(g_render, raster_font, label, x, y, k, false, WriterAlignMiddle, Vector(1, 1, 1))
	}

	function	OnSetup(item)
	{
		// Load the raster font from core resources.
		raster_font = LoadRasterFont(g_factory, "@core/fonts/profiler_base.nml", "@core/fonts/profiler_base")
	}
}
