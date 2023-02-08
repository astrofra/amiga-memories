/*
	GameStart SQUIRREL binding API.
	Copyright 2005~2008 Emmanuel Julien.
*/

//--------------
class	Historic
{
	size		=	8;
	values		=	array(8, 0.0);
	entry		=	8;
	fill		=	0;

	//---------------------
	function	NthValue(n)
	{
		if	(n >= size)
			n = size - 1;

		local	e = entry;
		if	((e + n) >= size)
		{
			n -= size - e;
			e = n;
		}
		else
			e += n;

		return values[e];
	}

	//---------------------
	function	GetValues()
	{
		local	v = array(fill, 0.0);
		local	e = entry;
		for	(local n = 0; n < fill; ++n)
		{
			v[n] = values[e++];
			if	(e == size)
				e = 0;
		}
		return v;
	}

	//----------------------
	function	SetSize(sze)
	{
		if	(sze < 1)
			sze = 1;
		size = sze;
		values = array(size, 0.0);
		Reset();
	}

	//-----------------
	function	Reset()
	{
		entry = size;
		fill = 0;
		for	(local n = 0; n < size; ++n)
			values[n] = 0.0;
	}

	//-----------------------
	function	Append(value)
	{
		if	(--entry < 0)
			entry = size - 1;
		values[entry] = value;
		if	(fill < size)
			fill++;
	}

	//--------------
	constructor(sze)
	{	SetSize(sze);	}
}
