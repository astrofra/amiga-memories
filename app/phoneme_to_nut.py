import string

final_buffer = 'list_phoneme <- [\n'

f = open('phonemes.txt', 'r')
buffer = f.read()
f.close()

pos = buffer.find('<Phonemes>')
if pos != -1:                                          
	buffer = buffer[pos+10:len(buffer)-13]
	
	buffer = string.split(buffer, ',')
	
	for phoneme_array in buffer:
		phoneme = string.split(phoneme_array, ':')
		
		first_time = phoneme[0]
		last_time = phoneme[1]
		phoneme_type = phoneme[2]

		final_buffer += '{\n'			
		final_buffer += '		first_time =' + first_time + ',\n'
		final_buffer += '		last_time =' + last_time + ',\n'
		final_buffer += '		phoneme_type =\"' + phoneme_type + '\"\n'	
			
		final_buffer += '},\n'		
		
final_buffer += ']'

f = open('phonemes.nut', 'w')
f.write(final_buffer)
f.close()