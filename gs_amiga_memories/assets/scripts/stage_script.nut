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
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "In 1984, during the Consumer Electronic Show in Las Vegas, the core team of Amiga Corporation was about to demonstrate the first prototype of a machine that would, eventually, redefine the standards of personal computers for the next decade.", 
		sub = ["En 1984 au cours du 'Consumer Electronic Show' de Las Vegas", "les ingénieurs d'Amiga Corporation s'apprêtaient à montrer", "le premier prototype d'une machine qui allait, tôt ou tard,", "changer durablement le visage de l'informatique domestique."], 
		sub_en = ["In 1984 during the Consumer Electronic Show in Las Vegas", "the core team of Amiga Corporation was about to demonstrate", "the first prototype of a machine that would, eventually,", "redefine the standards of personal computers for the next decade."], 
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(1.0),
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(1.0),
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "The story says that Dale Luck and RJ Mical decided to create a technical demo of what the Amiga prototype was really capable of.", 
		sub = ["L'histoire raconte que Dale Luck et RJ Mical decidèrent de créer", "une démo montrant ce que l'Amiga était capable de faire."], 
		sub_en = ["The story says that Dale Luck and RJ Mical decided to create", "a technical demo of what the Amiga prototype was really capable of."], 
		led  = [{power = 1, drive = 1}],
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(1.0),
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "The Boing Demo relied exclusively on the graphic hardware, and the large colored ball was animated smoothly thanks to the very unique technique of playfields.", 
		sub = ["La 'Boing Demo' s'appuyait exclusivement sur le hardware graphique", "et l'enorme sphere colorée se déplaçait avec fluidité", "grâce à l'utilisation très originale des playfields."],
		sub_en = ["The Boing Demo relied exclusively on the graphic hardware", "and the large colored ball was animated smoothly", "thanks to the very unique technique of playfields."],
		emulator = { name = "boing_ball_demo"	},
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "Because the Motorola 68000 that powers the machine wasn't busy at all with the display, the Boing Ball would then become an impressive demonstration of the multitasking capabilities of the system.", 
		sub = ["Parce que le Motorola 68000 au cœur de la machine", "n'était pas du tout occupé par l'affichage", "la 'Boing Ball' allait devenir une demonstration impressionnante", "des possibilités multitâches du système."], 
		sub_en = ["Because the Motorola 68000 that powers the machine", "wasn't busy at all with the display", "the Boing Ball would then become an impressive demonstration", "of the multitasking capabilities of the system."], 
		emulator = { name = "boing_ball_demo", narrator_command = "OpenNarrator" },
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "pause", 
		duration = Sec(1.5),
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_close", motion = "PanRight"}	},

	{	text = "Years later, in a documentary by Janice Crotty about the history of the Amiga, Dale Luck explained how they managed to generate the incredible sound that made the demo so famous.", 
		sub = ["Plus tard, dans un documentaire de Janice Crotty", "sur l'histoire de l'Amiga", "Dale Luck expliqua la façon dont ils étaient parvenus", "à produire cet impressionnant bruitage", "ayant rendu la démo si celèbre."],
		sub_en = ["Years later, in a documentary by Janice Crotty", "about the history of the Amiga", "Dale Luck explained how they managed", "to generate the incredible sound", "that made the demo so famous."],
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_close", motion = "PanRight"}	},

	{	text = "Back then, at such an early stage of the hardware development, it was practically impossible to digitize and edit an audio sample on the Amiga itself.", 
		sub = ["A cette époque,", "à un stade initial du développement du hardware", "il était pratiquement impossible de numériser et de retravailler", "un enregistrement audio directement sur l'Amiga."],
		sub_en = ["Back then,", "at such an early stage of the hardware development", "it was practically impossible to digitize and edit", "an audio sample on the Amiga itself."],
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_close", motion = "PanRight"}	},

	{	text = "As a matter of fact, the sound was created by Sam Dicker and Bob Pariseau, by hitting a metal garage door and recording it on an Apple 2 computer.", 
		sub = ["En réalité", "ce bruitage fut créé par Sam Dicker et Bob Pariseau", "en frappant une porte de garage en métal", "enregistrée puis samplée sur un ordinateur Apple II."], 
		sub_en = ["As a matter of fact", "the sound was created by Sam Dicker and Bob Pariseau", "by hitting a metal garage door", "and recording it on an Apple II computer."], 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_close", motion = "PanRight"}	},

	{	text = "This sample was then massaged into the proper format to be replayed by Paula, the audio chip of the Amiga.", 
		sub = ["Cet enregistrement binaire fut ensuite remanié", "avant d'être rejoué par Paula, la puce audio de l'Amiga."],
		sub_en = ["This sample was then massaged into the proper format", "to be replayed by the audio chip of the Amiga."],
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_close", motion = "PanRight"}	},

	{	text = "pause", 
		duration = Sec(1.0),
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "If the Boing demo is the first technical demonstration made for the Amiga, the sound of the bouncing ball is, most probably, the first digitized audio sample ever sent to the Paula circuitry.", 
		sub = ["Si 'Boing' est la toute première démo réalisée pour l'Amiga", "le bruitage de rebond de cette sphere est, très probablement,", "le premier sampling audio jamais envoyé dans les circuits de Paula."], 
		sub_en = ["If the Boing demo", "is the first technical demonstration made for the Amiga", "the sound of the bouncing ball is, most probably,", "the first digitized audio sample ever sent to the Paula circuitry."], 
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
		camera = {name = "left", motion = "PanRight"}	},
]

stage_script_beyond_the_ice_palace	<-	[
	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},
	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},
	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "Beyond the Ice Palace, an Amiga game released in 1988, was also ported on most of the home computers on the market in those days.", 
		sub = ["Beyond the Ice Palace", "un jeu Amiga sorti en 1988", "fut également porté sur la majorité", "des micro-ordinateurs de l'époque."], 
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_top", motion = "DollyFront"}	},

	{	text = "The game was a 2D scrolling platformer. As quoted by Wikipedia, it presented some similarities to Ghosts 'n Goblins, such as, the ability to pick up different weapons.", 
		sub = ["Il s'agissant d'un platformer à scrolling 2D .",  "Comme le mentionne Wikipédia,", "il présente des similarités avec Ghosts 'n Goblins,", "comme le fait d'employer plusieurs armes."], 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_top", motion = "DollyFront"}	},

	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_top", motion = "DollyFront"}	},

	{	text = "A fast paced action with a smooth scrolling, and loads of animations, in addition with an, exceptionally good adaptation on the Amstrad CPC, contributed in the positive reception of this game.", 
		sub = ["Une action rythmée, un scrolling fluide et de riches animations,", "en plus d'une superbe adaptation sur Amstrad CPC,", "on contributé à la bonne réception du jeu."], 
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_top", motion = "PanRight"}	},

	{	text = "It is interesting to note that, David Perry, was in charge of the Amstrad CPC port, of Beyond the Ice Palace.", 
		sub = ["Il est interessant de noter", "que David Perry fut chargé de du port Amstrad CPC", "de 'Beyond the Ice Palace'."], 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_top", motion = "Idle"}	},

	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_top", motion = "Idle"}	},

	{	text = "The very same David Perry, that would, later, create games such as Earthworm Jim or MDK!", 
		sub = ["Le même David Perry qui, plus tard,", "créera des jeux tels que Earthworm Jim ou MDK!"], 
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "Idle"}	},

	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "Idle"}	},
	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_top", motion = "DollyBack"}	},
	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_top", motion = "DollyBack"}	},

	{	text = "In 2012, a young author, who's name is Aseyn, decided to create a graphic novel, titled 'Le Palais deu Glahce'.", 
		sub = ["En 2012", "un jeune auteur appelé Aseyn", "a decidé d'écrire une bande-dessinée", "titrée 'Le Palais de Glace'"], 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_top", motion = "DollyBack"}	},

	{	text = "", 
		sub = [""], 
		led  = [{power = 1, drive = 0}],
		camera = {name = "left_top", motion = "DollyBack"}	},

]

stage_script_dune	<-	[
	{	text = "pause", 
		led  = [{power = 1, drive = 0}],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "A beginning, is a very delicate time.", 
		sub	 = ["Un commençement est un moment d'une délicatesse extrême."],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "Know then, that this is the year ten thousand one ninety one.",
		sub	 = ["Sachez donc que l'on est en l'an 10191"],
		camera = {name = "front", motion = "DollyFront"}	},

	{	text = "The Known Universe is ruled by the Padishah Emperor Shaddam IV, my father.",
		sub	 = ["L'Univers Connu est gouverné par l'Empereur Padishah Shaddam IV", "... mon père."],
		camera = {name = "right", motion = "PanLeft"}	},

	{	text = "In this time, the most precious substance in the universe is the spice Melanjeh.", 
		sub	 = ["A cette époque, la plus précieuse substance de l'univers", "est l'Epice, le Mélange"],
		camera = {name = "front", motion = "DollyBack"}	},

	{	text = "The spice extends life.", 
		sub	 = ["L'Epice accroît la longévité."],
		camera = {name = "left_close", motion = "PanLeft"}	},

	{	text = "The spice expands consciousness.", 
		sub	 = ["L'Epice amplifie le champ de conscience."],
		camera = {name = "left_close", motion = "PanLeft"}	},

	{	text = "The spice is vital to space travel!", 
		sub	 = ["L'épice est vitale aux voyages dans l'espace."],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "pause", 
		sub	 = [""],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "The Spacing Guild and its navigators, who the spice has ,mutated, over 4,000 years, use the orange spice gas, which gives them the ability to fold space!", 
		sub	 = ["Les navigateurs de la Guilde Spatiale,", "que l'epice a fait muter après 4000 ans d'usage", "en absorbent le gaz orange", "qui leur donne le pouvoir de replier l'espace!"],
		camera = {name = "front", motion = "DollyFront"}	},

	{	text = "That is, travel, to any part of the universe, without moving.", 
		sub	 = ["C'est à dire...", "de se transporter n'importe où dans l'univers, sans se déplacer."],
		camera = {name = "poster_0", motion = "DollyBack"}	},

	{	text = "pause",
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "Oh? yes? I forgot to tell you! The spice! exists on only one planet, in the entire universe.", 
		sub	 = ["Ah oui ... j'oubliais de vous dire...", "L'Epice n'existe que sur une seule planète dans tout l'univers."],
		camera = {name = "right_top", motion = "PanLeft"}	},

	{	text = "A desolate, dry planet! with vast dezzerts!", 
		sub	 = ["Désolée, arride, cette planète possède de vaste déserts."],
		camera = {name = "left_close", motion = "DollyBack"}	},

	{	text = "Hidden away, within the rocks of these dezzerts, are a people known as the Fremen!",
		sub	 = ["Cachés dans le rochers des cavernes de ces déserts...", "...vit un peuple connu sous le nom de Fremen..."],
		led  = [{power = 1, drive = 0}, {power = 1, drive = 1}], 
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "Who have long held a prophecy! That a man would come... A messiah! who would lead them to true freedom.", 
		video = "dune", frame = 75
		sub	 = ["...qui depuis longtemps prophétise la venue d'un homme", "d'un messie qui les conduirait vers la véritable liberté."],
		led  = [{power = 1, drive = 1}, {power = 1, drive = 0}, {power = 1, drive = 1}, {power = 1, drive = 0}], 
		camera = {name = "right_close", motion = "PanLeft"}	},

	{	text = "The planet, is Arrakis! also known as... Dune!", 
		sub	 = ["Cette planète, c'est Arrakis, connue aussi sous le nom de ...", "Dune." ],
		video = "dune",
		camera = {name = "front", motion = "DollyFront"}	},

	{	text = "pause", 
		video = "dune",
		camera = {name = "front", motion = "DollyFront"}	},

	{	text = "pause", 
		video = "dune",
		camera = {name = "front", motion = "DollyFront"}	},

	{	text = "pause", 
		video = "dune",
		camera = {name = "front", motion = "DollyFront"}	},
]

stage_script_fr	<-	[
	{	text = "pause", camera = {name = "top", motion = "DollyFront"}	},
	{	text = "Ceci est un test de synthaise vocale.", camera = {name = "front", motion = "DollyFront"}	},
	{	text = "Ce programme a pour but de lire un texte a voix haute.", camera = {name = "left", motion = "PanLeft"}	},
	{	text = "L'ordinateur que vous voyez devant vous", camera = {name = "right", motion = "PanLeft"}	},
	{	text = "est un Commodore Amiga 500.", camera = {name = "front", motion = "DollyBack"}	},
	{	text = "Merci, de votre attention.", camera = {name = "top", motion = "DollyFront"}	}
]
