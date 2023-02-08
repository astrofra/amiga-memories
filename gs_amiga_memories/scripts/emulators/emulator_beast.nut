/*
	File: scripts/game_beast.nut
	Author: Astrofra
*/

/*!
	@short	GameBeast
	@author	Astrofra
*/
class	GameBeast	extends EmulatorBase
{

	scene			=	0
	land_cloud 		=	0
	land_mountains	=	0
	land_grass		=	0
	land_barrier	=	0
	dir				=	-1.0

	/*!
		@short	OnUpdate
		Called each frame.
	*/
	function	OnUpdate(item)
	{
		if ("OnUpdate" in base)
			base.OnUpdate(item)

		if (paused)
			return

		local	speed = 2.5 * dir
		ScrollItem(land_mountains, Vector(speed * 0.5, 0, 0))

		foreach(cloud in land_cloud)
		{
			speed *= 1.15
			ScrollItem(cloud, Vector(speed, 0, 0))
		}

		local	speed = 1.25 * dir
		foreach(grass in land_grass)
		{
			speed *= 1.75
			ScrollItem(grass, Vector(speed, 0, 0))
		}

		ScrollItem(land_barrier, Vector(speed * 1.15, 0, 0))
	}

	/*!
		@short	OnSetup
		Called when the scene is about to be setup.
	*/
	function	OnSetup(item)
	{
		if ("OnSetup" in base)
			base.OnSetup(item)

		scene = g_scene
		//	Clouds
		land_cloud = []
		local	n, m
		for(m = 0; m < 5;m++)
		{
			n = 4 - m
			local	cloud = SceneFindItem(scene, "land_cloud_" + n.tostring())
			SceneMakeItemLoopable(scene, cloud)
			land_cloud.append(cloud)
		}

		//	Mountains
		land_mountains = SceneFindItem(scene, "land_mountains")
		SceneMakeItemLoopable(scene, land_mountains)

		land_barrier = SceneFindItem(scene, "land_barrier")
		SceneMakeItemLoopable(scene, land_barrier)

		//	grass
		land_grass = []
		local	n, m
		for(n = 0; n < 5;n++)
		{
			local	grass = SceneFindItem(scene, "land_grass_" + n.tostring())
			SceneMakeItemLoopable(scene, grass)
			land_grass.append(grass)
		}
	}

	function	ScrollItem(item, dir = Vector(1,0,0))
	{
		local	pos = ItemGetPosition(item)
		pos += dir * g_dt_frame
		if ((dir.x > 0) && (pos.x > ItemGetWidth(item)))
			pos.x -= ItemGetWidth(item)
		else
		if ((dir.x < 0) && (pos.x < -ItemGetWidth(item)))
			pos.x += ItemGetWidth(item)
		ItemSetPosition(item, pos)
	}

	function	SceneMakeItemLoopable(scene, item)
	{
		local	item_l, item_r

		item_l = SceneDuplicateItem(scene, item)
		item_r = SceneDuplicateItem(scene, item)
		ItemRenderSetup(item_l, g_factory)
		ItemRenderSetup(item_r, g_factory)

		ItemSetPosition(item_l, Vector(-ItemGetWidth(item), 0, 0))
		ItemSetPosition(item_r, Vector(ItemGetWidth(item), 0, 0))
		ItemSetParent(item_l, item)
		ItemSetParent(item_r, item)
	}

	function	ItemGetWidth(item)
	{
		local	bb = GeometryGetMinMax(ItemGetGeometry(item))
		local	width = bb.max.x - bb.min.x
		return	width
	}
}
