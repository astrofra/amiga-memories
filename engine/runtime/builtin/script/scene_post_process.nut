class	BuiltinSceneSetPostProcess
{
/*<
	<Script =
		<Name = "Set Post Process">
		<Author = "Francois Gutherz">
		<Description = "Enable/Disable the various flags of post process on setup.">
		<Category = "Presentation">
		<Compatibility = <Scene>>
	>
	<Parameter =
		<enable_aa	= <Name = "Enable AntiAliasing"> <Type = "Bool"> <Default = False>>
		<ssao_blur_fast	= <Name = "Use fast SSAO filter"> <Type = "Bool"> <Default = False>>
		<dof_blur_fast	= <Name = "Use fast DOF filter"> <Type = "Bool"> <Default = False>>
	>
>*/
	enable_aa		=	false
	ssao_blur_fast		=	false
	dof_blur_fast		=	false

	function	OnSetup(scene)
	{
		RendererRegistrySetKey(g_render, "Antialising:Enable", enable_aa)
		RendererRegistrySetKey(g_render,"Antialising:Sample", 2.0)
		RendererRegistrySetKey(g_render, "PostProcess:SSAO:FastBlur", ssao_blur_fast)
		RendererRegistrySetKey(g_render, "PostProcess:Dof:Fast", dof_blur_fast)
	}
}
