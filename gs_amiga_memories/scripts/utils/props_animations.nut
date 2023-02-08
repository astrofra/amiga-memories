class	WindmillRotation
{

	angle				=	0.0
	angular_velocity	=	45.0

	function	OnSetup(item)
	{
		angle = Rand(0,180)
		angular_velocity += Rand(-15,15)
	}

	function	OnUpdate(item)
	{
		ItemSetRotation(item, Vector(0,0,DegreeToRadian(angle)))
		angle += (angular_velocity * g_dt_frame)
	}


}

class TreeAnimation
{
	scale_vec		=	0
	phase			=	0.0
	wave_amplitude	=	1.0
	freq			=	1.0

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function	OnUpdate(item)
	{
		phase += g_dt_frame * 2.0
		local	coef1 = wave_amplitude * sin(phase),
				coef2 = wave_amplitude * cos(phase)

		ItemSetScale(item, scale_vec + scale_vec * Vector(coef1, 0.0, coef2))
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		wave_amplitude	=	Rand(0.0025, 0.005)
		scale_vec = ItemGetScale(item) * Rand(0.9,1.5) 
		phase	=	DegreeToRadian(Rand(0,360))
		freq += Rand(-0.5,0.5)
	}
};