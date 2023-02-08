

/*!
	@short	Picture binding.
*/
class		Picture
{
	handle			=	0;

	function		GetPixel(x,y)
	{	return PictureGetPixel(handle, x, y);	}
	
	function		SetPixel(x,y,rgba)
	{	PictureSetPixel(handle, x, y, rgba);	}

	function		Fill(...)
	{	
		if (vargv.len() == 4)
			PictureFill(handle, Vector(vargv[0], vargv[1], vargv[2], vargv[3]));
		else
			PictureFill(handle, vargv[0]);
	}

	function		GetRect()
	{	return PictureGetRect(handle);	}

	function		TextRender(rect, text, font, parm)
	{	PictureTextRender(handle, rect, text, font, parm);	}
	
	function        ApplyConvolution(kernel_width, kernel_height, kernel)
	{	return PictureApplyConvolution(handle, kernel_width, kernel_height, kernel);	}

	function        LoadContent(path)
	{	return PictureLoadContent(handle, path);	}
	
	function		Alloc(...)
	{
		if (vargv.len() == 1)
			return (PictureAlloc(handle, vargv[0].GetWidth().tointeger(), vargv[0].GetHeight().tointeger()));
		else
			return (PictureAlloc(handle, vargv[0], vargv[1]));
	}

	function		GetHandle()
	{	return handle;	}
	constructor(...)
	{	
		if (vargv.len() == 0)
			handle = PictureNew();
		else
			handle = vargv[0];		
	}
}
