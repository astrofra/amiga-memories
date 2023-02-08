/*
	File: assets/scripts/gng.nut
	Author: Astrofra
*/

/*

"Capcom (Taito America license)", "Ghosts'n Goblins (US)"

From the Arcade to the Amiga.

There has been a hundred of ports of Arcade games to the Amiga, but a very few are considered as good adaptations.

Despite the powerful hardware of the Amiga, making a perfect port of an arcade game in the end of the 80's was quite a challenge.

It is not surprising, then, that Ghost'n Goblins is considered as one if the best versions ported to a home computer. 

---

Ghosts'n Goblins, known as Makaimura in Japan, is an arcade game developed by Capcom in 1985.
It is famous for being one the most difficult video games ever released.

If we look into the specs of the arcade machine, the hardware of Ghosts'n Goblins embarks a 16bits Motorola 6809 at 1.5Mhz working as the central CPU.
The audio is produced by a Zilog 280 driving a dual-YM2203 sound processor.
The graphics seems handled by a specific tile-based architecture, able to process the background elements, the scrolling and the sprites.

The tile-based architecture, that relies on a set of graphics blocks that can be quickly rearranged and scrolled, 
allowed the coin-op system to animate a huge amount of data on screen even with a slow CPU in its core.
In the late 80's, most of the Western home computers worked with a bitmap-based video that made the graphics animation far more CPU hungry, even with a use of a Blitter.

This explains partly why a poweful home-computer such as the Amiga was barely able to emulate the pace of an arcade game powered by a 1.5Mhz CPU.

*/

/* Camera list :
front
top
left
right
left_close
right_close
grendizer
harlock
df0
game_box_left

gng_camera_cabinet_left
gng_camera_right
gng_camera_left
gng_camera_cabinet_straight_down
gng_camera_cabinet_controls_left
gng_camera_cabinet_controls_right
*/

