/*
	File: scripts/emulators/emu_scrolltext.nut
	Author: Astrofra
*/

/*!
	@short	EmulatorScrollText
	@author	Astrofra
*/
class	EmuScrollText
{

	ui				=	0
	letters			=	0
	sprites			=	0
	sprites_pool	=	0
	alphabet		=	"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789   :!?'[],-."
	text			=	""
	grid_width		=	8
	x				=	0.0
	y				=	700.0
	current_char	=	0
	scroll_speed	=	5.0
	letter_zoom		=	2.0
	next_letter_w	=	32
	letter_fade_w	=	128

	function	Update()
	{
		x += g_dt_frame * 60.0 * scroll_speed

		if (x > next_letter_w * letter_zoom)
		{
			x = 0
			local	c = text.slice(current_char, current_char + 1).toupper()
			local	letter_tex
			if (CharToHashableKey(c) in letters)
			{
				letter_tex = letters[CharToHashableKey(c)].texture
				local	spr, x
				x = 1280
				x += (letters[CharToHashableKey(c)].w - 32)
				if (sprites_pool.len() == 0)
					spr = UIAddSprite(ui, -1, letter_tex, x, y, 32, 32)
				else
				{
					spr = sprites_pool[0]
					SpriteSetTexture(spr, letter_tex)
					SpriteSetOpacity(spr, 1.0)
					SpriteSetPosition(spr, x, 700)
					sprites_pool.remove(0)
				}
				SpriteSetScale(spr, letter_zoom, letter_zoom)
				sprites.append(spr)

				next_letter_w = letters[CharToHashableKey(c)].w
			}

			current_char++
			if (current_char >= text.len())
				current_char = 0
		}

		foreach(idx, sprite in sprites)
		{
			local	tx = SpriteGetPosition(sprite).x
			local	ty = SpriteGetPosition(sprite).y

			tx -= g_dt_frame * 60.0 * scroll_speed

			if (tx < -letter_fade_w)
			{
				sprites.remove(idx)
				sprites_pool.append(sprite)
				SpriteSetOpacity(sprite, 0.0)
			}
			else
				SpriteSetPosition(sprite, tx, ty)

			local	opa = 1.0
			if (tx < letter_fade_w)
				opa = RangeAdjust(tx, 0.0, letter_fade_w, 0.0, 1.0)
			else
			if (tx > 1280 - letter_fade_w)
				opa = RangeAdjust(tx, 1280 - letter_fade_w, 1280, 1.0, 0.0)

			opa = Clamp(opa, 0.0, 1.0)
			SpriteSetOpacity(sprite, opa)
		}
	}

	function	Setup()
	{
		local	font_picture
		font_picture = ResourceFactoryLoadPicture(g_factory, "assets/demo_font_4.png")
		local	i,j,idx = 0
		for(j = 0; j < 8;j++)
			for(i = 0; i < grid_width; i++)
			{
				local	tx,ty
				tx = i * 32
				ty = j * 32
				local	new_texture = NewTexture()
				local	new_picture = NewPicture(32, 32)
				PictureBlitRect(font_picture, new_picture, Rect(tx, ty, tx + 32, y + 32), Rect(0,0,32,32), BlendCompose)
				TextureUpdate(new_texture, new_picture)
				TextureSetWrapping(new_texture, false, false)

				if (idx < alphabet.len())
				{
					local c = alphabet.slice(idx, idx + 1)
					local _w
					if (c == "I" || c == "!" || c == "." || c == "," || c == ":")
						_w = 16
					else
						_w = 32
					if (c != " ")	letters.rawset(CharToHashableKey(c), {w = _w, h = 32, texture = new_texture})
					idx++
				}
			}

		local	_grad = UIAddSprite(ui, -1, ResourceFactoryLoadTexture(g_factory, "assets/scroll_bg_gradient.png"), 1280 * 0.5, y + 32, 64, 128)
		SpriteSetPivot(_grad, 32, 64)
		SpriteSetScale(_grad, 100, 1.5)
		SpriteSetOpacity(_grad, 0.5)
	}

	function	CharToHashableKey(_char)
	{
		switch(_char)
		{
			case "!":
				_char = "exclmark"
				break
			case "?":
				_char = "questionmark"
				break
			case ",":
				_char = "coma"
				break
			case ":":
				_char = "colon"
				break
			case ".":
				_char = "dot"
				break
			case "[":
				_char = "brackop"
				break
			case "]":
				_char = "brackcl"
				break
			case "-":
				_char = "minus"
				break
		}

		return _char
	}

	constructor(_scene)
	{
		letters = {}
		sprites	= []
		sprites_pool = []

		ui = SceneGetUI(_scene)

		text = ""
		text += "this is amiga memories !!"
		text += " you are about to enjoy a tribute to this historical machine."
		text += " this tribute was brought to you by a group of former fans of the amiga :] !!! "
	}

}
