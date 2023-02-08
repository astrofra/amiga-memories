//	Utils.nut

_OUTPUT_ERROR_		<-	1
_OUTPUT_INFO_		<-	0

g_vector_green		<-	Vector(0.1,1.0,0.25)
g_vector_blue		<-	Vector(0.05,0.15,0.5)
g_vector_cyan		<-	Vector(0.05,0.7,0.75)

//------------------------------
function StringReplace(string, original, replacement)
//------------------------------

{
  // make a regexp that will match the substring to be replaced
  //
  local expression = regexp(original);

  local result = "";
  local position = 0;

  // find the first match
  //
  local captures = expression.capture(string);

  while (captures != null)
  {
    foreach (i, capture in captures)
    {
      // copy from the current position to the start of the match
      //
      result += string.slice(position, capture.begin);

      // add the replacement substring instead of the original
      //
      result += replacement;

      position = capture.end;
    }

    // find the next match
    //
    captures = expression.capture(string, position);
  }

  // add any remaining part of the string after the last match
  //
  result += string.slice(position);

  return result;
}

//------------------------------
function GetCenterMinMax(minmax)
//------------------------------
{
	return Vector((minmax.max.x - minmax.min.x)*0.5, (minmax.max.y - minmax.min.y)*0.5,(minmax.max.z - minmax.min.z)*0.5)
}

//-------------------------------------------
function	GroupItemExists(group, _item_name)
//-------------------------------------------
{
	local	_list = GroupGetItemList(group)
	foreach(_item in _list)
		if (ItemGetName(_item) == _item_name)
			return true
			
//	LogOutput("SceneItemExists() Cannot find item '" + _item_name + "'.", _OUTPUT_ERROR_)
	return false
}

function	DrawCircleInXZPlane(_pos = Vector(0,0,0), _radius = Mtr(1.0), _color = Vector(1,1,1), _step = 5.0)
{
	local	_point, _prev_point = -1, i
	local	ct = cos(Deg(_step))
	local	st = sin(Deg(_step))
	local	x = _radius, y = 0.0

	for (i = 0.0; i <= 360.0; i += _step)
	{

		_prev_point = clone(_pos)
		_prev_point.x += x // * _radius
		_prev_point.z += y // * _radius

		local tmp = x * ct - y * st
		y = x * st + y * ct
		x = tmp

		_point = clone(_pos)
		_point.x += x // * _radius
		_point.z += y // * _radius

		RendererDrawLineColored(g_render, _point, _prev_point, _color)
	}
}


function	DrawArrowInXZPlane(_pos, _direction, _size = Mtr(1.0), _color = Vector(1,1,1))
{
		local	a,b,c
		a = _direction.Normalize()
		b = Vector(-a.z, a.y, a.x)
		c = Vector(a.z, a.y, -a.x)
		RendererDrawTriangle(g_render,	_pos + a.Scale(_size), _pos + b.Scale(_size), _pos + c.Scale(_size), _color, _color, _color,	MaterialBlendAdd, MaterialRenderDoubleSided | MaterialRenderNoDepthWrite)
}

function	DrawQuadInXZPlane(_pos, _direction, _size = Mtr(1.0), _color = Vector(1,1,1))
{
		local	a,b,c,d
		a = _direction.Normalize()
		b = Vector(-a.z, a.y, a.x)
		c = Vector(a.z, a.y, -a.x)
		d = Vector(c.z, c.y, -c.x)

		RendererDrawTriangle(g_render,	_pos + a.Scale(_size), _pos + b.Scale(_size), _pos + c.Scale(_size), _color, _color, _color,	MaterialBlendAdd, MaterialRenderDoubleSided | MaterialRenderNoDepthWrite)
		RendererDrawTriangle(g_render,	_pos + b.Scale(_size), _pos + c.Scale(_size), _pos + d.Scale(_size), _color, _color, _color,	MaterialBlendAdd, MaterialRenderDoubleSided | MaterialRenderNoDepthWrite)
}


