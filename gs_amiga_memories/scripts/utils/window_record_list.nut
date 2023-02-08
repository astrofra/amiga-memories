
class WindowRecordList
{
	window_record = 0

	sprite_to_load = 0
	sprite_to_delete = 0
	sprite_to_save = 0

	one_frame_to_wait_draw = 0

	warning_widget = 0


	//--------------------------------------------------------------------------------------------
	function ShowWarningMessage(_message)
	{
		one_frame_to_wait_draw = 2

		// create the SAVE WARNING WIDGET
		warning_widget = g_WindowsManager.CreateClickButton(0, _message)
		warning_widget.SetSkin("orange_skin")
		warning_widget.SetOpacity(0.85)
		warning_widget.Show(true); g_WindowsManager.PushInFront(warning_widget);		warning_widget.Update(true)
		warning_widget.SetPos(Vector(g_cursor.GetXScreenSpace(0.5) - warning_widget.width*0.5, g_cursor.GetYScreenSpace(0.5) - warning_widget.height*0.5, 0))
		warning_widget.authorize_move = false; warning_widget.authorize_folded = false;	warning_widget.authorize_resize = false
		// make a draw to see this widget
		g_CarCamera.Update()
		SceneRenderUI(g_scene, g_render)
	}

	//--------------------------------------------------------------------------------------------
	function ClickOnSaveButton(_sprite)
	{
		sprite_to_save = _sprite

		ShowWarningMessage(tr("Sauvegarde en cours !"))
	}

	//--------------------------------------------------------------------------------------------
	function ClickOnDeleteRecord(_sprite)
	{
		sprite_to_delete = _sprite

		ShowWarningMessage(tr("Destruction en cours !"))
	}

	//--------------------------------------------------------------------------------------------
	function ClickOnLoadRecord(_sprite)
	{
		sprite_to_load = _sprite

		ShowWarningMessage(tr("Chargement en cours !"))
	}


	/*!
		@short	Update
		Called each frame.
	*/
	function	Update()
	{	
		--one_frame_to_wait_draw
		if(one_frame_to_wait_draw >= 0)
			return

		if(sprite_to_save)
		{
			local date_table = date()

	//		g_ValueRecorder.Save(date_table["day"]+"_"+(date_table["month"].tointeger()+1).tostring()+"_"+date_table["year"]+" "+date_table["hour"]+"."+date_table["min"]+"."+date_table["sec"])
			//	Format : DD-MM_12h12h30s
			g_ValueRecorder.Save(date_table["day"]+"-"+(FormatNumberString((date_table["month"].tointeger()+1).tostring(),2)).tostring()+"_"+date_table["hour"]+"h"+date_table["min"]+"m"+date_table["sec"]+"s")
			g_ValueRecorder.UpdateListRecords()
			ShowHide(true)

			// hide the warning message
			warning_widget.Hide(true)
			warning_widget = 0
			sprite_to_save = 0
			
		}
		else
		if(sprite_to_delete)
		{
			foreach(item in g_ValueRecorder.array_item_record)
			{
				{
					// if problem with the id, create them
					if(item.special_id == "")
						g_ValueRecorder.UpdateAllSpecialId()										
				}
				
				if	(FileExists("./magnetoscope/"+sprite_to_delete.user_param.name_record+"/"+item.special_id+".nml"))
					FileDelete("./magnetoscope/"+sprite_to_delete.user_param.name_record+"/"+item.special_id+".nml")
			}
			// delete the folder
			ShellExecute("rmdir  \"magnetoscope/"+sprite_to_delete.user_param.name_record+"\"", "")

			if	(FileExists("./magnetoscope/"+sprite_to_delete.user_param.name_record+".nml"))
				FileDelete("./magnetoscope/"+sprite_to_delete.user_param.name_record+".nml")
			if	(FileExists("./magnetoscope/"+sprite_to_delete.user_param.name_record+".csv"))
				FileDelete("./magnetoscope/"+sprite_to_delete.user_param.name_record+".csv")

			g_ValueRecorder.UpdateListRecords()
			ShowHide(true)

			// hide the warning message
			warning_widget.Hide(true)
			warning_widget = 0
			sprite_to_delete = 0
			
		}
		else
		if(sprite_to_load)
		{

			g_ValueRecorder.Load(sprite_to_load.user_param.name_record)

			// hide the warning message
			warning_widget.Hide(true)
			warning_widget = 0
			sprite_to_load = 0

		}

	}

