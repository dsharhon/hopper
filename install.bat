@echo off

echo Checking for existing installation...
dir "%LocalAppData%\Hopper" /b && goto cleanup

echo Making installation directory...
mkdir "%LocalAppData%\Hopper"

echo Copying program file to installation directory...
copy /y hopper.exe "%LocalAppData%\Hopper\hopper.exe"

echo Copying uninstaller to installation directory...
copy /y uninstall.bat "%LocalAppData%\Hopper\uninstall.bat"

echo Adding uninstaller to control panel...
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hopper /f /reg:64
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hopper /v "DisplayIcon"                  /d "\"%LocalAppData%\Hopper\hopper.exe\""    /f /reg:64
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hopper /v "DisplayName"                  /d "Hopper"                                  /f /reg:64
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hopper /v "DisplayVersion"               /d "1"                                       /f /reg:64
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hopper /v "EstimatedSize"   /t REG_DWORD /d "8000"                                    /f /reg:64
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hopper /v "InstallLocation"              /d "\"%LocalAppData%\Hopper"                 /f /reg:64
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hopper /v "NoModify"        /t REG_DWORD /d "1"                                       /f /reg:64
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hopper /v "NoRepair"        /t REG_DWORD /d "1"                                       /f /reg:64
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hopper /v "Publisher"                    /d "Dylan Sharhon"                           /f /reg:64
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hopper /v "UninstallString"              /d "\"%LocalAppData%\Hopper\uninstall.bat\"" /f /reg:64

echo Adding to right-click menu for folder icons...
reg add HKCU\SOFTWARE\Classes\Directory\Shell\Hopper                     /ve        /d "Serve at http://localhost/"                   /f /reg:64
reg add HKCU\SOFTWARE\Classes\Directory\Shell\Hopper                     /v  "icon" /d "\"%LocalAppData%\Hopper\hopper.exe\""         /f /reg:64
reg add HKCU\SOFTWARE\Classes\Directory\Shell\Hopper\command             /ve        /d "\"%LocalAppData%\Hopper\hopper.exe\" \"%%1\"" /f /reg:64

::echo Adding to right-click menu for folder backgrounds...
reg add HKCU\SOFTWARE\Classes\Directory\Background\Shell\Hopper          /ve       /d "Serve at http://localhost/"                    /f /reg:64
reg add HKCU\SOFTWARE\Classes\Directory\Background\Shell\Hopper          /v "icon" /d "\"%LocalAppData%\Hopper\hopper.exe\""          /f /reg:64
reg add HKCU\SOFTWARE\Classes\Directory\Background\Shell\Hopper\command  /ve       /d "\"%LocalAppData%\Hopper\hopper.exe\" \"%%V\""  /f /reg:64

:cleanup
echo Removing installer temp directory...
start cmd /q /c rd /s /q "%%temp%%\Hopper"

::REG ADD [ROOT\]RegKey /V ValueName [/T DataType] [/S Separator] [/D Data] [/F] [/reg:32] [/reg:64]
::REG ADD [ROOT\]RegKey /VE [/d Data] [/F] [/reg:32 | /reg:64]
