@echo off
D:
cd D:\backup\

set day=%DATE:~0,2%
set month=%DATE:~3,2%
set year=%DATE:~6,4%

set /a ttt=%TIME:~0,2%
set minute=%TIME:~3,2%
set second=%TIME:~6,2%

if %ttt% LSS 10 (
set hour=0%ttt%) else (
set hour=%ttt%)

set logfilename=%year%-%month%-%day%_%hour%-%minute%-%second%_backup.log

call D:\backup\work.bat>D:\backup\_log\%logfilename%

2>nul forfiles /p «D:\backup\_log» /d -31 /c «cmd /c del /f /q @file»