	//--------------------------------------------------------------------------------------------
	function	ShowHide(_force_show = false)
	{
		if(!window_record || !window_record.is_shown || _force_show)
		{
			if(window_record)
				g_WindowsManager.KillWidget(window_record)

			window_record = g_WindowsManager.CreateVerticalSizer(0, 600)	
			window_record.SetPos(Vector(0, 340, 0))
			window_record.authorize_background = false

			// add the save button
			local horizontal_check = g_WindowsManager.CreateHorizontalSizer(window_record, 900)	
			local item_check = g_WindowsManager.CreateClickButton(horizontal_check, tr("Sauvegarde enregistrement courant"))	
			local save_check = g_WindowsManager.CreateCheckButton(horizontal_check, "", true, this, "ClickOnSaveButton", "ui/icon_vcr-record_save.tga", "ui/icon_vcr-record_save.tga")	

			// get the list of record		
			local	metafile = MetafileNew()		
			if	(TryLoadMetafile(metafile, "magnetoscope/records_name.nml"))
			{
				// Grab root tag.
				local	records_tag = MetafileGetTag(metafile, "Records")
				if	(MetatagIsValid(records_tag))
				{	
					// create this scene unique id
					local scene_id = "scene_id_" 
					scene_id += g_scenarios[ProjectGetScriptInstance(g_project).scene_key].name
					scene_id += g_scenarios[ProjectGetScriptInstance(g_project).scene_key]["spawnpoint_array"][g_scenarios[ProjectGetScriptInstance(g_project).scene_key]["default_spawnpoint"]].scene
					scene_id += "_spawnpoint_" + g_scenarios[ProjectGetScriptInstance(g_project).scene_key]["spawnpoint_array"][g_scenarios[ProjectGetScriptInstance(g_project).scene_key]["default_spawnpoint"]].name
					scene_id += "_vehicle_"+g_common_assets.vehicle.path

					scene_id = ConformString(scene_id)

					// create the list of record
					local stat_stop_grid_widget = g_WindowsManager.CreateGridSizer(window_record, 900, 400.0)		
					stat_stop_grid_widget.SetMaxSprite(4, 8)

					local child_authorize_counter = 0
					local list_tag_child = MetatagGetChildren(records_tag)
					foreach(id, child_tag in list_tag_child)
					{
						local scene_name_record = MetatagGetValue( MetatagGetTag(child_tag, "record_scene_name"))

						if(scene_id == scene_name_record)
						{
							local name_record = MetatagGetValue( MetatagGetTag(child_tag, "record_name"))

							local widget = g_WindowsManager.CreateClickButton(stat_stop_grid_widget, child_authorize_counter+1, "", this, "ClickOnLoadRecord")
								widget.user_param = {name_record = name_record}		

							local widget = g_WindowsManager.CreateClickButton(stat_stop_grid_widget, name_record, "", this, "ClickOnLoadRecord")
								widget.user_param = {name_record = name_record}		

							local widget = g_WindowsManager.CreateCheckButton(stat_stop_grid_widget, "", true, this, "ClickOnLoadRecord", "ui/icon_vcr-record_load.tga", "ui/icon_vcr-record_load.tga")	
								widget.user_param = {name_record = name_record}		

							local widget = g_WindowsManager.CreateCheckButton(stat_stop_grid_widget, "", true, this, "ClickOnDeleteRecord", "ui/icon_vcr-record_delete.tga", "ui/icon_vcr-record_delete.tga")	
								widget.user_param = {name_record = name_record}		

							++child_authorize_counter
						}
					}
				}
			}

			window_record.SetSize(window_record.width, window_record.height)
			window_record.Show(true)
			g_WindowsManager.PushInFront(window_record)
		}
		else
			window_record.Hide(true)
	}

	//--------------------------------------------------------------------------------------------
	function	Kill()
	{
		g_WindowsManager.KillWidget(window_record)
		window_record = 0


		sprite_to_load = 0
		sprite_to_delete = 0
		sprite_to_save = 0
	}
};