//----------------------------------
function	FormatNumberString(s, n)
{
	n -= s.len();
	if	(n > 0)
	{
		local	append = "";
		while (n--)
			append += "0";
		s = append + s;
	}
	return s;
}

function	RoundFloat1Decimal(_float)
{
	return (_float *10.0).tointeger() * 0.1
}
function	RoundFloat2Decimal(_float)
{
	return (_float *100.0).tointeger() * 0.01
}

function	TryLoadMetafile(metafile, _path_metafile)
{
	if(FileExists(_path_metafile))
	{
		if	(!MetafileLoad(metafile, _path_metafile))
			return false
	}
	else
		if	(!MetafileLoad(metafile, "@root/"+_path_metafile))
			return false

	return true
}
function	TrySaveMetafile(metafile, _path_metafile)
{
	if	(!MetafileSave(metafile, _path_metafile))
		if	(!MetafileSave(metafile, "@root/"+_path_metafile))
			return false
		
	return true
}

function	LogOutput(out, error_level = _OUTPUT_INFO_)
{
	if (error_level)
		print(out)
}

//----------------------------------------
function	SceneAddItem(scene, item_name)
//----------------------------------------
{
	local	object = SceneAddObject(scene, item_name)
	local	item = ObjectGetItem(object)
	ItemSetName(item, item_name)
	return item
}

//------------------------------------------------------------------------------------------
function	DeltaFrameLerp(source_value, target_value, delta_amplitude = 1.0, max_delta = 1.0)
//------------------------------------------------------------------------------------------
{
	local	delta = target_value - source_value
	local	abs_delta = Abs(delta)
	abs_delta = Min(abs_delta, max_delta)
	if (delta < 0.0)
		delta = -abs_delta
	else
		delta = abs_delta

	delta *= (g_dt_frame * 60.0)
	
	return (source_value + delta)
}

//---------------------------------------
function	LoadSceneFromNML(_filename)
//---------------------------------------
{
	local	scene_structure = {}, _file

	if (FileExists(_filename))
	{
		_file = MetafileNew()

		if	(TryLoadMetafile(_file, _filename))
		{
			local tag = MetafileGetTag(_file, "Scene;")
			scene_structure = deserializeObjectFromMetatag(tag)
		}	
	}
	
	return	scene_structure
}

//-------------------------------------------
function	SceneItemExists(scene, _item_name)
//-------------------------------------------
{
	local	_list = SceneGetItemList(scene)
	foreach(_item in _list)
		if (ItemGetName(_item) == _item_name)
			return true
			
	LogOutput("SceneItemExists() Cannot find item '" + _item_name + "'.", _OUTPUT_ERROR_)
	return false
}

//---------------------------------------------------------------
function	LegacySceneFindItemChild(_s, _child_item, _item_name)
//---------------------------------------------------------------
{
	return LegacyFindItemChild(_child_item, _item_name)
}

//-------------------------------------------------
function	LegacyFindItemChild(_child_item, _item_name)
//-------------------------------------------------
{
	local	list = ItemGetChildList(_child_item)
	
	foreach(current_item in list)
	{
		if (ItemGetName(current_item) == _item_name)
			return current_item
	}
		
	LogOutput("LegacyFindItemChild() Cannot find item '" + _item_name + "'.", _OUTPUT_ERROR_)
	return NullItem
}

//-------------------------------------------------
function	LegacySceneFindItem(_scene, _item_name)
//-------------------------------------------------
{
	local	_item, _current_item
	local	_list = SceneGetItemList(_scene)
	
	foreach(_current_item in _list)
	{
		if (ItemGetName(_current_item) == _item_name)
			return _current_item
	}
			
	LogOutput("LegacySceneFindItem() Cannot find item '" + _item_name + "'.", _OUTPUT_ERROR_)
	return NullItem
}

