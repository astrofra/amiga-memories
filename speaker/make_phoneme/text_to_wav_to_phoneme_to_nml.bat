ptts.exe -voice "ScanSoft Virginie_Dri40_16Khz" -w out.wav -u base_text.txt -r -2 -c 1 -s 48000
REM "ScanSoft Virginie_Dri40_16Khz"
REM "Microsoft Anna - English"
phonemes.exe out.wav -x
python.exe phoneme_to_nml.py