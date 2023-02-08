//	Project local path on the current filesystem

g_current_path_dos		<-	"d:/projects/svn_amiga_memories/gs_amiga_memories/tmp"
g_current_path_engine 	<-	0

{
	local	sq_path = g_current_path_dos
	print("GetDosPathFromSquirrelPath() : input = " + sq_path)
	sq_path += "/"
	local	_list = split(sq_path, "/")
	local	engine_path = "", dos_path = ""
	foreach(folder in _list)
	{
		if (folder != "")
		{
			engine_path += (folder + "\\\\")
			dos_path += (folder + "/")
		}
	}

	print("GetDosPathFromSquirrelPath() : output = " + engine_path)
	g_current_path_dos = dos_path
	g_current_path_engine = engine_path
}