//-------------------------------------------------
function	SceneDeleteItemHierarchy(_scene, _item)
//-------------------------------------------------
{
	local _list = ItemGetChildList(_item)

	foreach(_child in _list)
		SceneDeleteItemHierarchy(_scene, _child)

	SceneDeleteItem(_scene, _item)
}


//-------------------------------------------------
function	SceneTestAndActivateItem(_scene, _item, _activate)
//-------------------------------------------------
{
	if(_item && ItemIsValid(_item))
		SceneItemActivate(_scene, _item, _activate)
}

//--------------------------------
function	AudioLoadSfx(_fname)
//--------------------------------
{
	local	_filename = "audio/sfx/" + _fname
	if (FileExists(_filename))
		return	ResourceFactoryLoadSound(g_factory, _filename)
	else
	{
		LogOutput("AudioLoadSfx() Cannot find file '" + _filename + "'.")
		return	0
	}
}

//-----------------------------
function	MakeTriangleWave(i)
//-----------------------------
// 1 ^   ^
//   |  / \
//   | /   \
//   |/     \
//   +-------->
// 0    0.5    1
{
	local 	s = Sign(i);
	i = Abs(i);

	if (i < 0.5)
		return (s * i * 2.0);
	else
		return (s * (1.0 - (2.0 * (i - 0.5))));
}

function	ColorIsEqualToColor(ca, cb)
{
	if (Abs(ca.x - cb.x) > 0.05)
		return false
	if (Abs(ca.y - cb.y) > 0.05)
		return false
	if (Abs(ca.z - cb.z) > 0.05)
		return false

	return true
}

//-----------------------------
function	ProbabilityOccurence(prob_amount)
//-----------------------------
{
	if (prob_amount >= 100)
		return true
	if (prob_amount <= 0)
		return false

	prob_amount = prob_amount.tofloat()
	if (Rand(0.0,100.0) <= prob_amount)
		return true
	
	return false
}

//-----------------------------------------------------------------------------------------
function TimeToString(time, separators = { minute	= "'", second	= "\"", ms		= "" })
//-----------------------------------------------------------------------------------------
{
	time = time / 10000.0
	local ftime = {
		hour	= floor(time / 3600)
		minute	= floor((time / 60) % 60)
		second	= floor(time % 60)
		ms		= floor((time * 100) % 100)
	}

	local result = ""
	foreach (key in g_time_key_order)
		if (key in separators)
			result += (ftime[key] < 10 ? "0" + ftime[key] : ftime[key]) + separators[key]

	return result
}

//----------------------
function modAngle(angle)
//---------------------- 
{
	while (angle < 0.0)
		angle += g_2_pi

	while (angle >= g_2_pi)
		angle -= g_2_pi

	return angle
}

