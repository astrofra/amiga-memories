##	Opens the input.txt file and send it to MaryTTS
##	Get the output and writes it as a wav file.
import urllib
file = open("input.txt", "r")
tts_string = file.read()
##tts_string = "This is Amiga Speaking. In this video, I am to going to tell you my personnal story. As a matter of fact, who more than me would be able to tell you exact story of the amazing Amiga computer, eh ?"
## voices : dfki-obadiah-hsmm
## voices : dfki-obadiah
tts_query = "http://localhost:59125/process?INPUT_TEXT=" + tts_string + "&INPUT_TYPE=TEXT&OUTPUT_TYPE=AUDIO&AUDIO=WAVE_FILE&LOCALE=en_US&VOICE=dfki-obadiah-hsmm"

urllib.urlretrieve (tts_query, "input.wav")
