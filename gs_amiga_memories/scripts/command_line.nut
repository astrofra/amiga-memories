/*
	File: scripts/command_line.nut
	Author: Astrofra
*/

//----------------------------------------------------------------------------
function	ExecuteBatch(batch_cmd_list, batch_filename = "", bgmode = "None")
//----------------------------------------------------------------------------
{
	if (batch_cmd_list.len() == 0)
	{
		print("ExecuteBatch() : empty command list, doing nothing.")
		return
	}

	local	str = ""
	foreach(cmd in batch_cmd_list)
		str += (cmd + "\r" + "\n")

	if (batch_filename == "")
		batch_filename = SHA1(Irand(1000, 9999).tostring()) + ".bat"

	print("ExecuteBatch() : " + batch_filename)

	FileWriteFromString(g_current_path_engine + batch_filename, str)

	if (bgmode == "RunInBackground")
		system("start " + g_current_path_engine + batch_filename)
	else
		system(g_current_path_engine + batch_filename)

	print("ExecuteBatch() : Done!")
}