#
#	File: narrator.nut
#	Author: Astrofra
#

# Include("scripts/utils/utils.nut")

g_mary_exception_list = [	["CPU","C.P.U"],
							["Mhz", "Mega Hertz"],
							["PCB", "P.C.B"],
							["YM", "Y.M."],
							]

#!
#	@short	Narrator
#	@author	Astrofra
#	@desc	Turns an array of strings into a folder of wav files.
#	@input	Array of strings
#	@ouput	A series of wav files in the "tmp/" folder
#			A table with each string and its related SHA key.
#/

def TextToSpeech(str_array):
	speech_table	=	[]

	if (typeof str_array) == "array":
		ExecuteBatch(CleanupBatch(), "cleanup.bat")

		for _str in str_array:
			str_key = SHA1(_str)
			# 	Replace certain specific espressions (CPU -> C.P.U)
			# 	That the TTS can't handle
			if g_tts_mary:
				for exception_couple in g_mary_exception_list:
					if _str.tolower().find(exception_couple[0].tolower()) != null:
						_str = StringReplace(_str.tolower(), exception_couple[0].tolower(), exception_couple[1])

			# 	Cleanup previous TXT files
			ExecuteBatch(CleanupTextBatch(), "cleanup_txt.bat")

			# 	Outputs the current text excerpt
			system("echo " + _str + " > " + g_current_path_engine + "input.txt")

			# 	Convert the text except into a sound file
			if !g_tts_mary:
				ExecuteBatch(SAPI5TTSBatch(), "SAPI5TTS.bat")
			else:
				ExecuteBatch(MaryTTSBatch(), "MARYTTS.bat")

			# 	Extract the lipsync information from the sound file
			ExecuteBatch(WavToPhonemeToNutBatch(), "wav_to_phoneme_to_nut.bat")

			# 	Apply a post process the sound file
			if g_enable_voice_postprocess:
				ExecuteBatch(SOXBatch(), "sox.bat")
			else:
				system("rename " + g_current_path_engine + "input.wav output.wav")

			ExecuteBatch(OggEncodeBatch(), "ogg.bat")

			# 	Rename the sound file & lipsync
			system("rename " + g_current_path_engine + "output.ogg " + "voice_" + g_story + "_" + str_key + ".ogg")
			system("rename " + g_current_path_engine + "output.nut " + "voice_" + g_story + "_" + str_key + ".nut")
	else:	
		print("Narrator() : Cannot process " + str_array)

# ------------------------ BATCHES ----------------------

# -------------------------
def LaunchMaryTTS():
	_str = [
				"@Echo off",
				"REM === Generated by GameStart ===",
				"echo Starting Mary TTS Server",
				"cd /d " + g_current_path_dos,
				"cd ../../speaker/mary/marytts-5.0/bin",
				"marytts-server.bat",
				"pause"
	]

	return 	_str


def CleanupBatch():
	_str = [
				"@Echo off",
				"REM === Generated by GameStart ===",
				"echo 'Cleanup Batch File'",
				"cd /d " + g_current_path_dos,
				"del input.wav",
				"del output.wav",
				"del output.nut",
				"del *.txt",
				"del voice_*.ogg",
				"del voice_*.wav",
				"del voice_*.nut",
				"del *.edl",
				"del *.reapeaks"
			]

	return	_str


def CleanupTextBatch():
	_str = [
				"@Echo off",
				"REM === Generated by GameStart ===",
				"echo 'Cleanup Texts Batch File'",
				"cd /d " + g_current_path_dos,
				"del *.txt"
			]

	return	_str


def SAPI5TTSBatch():
	voice_locale = None

	if g_french_voice:
		print("SAPI5TTSBatch() Using a French voice")
		voice_locale = "\"ScanSoft Virginie_Dri40_16Khz\""
	else:
		print("SAPI5TTSBatch() Using an English voice")
		voice_locale = "\"Microsoft Anna - English\""

	_str = [
				"@Echo off",
				"REM === Generated by GameStart ===",
				"echo 'TTS (SAPI5) File'",
				"cd /d " + g_current_path_dos,
				"ptts.exe -voice " + voice_locale + " -w input.wav -u input.txt -r -2 -c 1 -s 48000"
			]

	return	_str

def MaryTTSBatch():

	if g_french_voice:
		print("!!!MaryTTSBatch() French voice is not available in MaryTTS")

	_str = [
				"@Echo off",
				"REM === Generated by GameStart ===",
				"echo 'MaryTTS file'",
				"cd /d " + g_current_path_dos,
				"..\\..\\python\\python.exe query_mary_tts.py",
				"..\\..\\python\\python.exe python accelerate_speech.py"
			]

	return	_str

def WavToPhonemeToNutBatch():
	_str = [
				"REM === Generated by GameStart ===",
				"@echo off",
				"echo Wav to Phonemes to Squirrel",
				"cd /d " + g_current_path_dos,
				"phonemes.exe input.wav -x -m 40",
				"..\\..\\python\\python.exe phoneme_to_nut.py"
			]

	return	_str

def SOXBatch():
	_str = [
				"REM === Generated by GameStart ===",
				"@echo off",
				"echo Audio Post Process",
				"cd /d " + g_current_path_dos,
				"sox.exe --norm input.wav output.wav treble +5 overdrive 5 lowpass 2000 highpass 450"
			]

	return	_str

def OggEncodeBatch():
	_str = [
				"REM === Generated by GameStart ===",
				"@echo off",
				"Ogg Encode",
				"cd /d " + g_current_path_dos,
				"oggenc2.exe output.wav"
			]

	return	_str