//-----------------
class	PerlinNoise
//-----------------
{
	function Noise(x, y)	// 2 int
	{
    		local n = x.tointeger() + y.tointeger() * 57
	    	n = (n<<13) ^ n;
    		return ( 1.0 - ( (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);    
	}
 
	function SmoothNoise(x, y)	// 2 float
	{
    		local corners = ( Noise(x-1.0, y-1.0)+Noise(x+1.0, y-1.0)+Noise(x-1.0, y+1.0)+Noise(x+1.0, y+1.0) ) / 16.0
		local sides   = ( Noise(x-1.0, y)  +Noise(x+1.0, y)  +Noise(x, y-1.0)  +Noise(x, y+1.0) ) /  8.0
		local center  =  Noise(x, y) / 4.0
	    	return corners + sides + center
	}
 
	function InterpolateNoise(x, y)	// 2 float
	{
      		local integer_X    = x.tointeger()
      		local fractional_X = x - integer_X
 
      		local integer_Y    = y.tointeger()
      		local fractional_Y = y - integer_Y
 
      		local v1 = SmoothNoise(integer_X,     integer_Y)
      		local v2 = SmoothNoise(integer_X + 1, integer_Y)
     		local v3 = SmoothNoise(integer_X,     integer_Y + 1)
      		local v4 = SmoothNoise(integer_X + 1, integer_Y + 1)
 
      		local i1 = Lerp(fractional_X, v1 , v2 )
      		local i2 = Lerp(fractional_X, v3 , v4 )
 
      		return Lerp(fractional_Y, i1 , i2)
	}
 
	// you have to call this one
	function PerlinNoise_2D(x, y)	// x and y order of 0.01 //2 float	return between -1.0 and 1.0 nearly can be a bit more thought :p
	{
     		local total = 0.0
		local p = 0.5 //persistence		0.25 smooth and 1 high frequency
      		local n = 6-1 //Number_Of_Octaves - 1
 
		for(local i=0; i<n; ++i)
		{
        		local frequency = pow(2, i)
        		local amplitude = pow(p, i)
 
          		total = total + InterpolateNoise(x * frequency, y * frequency) * amplitude
		}
      		return total
	}
}

//------------------------------------------------------------
function	CreateOpaqueScreen(ui, _color = Vector(0,0,0,255))
//------------------------------------------------------------
{
		//ui = SceneGetUI(scene)
		_color = _color.Scale(1.0 / 255.0)
		local	_black_screen
		local	_tex, _pic
		_tex = ResourceFactoryNewTexture(g_factory) // ResourceFactoryLoadTexture(g_factory, "graphics/black.jpg")
		_pic = NewPicture(16, 16)
		PictureFill(_pic, _color)
		TextureUpdate(_tex, _pic)
		_black_screen = UIAddSprite(ui, -1, _tex, 1280.0 / 2.0, 960.0 / 2.0, 16.0, 16.0)
		WindowSetPivot(_black_screen, 8, 8)
		WindowCentre(_black_screen)
		WindowSetScale(_black_screen, 2048.0 / 16.0 * 1.5, 2048 / 16.0 * 1.5)
		WindowSetZOrder(_black_screen, 1.0)
}

//------------------------------------------------------------
function min(a, b)
//------------------------------------------------------------
{
	return (a < b ?a: b)
}
//------------------------------------------------------------
function max(a, b)
//------------------------------------------------------------
{
	return (a > b ?a: b)
}

//------------------------------------------------------------
function	LineIntersection2D(p1, p2, p3, p4) 
//------------------------------------------------------------
{
	// Store the values for fast access and easz
	// equations-to-code conversion
	local x1 = p1.x, x2 = p2.x, x3 = p3.x, x4 = p4.x;
	local z1 = p1.z, z2 = p2.z, z3 = p3.z, z4 = p4.z;
	 
	local d = (x1 - x2) * (z3 - z4) - (z1 - z2) * (x3 - x4)
	// If d is zero, there is no intersection
	if (d == 0) 
		return 0.0
	 
	// Get the x and z
	local pre = (x1*z2 - z1*x2), post = (x3*z4 - z3*x4)
	local result = Vector(0.0,0.0,0.0)
	result.x = ( pre * (x3 - x4) - (x1 - x2) * post ) / d
	result.z = ( pre * (z3 - z4) - (z1 - z2) * post ) / d
	 
	// Check if the x and z coordinates are within both lines
	if ( 	result.x < min(x1, x2) || 
			result.x > max(x1, x2) ||
			result.x < min(x3, x4) || 
			result.x > max(x3, x4) ) 
		return 0.0
	if ( 	result.z < min(z1, z2) || 
			result.z > max(z1, z2) ||
			result.z < min(z3, z4) || 
			result.z > max(z3, z4) ) 
		return 0.0
	 
	// Return the point of intersection
	return result
}

//------------------------------------------------------------
function	PointInPoly2D(point, poly)		// poly = {a=Vector(), b=Vector(), c=Vector(), d=Vector()}
//------------------------------------------------------------
{
    local oddNodes = false
    local x2 = poly[3].x
    local z2 = poly[3].z
    local x1, z1;

    // vertex a
	x1 = poly[0].x
	z1 = poly[0].z
	if (((z1 < point.z) && (z2 >= point.z)) || (z1 >= point.z) && (z2 < point.z)) 
	{
		if ((point.z - z1) / (z2 - z1) * (x2 - x1) < (point.x - x1))
			oddNodes = !oddNodes
	}

	x2 = x1
	z2 = z1

    // vertex b
	x1 = poly[1].x
	z1 = poly[1].z
	if (((z1 < point.z) && (z2 >= point.z)) || (z1 >= point.z) && (z2 < point.z)) 
	{
		if ((point.z - z1) / (z2 - z1) * (x2 - x1) < (point.x - x1))
			oddNodes = !oddNodes
	}

	x2 = x1
	z2 = z1

    // vertex c
	x1 = poly[2].x
	z1 = poly[2].z
	if (((z1 < point.z) && (z2 >= point.z)) || (z1 >= point.z) && (z2 < point.z)) 
	{
		if ((point.z - z1) / (z2 - z1) * (x2 - x1) < (point.x - x1))
			oddNodes = !oddNodes
	}

	x2 = x1
	z2 = z1

    // vertex d
	x1 = poly[3].x
	z1 = poly[3].z
	if (((z1 < point.z) && (z2 >= point.z)) || (z1 >= point.z) && (z2 < point.z)) 
	{
		if ((point.z - z1) / (z2 - z1) * (x2 - x1) < (point.x - x1))
			oddNodes = !oddNodes
	}

	return oddNodes
}

//	//poly poly intersection
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Gather up one-dimensional extents of the projection of the polygon
	// onto this axis.
	function gatherPolygonProjectionExtents(  poly, v) 
	{
 		local outMin, outMax	// 1D extents are output here

	    // Initialize extents to a single point, the first vertex
	    outMin = outMax = v.Dot(poly[0])
	 
	    // Now scan all the rest, growing extents to include them
	    for (local i = 1 ; i < poly.len() ; ++i)
	    {
	        local d = v.Dot(poly[i])
	        if      (d < outMin) outMin = d;
	        else if (d > outMax) outMax = d;
	    }

	    return [outMin, outMax ]
	}
	// Helper routine: test if two convex polygons overlap, using only the edges of
	// the first polygon (polygon "a") to build the list of candidate separating axes.
	function findSeparatingAxis(poly_a, poly_b) 
	{	 
	    // Iterate over all the edges
	    local prev = poly_a.len()-1;
	    for (local cur = 0 ; cur < poly_a.len() ; ++cur)
	    {	 
	        // Get edge vector.  (Assume operator- is overloaded)
	        local edge = poly_a[cur] - poly_a[prev]
	        edge.y = 0
	        edge = edge.Normalize()
	 
	        // Rotate vector 90 degrees (doesn't matter which way) to get
	        // candidate separating axis.
	        local v = Vector()
	        v.x = edge.z
	        v.z = -edge.x
	 
	        // Gather extents of both polygons projected onto this axis
	        local result_poly_a = gatherPolygonProjectionExtents(poly_a, v)
	        local result_poly_b = gatherPolygonProjectionExtents(poly_b, v)

	        // Is this a separating axis?
	        if (result_poly_a[1] < result_poly_b[0]) return true
	        if (result_poly_b[1] < result_poly_a[0]) return true
	 
	        // Next edge, please
	        prev = cur
	    }
	 
	    // Failed to find a separating axis
	    return false;
	}
	 
	// Here is our high level entry point.  It tests whether two polygons intersect.  The
	// polygons must be convex, and they must not be degenerate.
	function convexPolygonOverlap(poly_a, poly_b)
	{	 
	    // First, use all of A's edges to get candidate separating axes
	    if (findSeparatingAxis(poly_a, poly_b))
	        return false;
	 
	    // Now swap roles, and use B's edges
	    if (findSeparatingAxis(poly_b, poly_a))
	        return false;
	 
	    // No separating axis found.  They must overlap
	    return true;
	}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////