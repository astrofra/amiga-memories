REM === Generated by GameStart ===
@echo off
echo Audio Post Process
cd /d d:/projects/svn_amiga_memories/gs_amiga_memories/tmp/
sox.exe --norm input.wav output.wav treble +5 overdrive 5 lowpass 2000 highpass 450
