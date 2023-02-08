cd /d d:\projects\svn_amiga_memories\gs_amiga_memories\tga
ffmpeg -framerate 30 -i frame_%4d.tga  -vcodec libx264 -framerate 30 -s 662x346 out.mp4
pause
