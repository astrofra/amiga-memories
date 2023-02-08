/*
	File: tmp/stage_script.nut
	Author: Astrofra
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
*/

/* Special commands :
text = "pause"
*/

stage_script	<-	[

	{	text = "pause", 
		duration = Sec(3.0),
		fade = "In",
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(4.0),
//		titler = { text = "Episode 1 - The Boing Ball", command = "In"},
		led  = [{power = 1, drive = 1}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(3.0),
		titler = { command = "Out"},
		led  = [{power = 1, drive = 0}],
		music = { command = "Start", file = "jhericurl-med-mandarine", gain = 0.15	},
		camera = {name = "right_top", motion = "PanLeft"}	},

	{
		text = "pause", 
		emulator = { name = "boing_ball_demo" },
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},
]