/*
	File: scripts/texture_changer.nut
	Author: Astrofra
*/

/*!
	@short	TextureChanger
	@author	Astrofra
*/
class	TextureChanger
{
/*<
	<Parameter =
		<filename = <Name = "Texture"> <Type = "String"> <Default = "null">>
	>
>*/
	filename = "assets/portrait_jay-miner.png"

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		if (!FileExists(filename))
			return

		local	tex = ResourceFactoryLoadTexture(g_factory, filename)
		local	geo = ItemGetGeometry(item)
		local	mat = GeometryGetMaterialFromIndex(geo, 0)
		MaterialSetTexture(mat, 0, tex)
	}
}
