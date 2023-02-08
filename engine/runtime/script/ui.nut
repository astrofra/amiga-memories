/*#
	Topic: UI
#*/

/*#
	Section: UIGlobal
#*/

/*#
	Func: UIScreenCoordinatesToUI
	Proto: Vector2:UI,float x,float y
	Desc: Convert from normalized screen coordinates to UI coordinates.
	Example:
// Display a sprite at the system mouse position.
local	mouse_device = GetMouseDevice()
local	mx = DeviceInputValue(mouse_device, DeviceAxisX),
		my = DeviceInputValue(mouse_device, DeviceAxisY)

local	ui_position = UIScreenCoordinatesToUI(ui, mx, my)
SpriteSetPosition(cursor_sprite, ui_position.x, ui_position.y)
#*/
function	UIScreenCoordinatesToUI(ui, x, y)
{
	local v = Vector(x, y, 1) * UIGetScreenToUIMatrix(ui)
	return Vector2(v.x, v.y)
}

function    WindowCenterPivot(window)
{
	local size = WindowGetSize(window)
	WindowSetPivot(window, size.x * 0.5, size.y * 0.5)
}

function	CameraWorldToScene2d(camera, world, scene2d)
{
	local	screen = CameraWorldToScreen(camera, g_render, world),
			res2d = UIGetInternalResolution(scene2d)
	return Vector2(screen.x * res2d.x, screen.y * res2d.y)
}