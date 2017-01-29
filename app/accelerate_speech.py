import wave
import struct
import os

if os.path.exists('input_short.wav'):
	os.remove('input_short.wav')

f = wave.open('input.wav', 'rb')
fo = wave.open('input_short.wav', 'wb')

framerate = f.getframerate()
sampwidth = f.getsampwidth()
nframes = f.getnframes()

print('accelerate_speech.py')
print('---------------------')
print('framerate = ' + str(framerate))
print('sampwidth = ' + str(sampwidth))
print('nframes   = ' + str(nframes))

fo.setnchannels(1)
fo.setframerate(framerate)
fo.setsampwidth(sampwidth)

fmt = "%ih" % sampwidth

do_write = True
blank_byte_count = 0

for i in range(0,nframes / sampwidth):
	s = f.readframes(sampwidth)
	si = struct.unpack(fmt, s)[0]
	# print(si)
	if abs(si) < 16:
		blank_byte_count += 1
	else:
		blank_byte_count = 0
		do_write = True

	if blank_byte_count > 16:
		do_write = False

	if do_write:
		fo.writeframesraw(s)

f.close()
fo.close()

if os.path.exists('input.bak.wav'):
	os.remove('input.bak.wav')

os.rename('input.wav', 'input.bak.wav')
os.rename('input_short.wav', 'input.wav')

