REM project.ngp
REM e:\works\gsedit\gsedit_2012_directx\resources\editor\runtime\win32\viewer.exe -f ./scenes/stage.nms
..\engine\win32\viewer.exe project.ngp -P -S ./ -CC ..\engine\runtime -ignore_esc -ignore_missing -fallback_disk_fs -CC ./ -log_file render.log -no_log_popup
pause