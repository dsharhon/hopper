@echo off

"C:\Program Files\7-Zip\7z" a -sfx7zS2.sfx hopper-install-v1.exe hopper.exe install.bat uninstall.bat
del hopper.exe
pause