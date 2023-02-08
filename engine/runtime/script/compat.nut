g_engine	<-	0

function	RendererLoadWriterFont(renderer, base_path, path)
{	return ResourceFactoryLoadRasterFont(g_factory, base_path, path)	}

//-----------------------------------------------------------------------------
function	EngineGetRenderer(e)
{	return g_render	}
function	EngineGetMixer(e)
{	return g_mixer	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	UILoadFont(path)
{	return ProjectLoadUIFont(g_project, path)	}
function	UILoadFontAliased(path, name)
{	return ProjectLoadUIFontAliased(g_project, path, name)	}
function	UIDeleteFontAlias(name)
{	return ProjectDeleteUIFontAlias(g_project, name)	}
function	UIGetFont(name)
{	return ProjectGetUIFont(g_project, name)	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	ItemGetScriptLogicFrequency(i)
{	return 0	}
function	ItemSetScriptLogicFrequency(i, v) {}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	PictureNew()
{	return NewPicture(0, 0)	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	LoadTexture(path)
{	return ResourceFactoryLoadTexture(g_factory, path)	}
function	NewTexture()
{	return ResourceFactoryNewTexture(g_factory)	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	TextComputeRect(clip_rect, text, font_name, state)
{	return UIFontComputeRect(clip_rect, text, UIGetFont(font_name), state)	}
function	PictureTextRender(picture, rect, text, font_name, state)
{	PictureWriteText(picture, rect, text, UIGetFont(font_name), state)	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	EngineNewTexture(engine)
{	return ResourceFactoryNewTexture(g_factory)	}
function	EngineLoadTexture(engine, path)
{	return ResourceFactoryLoadTexture(g_factory, path)		}
function	EngineLoadGeometry(engine, path)
{	return ResourceFactoryLoadGeometry(g_factory, path)		}
function	EngineLoadMaterial(engine, path)
{	return ResourceFactoryLoadMaterial(g_factory, path)		}

function	EngineLoadTextureBypassCache(engine, path)
{	return ResourceFactoryLoadTextureEx(g_factory, path, true)		}
function	EngineLoadGeometryBypassCache(engine, path)
{	return ResourceFactoryLoadGeometryEx(g_factory, path, true)		}
function	EngineLoadMaterialBypassCache(engine, path)
{	return ResourceFactoryLoadMaterialEx(g_factory, path, true)		}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	EngineLoadSound(engine, path)
{	return ResourceFactoryLoadSound(g_factory, path)		}
function	EngineLoadPicture(engine, path)
{	return ResourceFactoryLoadPicture(g_factory, path)		}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	EngineResetClock(engine)
{	ClockReset(ProjectGetClock(g_project))	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	EngineGetToolMode(engine)
{
	return 0;
}
function	EnginePurgeResourceCache(engine)
{	return ResourceFactoryPurge(g_factory)	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	ItemGetScene(item)
{	return g_scene	}
function	ItemActivate(item, v)
{	SceneItemActivate(g_scene, item, v)	}
function	ItemActivateHierarchy(item, v)
{	SceneItemActivateHierarchy(g_scene, item, v)	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	UIAddWindow(ui, id, x, y, w, h)
{	return UIAddNamedWindow(ui, id.tostring(), x, y, w, h)	}
function	UIAddBitmapWindow(ui, id, path, x, y, w, h)
{	return UIAddNamedBitmapWindow(ui, id.tostring(), LoadPicture(path), x, y, w, h)	}
function	UIAddStaticTextWidget(ui, id, text, font_name)
{	return UIAddTextWidget(ui, id, text, UIGetFont(font_name))	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	WindowShow(window, show)
{	WindowSetOpacity(window, show ? 1 : 0)	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	ItemSetup(item)
{	SceneSetupItem(g_scene, item)	}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	ProjectSceneGetScriptInstance(project_scene, name)
{
	local scene_instance = ProjectSceneGetInstance(project_scene)
	return SceneGetScriptInstance(scene_instance, name)
}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function SceneSetItemDeletionDelay(scene, delay) {}
function SceneEnableItemDeletionQueue(scene, enable) {}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	EngineSetClockScale(engine, k)
{
}
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function	WindowCentre(window)
{
}
//-----------------------------------------------------------------------------
