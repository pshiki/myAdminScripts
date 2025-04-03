@echo off
chcp 437 > null
set "Source=D:\1CBase_technoforma"
set "Dest=E:\1c_bases_backups_technoforma"
set Number_Archives=6
set dd=%DATE:~0,2%
set mm=%DATE:~3,2%
set yyyy=%DATE:~6,4%
set curdate=%yyyy%-%mm%-%dd%
set "Log_File=%Dest%\backup.log"

echo ------ >> %Log_File%
echo %curdate% - start backup >> %Log_File%
net share 1CBase_technoforma /delete /yes >> %Log_File% 2>&1
"%PROGRAMFILES%\7-Zip\7z.exe" a -tzip -ssw -mx3 -r0 "%Dest%\%curdate%-backup" "%Source%" >> %Log_File% 2>&1
net share 1CBase_technoforma=D:\1CBase_technoforma /GRANT:"satko\technoformaBUH",FULL >> %Log_File% 2>&1

forfiles /P "%Dest%" /M "*.zip" /D -%Number_Archives% /C "cmd /c del /q @PATH"

@echo on
exit /b