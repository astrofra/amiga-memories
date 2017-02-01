import gs
from project import ProjectHandler

plus = gs.GetPlus()
plus.CreateWorkers()

plus.RenderInit(1280, 720)

gs.MountFileDriver(gs.StdFileDriver())
gs.LoadPlugins()

project = ProjectHandler()
project.OnSetup()

# scn = plus.NewScene()

# cam = plus.AddCamera(scn, gs.Matrix4.TranslationMatrix((0, 1, -10)))

# scn.Load("assets/master_scene/master_scene.scn ", gs.SceneLoadContext(plus.GetRenderSystem()))

# fps = gs.FPSController(0, 2, -10)

while not plus.IsAppEnded():
	dt = plus.UpdateClock()
	project.OnUpdate()

	# fps.UpdateAndApplyToNode(cam, dt)

	# plus.UpdateScene(scn, dt)
	plus.Text2D(5, 5, "Move around with QSZD, left mouse button to look around")
	plus.Flip()