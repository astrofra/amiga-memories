/*
	File: scripts/emulator_2d.nut
	Author: Astrofra
*/

Include("scripts/emulators/emu_starfield.nut")
Include("scripts/2d_bob.nut")

/*!
	@short	Emulator2D
	@author	Astrofra
*/
class	Emulator2D
{

	main_camera			=	0

	starfield_handler	=	0
	bob_handler			=	0
	bob_list			=	0

	land_barrier		=	0
	land_clouds			=	0

	function	OnSetup(scene)
	{
		starfield_handler = EmuStarfield(scene)
		starfield_handler.Setup()
	}

	function	OnUpdate(scene)
	{
		starfield_handler.Update()
	}

	function	OnRenderUser(scene)
	{
		starfield_handler.RenderUser()
	}

}