stage_script	<-	[

	{	text = "pause", 
		duration = Sec(3.0),
		fade = "In",
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(4.0),
		titler = { text = "Episode 2 - Ghosts'n Goblins", command = "In"},
		led  = [{power = 1, drive = 1}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(2.0),
		titler = { command = "Out"},
		led  = [{power = 1, drive = 0}],
//		music = { command = "Start", file = "boing_music", gain = 0.15	},
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "Among the dozen of ports of Arcade games to the Amiga, very few are considered as good adaptations.", 
		sub = {	fr = ["Among the dozen of ports of Arcade games to the Amiga","very few are considered as good adaptations."]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(0.5),
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "Despite the powerful hardware of the Amiga, making a perfect port of an arcade game was quite a challenge in the end of the 80's .", 
		sub = {	fr = ["Despite the powerful hardware of the Amiga", "making a perfect port of an arcade game", "was quite a challenge in the end of the 80's"]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "left", motion = "PanRight"}	},

	{	text = "As a matter of fact, it is not surprising that Ghost'n Goblins is considered as one of the best ports of coin-op games to a home computer.", 
		sub = {	fr = ["As a matter of fact, it is not surprising", "that Ghost'n Goblins is considered", "as one of the best ports of coin-op games to a home computer."]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "left", motion = "PanRight"}	},

	{	text = "pause", 
		duration = Sec(0.25),
		fade = "Out",
		led  = [{power = 1, drive = 0}],
		camera = {name = "left", motion = "PanRight"}	},

	//	-----------------------------------------------

	{	text = "pause", 
		duration = Sec(0.25),
		fade = "In",
		led  = [{power = 1, drive = 0}],
		video = [{file = "gng_arcade", frame = 70, screen = "arcade_monitor", screen_material = "assets/arcade/arcade_gng_screen.nmm"}],
		camera = {name = "gng_camera_cabinet_straight_down", motion = "PanUp", speed = Mtr(1.15)}	},

	{	text = "Ghosts'n Goblins, originaly titled Makaimura in Japan, is an arcade game developed by Capcom in 1985.", 
		sub = {	fr = ["Ghosts'n Goblins", "originaly titled Makaimura in Japan", "is an arcade game developed by Capcom in 1985."]
			}
		video = [{file = "gng_arcade", screen = "arcade_monitor", screen_material = "assets/arcade/arcade_gng_screen.nmm"}],
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_straight_down", motion = "PanUp", speed = Mtr(1.15)}	},

	{	text = "It is famous for being one of the most difficult video games ever released.", 
		sub = {	fr = ["It is famous for being one of", "the most difficult video games ever released."]
			}
		video = [{file = "gng_arcade", screen = "arcade_monitor", screen_material = "assets/arcade/arcade_gng_screen.nmm"}],
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_screen_left", motion = "PanRight", speed = Mtr(0.75)}	},

	{	text = "pause", 
		duration = Sec(1.0),
		video = [{file = "gng_arcade", screen = "arcade_monitor", screen_material = "assets/arcade/arcade_gng_screen.nmm"}],
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_screen_left", motion = "PanRight", speed = Mtr(0.75)}	},

	{	text = "If we look into the specs of the arcade machine, the hardware of Ghosts'n Goblins embarks a 16bits Motorola 6809 at 1.5Mhz working as the central CPU", 
		sub = {	fr = [""]
			}
		video = [{file = "gng_arcade", screen = "arcade_monitor", screen_material = "assets/arcade/arcade_gng_screen.nmm"}],
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_right", motion = "PanLeft", speed = Mtr(2.25)}	},

	{	text = "The audio is produced by a Zilog 280 driving a dual-YM2203 sound processor.", 
		sub = {	fr = [""]
			}
		video = [{file = "gng_arcade", screen = "arcade_monitor", screen_material = "assets/arcade/arcade_gng_screen.nmm"}],
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_right", motion = "PanLeft", speed = Mtr(2.25)}	},

	{	text = "As usual for a game of this era, the graphics are handled by a specific tile-based architecture, able to process the background elements, the scrolling and the sprites.", 
		sub = {	fr = ["As usual for a game of this era", "the graphics are handled by a specific tile-based architecture", "able to process the background elements", "the scrolling and the sprites."]
			}
		video = [{file = "gng_arcade", screen = "arcade_monitor", screen_material = "assets/arcade/arcade_gng_screen.nmm"}],
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "DollyFront", speed = Mtr(2.0)}	},

	{	text = "The tile-based architecture, that relies on a set of graphics blocks that can be quickly rearranged and scrolled, allowed the coin-op system to animate a huge amount of data on screen even with a slow CPU in its core.", 
		sub = {	fr = ["The tile-based architecture that relies", "on a set of graphics blocks that can be quickly rearranged and scrolled", "allowed the coin-op system to animate a huge amount of data on screen", "even with a slow CPU in its core."]
			}
		video = [{file = "gng_arcade", screen = "arcade_monitor", screen_material = "assets/arcade/arcade_gng_screen.nmm"}],
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "DollyFront", speed = Mtr(2.0)}	},

	{	text = "But in the late 80's, most of the Western home computers worked with a bitmap-based video that made the graphics animation far more CPU hungry, even with a use of a Blitter.", 
		sub = {	fr = ["But in the late 80's", "most of the Western home computers worked with a bitmap-based video", "that made the graphics animation far more CPU hungry", "even with a use of a Blitter."]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "DollyBack"}	},

	{	text = "This is one of the main factors that created a deception each time an arcade game was brought to the Commodore Amiga.", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "DollyBack"}	},

	{	text = "High were the expectations of the youngest Amiga owners, convinced that their machine was able to process an almost unlimited amount of data.", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "PanLeft"}	},

	{	text = "One remarkable aspect of the Ghosts'n Goblins Amiga port is the pixel perfect alikeness with the original versions.", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "PanLeft"}	},

	{	text = "In those days, after if the adaptations rights were negociated, it was generally up to the developper in charge of the port to obtain the original assets or to recreate them.", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "DollyFront"}	},

	{	text = "Whereas the graphics of the Atari version of Ghosts'n Goblins were entierely redrawn from scratch, the Amiga assets are a direct copy of the original Arcade bitmaps.", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "DollyFront"}	},

	{	text = "Either the teams of Elite where provided with the floppy disks by the initial Japanese developers, or the programmer manage to read and decode the ROM from the Arcade PCB.", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "PanRight"}	},

	{	text = "The first method was reportedly used on the adaptation of the famous coin op 'Operation Wolf' and the later granted another pixel-perfect port of the game XXXXX.", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "PanRight"}	},

	{	text = "In 2011, Locomalito, a the famous Spanish developer, created 'Maldita Castilla', an authentic oldschool game directly inspired by Ghosts'n Goblins", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "PanRight"}	},

	{	text = "Locomalito belongs to that generation of players whose childhood was haunted by the strong background of Makaimura. He played the game in the Arcades and at home too, on the Amiga version.", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "PanRight"}	},

	{	text = "Not only he was able to capture and recreate the very gloomy atmosphere of the Japanese game, but he built a completely original set of monsters and sceneries.", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "PanRight"}	},

	{	text = "'Msldita Castilla' is a double tribute to this landmark of Japanese gameplay and to the Castillan myths and legends.", 
		sub = {	fr = [""]
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "gng_camera_cabinet_front", motion = "PanRight"}	},


	{	text = "pause", 
		duration = Sec(1.0),
		led  = [{power = 1, drive = 0}],
//		music = { command = "Stop"	},
		camera = {name = "front", motion = "DollyBack"}	}
	]