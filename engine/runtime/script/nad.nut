/* -----------------------------------------------------------------------------
	GSFramework
	Copyright 2001-2013 Emmanuel Julien. All Rights Reserved.
----------------------------------------------------------------------------- */

try
{	__DEFINE_NENGINE_LIBRARY__ = 1	}
catch(e)
{
	__DEFINE_NENGINE_LIBRARY__ <- 1

	Include("@core/script/vector.nut")
	Include("@core/script/vector2.nut")
	Include("@core/script/rect.nut")
	Include("@core/script/matrix.nut")
	Include("@core/script/math.nut")
	Include("@core/script/rand.nut")
	Include("@core/script/minmax.nut")
	Include("@core/script/io.nut")
	Include("@core/script/ui.nut")
	Include("@core/script/timeout_handler.nut")
	Include("@core/script/helper.nut")
	Include("@core/script/project.nut")
	Include("@core/script/billboard.nut")
	Include("@core/script/metafile.nut")

	// OO wrapper API.
	Include("@core/script/oo/oo.nut")

	Include("@core/script/compat.nut")
}
