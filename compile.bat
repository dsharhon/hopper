@echo off

pyinstaller -y --clean -F --distpath . --add-data hopper.ico:. -i hopper.ico hopper.pyw
rd /s /q build
del hopper.spec
pause