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
		titler = { text = "Episode 1 - The Boing Ball", command = "In"},
		led  = [{power = 1, drive = 1}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(3.0),
		titler = { command = "Out"},
		led  = [{power = 1, drive = 0}],
		music = { command = "Start", file = "boing_music", gain = 0.15	},
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "In 1984, during the Consumer Electronic Show in Las Vegas, the core team of Amiga Corporation was about to demonstrate the first prototype of a machine that would, eventually, redefine the standards of personal computers for the next decade.", 
		sub = {	fr = ["En 1984 au cours du 'Consumer Electronic Show' de Las Vegas", "les ingénieurs d'Amiga Corporation s'apprêtaient à montrer", "le premier prototype d'une machine qui allait, tôt ou tard,", "changer durablement le visage de l'informatique domestique."], 
				en = ["In 1984 during the Consumer Electronic Show in Las Vegas", "the core team of Amiga Corporation was about to demonstrate", "the first prototype of a machine that would, eventually,", "redefine the standards of personal computers for the next decade."], 
				jp = ["1984年、ラスベガスで開催されたコンシューマ エレクトロニクス ショーにおいて、","Amiga Corporation の中心メンバーはその後10年間のPCの基準を再定義することになる製","品の最初のプロトタイプのデモンストレーションを行おうとしていました。"],
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(1.0),
		led  = [{power = 1, drive = 0}],
//		music = { command = "Stop"	},
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(1.0),
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "The story says that Dale Luck and RJ Mical decided to create a technical demo of what the Amiga prototype was really capable of.", 
		sub = {	fr = ["L'histoire raconte que Dale Luck et RJ Mical decidèrent de créer", "une démo montrant ce que l'Amiga était capable de faire."], 
				en = ["The story says that Dale Luck and RJ Mical decided to create", "a technical demo of what the Amiga prototype was really capable of."], 
				jp = ["Amigaプロトタイプの真の実力を示すテクニカル デモンストレーションの作成を","決定したのはデール・ラックとRJミカルであったということです。"],
			}
		led  = [{power = 1, drive = 1}],
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(1.0),
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "The Boing Demo relied exclusively on the graphic hardware, and the large colored ball was animated smoothly thanks to the very unique technique of playfields.", 
		sub = {	fr = ["La 'Boing Demo' s'appuyait exclusivement sur le hardware graphique", "et l'enorme sphere colorée se déplaçait avec fluidité", "grâce à l'utilisation très originale des playfields."],
				en = ["The Boing Demo relied exclusively on the graphic hardware", "and the large colored ball was animated smoothly", "thanks to the very unique technique of playfields."],
				jp = ["Boingデモはグラフィック ハードウェアのみを用いたものでしたが、極めてユニークなプレイフィールドのテクニックにより、","カラーボールのスムーズなアニメーションが表示されました。"],
			}
		emulator = { name = "boing_ball_demo"	},
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "Because the Motorola 68000 that powers the machine wasn't busy at all with the display, the Boing Ball would then become an impressive demonstration of the multitasking capabilities of the system.", 
		sub = {	fr = ["Parce que le Motorola 68000 au cœur de la machine", "n'était pas du tout occupé par l'affichage", "la 'Boing Ball' allait devenir une demonstration impressionnante", "des possibilités multitâches du système."], 
				en = ["Because the Motorola 68000 that powers the machine", "wasn't busy at all with the display", "the Boing Ball would then become an impressive demonstration", "of the multitasking capabilities of the system."], 
				jp = ["マシンの原動力であるMotorola 68000が表示処理でビジーになることは全くなく、","Boing Ballはシステムのマルチタスク能力を強力に印象づけるデモンストレーションとなりました。"],
			}
		emulator = { name = "boing_ball_demo", narrator_command = "OpenNarrator" },
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(1.5),
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_close", motion = "PanRight"}	},

	{	text = "Years later, in a documentary by Janice Crotty about the history of the Amiga, Dale Luck explained how they managed to generate the incredible sound that made the demo so famous.", 
		sub = {	fr = ["Plus tard, dans un documentaire de Janice Crotty", "sur l'histoire de l'Amiga", "Dale Luck expliqua la façon dont ils étaient parvenus", "à produire cet impressionnant bruitage", "ayant rendu la démo si celèbre."],
				en = ["Years later, in a documentary by Janice Crotty", "about the history of the Amiga", "Dale Luck explained how they managed", "to generate the incredible sound", "that made the demo so famous."],
				jp = ["数年後、Amigaの歴史についてジャニス・クロッティが製作したドキュメンタリーの中で、","デール・ラックはこのデモをここまで有名にした素晴らしいサウンドをどのように作り出したかを語っています。"],
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_close", motion = "PanRight"}	},

	{	text = "Back then, at such an early stage of the hardware development, it was practically impossible to digitize and edit an audio sample on the Amiga itself.", 
		sub = {	fr = ["A cette époque,", "à un stade initial du développement du hardware", "il était pratiquement impossible de numériser et de retravailler", "un enregistrement audio directement sur l'Amiga."],
				en = ["Back then,", "at such an early stage of the hardware development", "it was practically impossible to digitize and edit", "an audio sample on the Amiga itself."],
				jp = ["ハードウェア開発のごく初期段階にあった当時、","Amiga上でオーディオサンプルをデジタル化し編集することは事実上不可能でした。"],
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_close", motion = "PanRight"}	},

	{	text = "As a matter of fact, the sound was created by Sam Dicker and Bob Pariseau, by hitting a metal garage door and recording it on an Apple 2 computer.", 
		sub = {	fr = ["En réalité", "ce bruitage fut créé par Sam Dicker et Bob Pariseau", "en frappant une porte de garage en métal", "enregistrée puis samplée sur un ordinateur Apple II."], 
				jp = ["実際には、サウンドはサム・ディッカーとボブ・パリソーが、","金属製のガレージの扉を叩く音をApple 2cンピュータに録音して作成しました。"],
				en = ["As a matter of fact", "the sound was created by Sam Dicker and Bob Pariseau", "by hitting a metal garage door", "and recording it on an Apple II computer."], 
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_close", motion = "PanRight"}	},

	{	text = "This sample was then massaged into the proper format to be replayed by Paula, the audio chip of the Amiga.", 
		sub = {	fr = ["Cet enregistrement binaire fut ensuite remanié", "avant d'être rejoué par Paula, la puce audio de l'Amiga."],
				en = ["This sample was then massaged into the proper format", "to be replayed by the audio chip of the Amiga."],
				jp = ["このサンプルを、AmigaのオーディオチップであるPaula上で再生できる適切なフォーマットに落とし込んだのです。"],
			}
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_close", motion = "PanRight"}	},

	{	text = "pause", 
		duration = Sec(1.0),
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "If the Boing demo is the first technical demonstration made for the Amiga, the sound of the bouncing ball is, most probably, the first digitized audio sample ever sent to the Paula circuitry.", 
		sub = {	fr = ["Si 'Boing' est la toute première démo réalisée pour l'Amiga", "le bruitage de rebond de cette sphere est, très probablement,", "le premier sampling audio jamais envoyé dans les circuits de Paula."], 
				en = ["If the Boing demo", "is the first technical demonstration made for the Amiga", "the sound of the bouncing ball is, most probably,", "the first digitized audio sample ever sent to the Paula circuitry."], 
				jp = ["BoingデモがAmiga初のテクニカル デモであるとすれば、弾むボールの音はおそらく、","Paulaの回路上で処理された最初のデジタル オーディオ サンプルであったと言えます。"],
			}
		emulator = { name = "boing_ball_demo", narrator_command = "CloseNarrator"},
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", duration = Sec(3.0),
		led  = [{power = 1, drive = 1}],
		emulator = { name = "boing_ball_demo", duration = Sec(5.0), narrator_command = "CloseNarrator"},
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", duration = Sec(5.0),
		led  = [{power = 1, drive = 0}],
		emulator = { name = "boing_ball_demo", duration = Sec(3.0)},
		camera = {name = "monitor", motion = "DollyFront"}	},

	{	text = "pause", duration = Sec(25.0)
		led  = [{power = 1, drive = 0}],
		event = "boing_ball_body",
		emulator = { name = "boing_ball_demo", duration = Sec(15.0)},
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "pause", duration = Sec(25.0)
		led  = [{power = 1, drive = 0}],
		event = "boing_ball_body",
		emulator = { name = "boing_ball_demo", duration = Sec(15.0)},
		camera = {name = "left", motion = "PanRight"}	},

	{	text = "pause", 
		duration = Sec(8.0),
		led  = [{power = 1, drive = 0}],
		emulator = { name = "boing_ball_demo", duration = Sec(8.0)},
		camera = {name = "left", motion = "PanRight"}	},

	{	text = "pause", 
		duration = Sec(2.0),
		fade = "Out",
		led  = [{power = 1, drive = 0}],
		emulator = { name = "boing_ball_demo", duration = Sec(2.0)},
		music = { command = "FadeOut"	},
		camera = {name = "left", motion = "PanRight"}	},
]