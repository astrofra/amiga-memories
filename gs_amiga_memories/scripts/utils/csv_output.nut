/*
	File: scripts/csv_output.nut
	Author: Astrofra
	Short : Writes an array into a "Comma-separated values" file.
	Example :
		local	file_writer = CSVOutput()
		file_writer.AppendRow(["nom", "prenom", "age", "sexe", "cp"])
		file_writer.WriteToFile("test.csv")
*/

class	CSVOutput
{
	separator			=	","
	end_of_line			=	"\r" + "\n"
	rows_table			=	0

	//-----------
	constructor()
	{
		print("CSVOutput::constructor()")
		rows_table = []
	}

	//---------------------------------
	function	AppendRow(values_table)
	{
		rows_table.append(values_table)
	}

	//-------------------------------
	function	WriteToFile(filename)
	{
		print("CSVOutput::WriteToFile(" + filename + ")")
		local	str = ""
		foreach(row in rows_table)
		{
			local _new_line = ""
			foreach(idx, val in row)
			{
				_new_line += (val.tostring())
				if (idx < row.len())	_new_line += separator
			}
			str += _new_line + end_of_line
		}

		FileWriteFromString(filename, str)
	}
}