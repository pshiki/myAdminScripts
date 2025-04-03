:: Скрипт относительно безопасного резервного копирования файловых баз 1С на Windows которые лежат на шаре
:: Автор: кот Матроскин, Шарик и дядя Федор


@echo off
setlocal enabledelayedexpansion
chcp 1251 > nul

set "source=D:\1CBase_technoforma"
set "dest=E:\1c_bases_backups_technoforma"
set Number_Archives=6
set dd=%DATE:~0,2%
set mm=%DATE:~3,2%
set yyyy=%DATE:~6,4%
set curdate=%yyyy%-%mm%-%dd%
set "Log_File=%dest%\backup.log"
set "shareName=1CBase_technoforma"
set "domainGroupAccess=satko\technoformaBUH"

echo ------ >> %Log_File%
echo %curdate% - start backup script >> %Log_File%
echo ------ >> %Log_File%

echo start script workins

goto disallowUserNetworkAccess

:disallowUserNetworkAccess
echo start disable share
net share %shareName% /delete /yes >> %Log_File% 2>&1
if !errorlevel! equ 0 (
    timeout /nobreak /t 5 >nul
	echo [%curdate%] disable share DB is complete successfully >> "%Log_File%"
	goto startBackupDB
) else (
    echo [%curdate%] disable share DB is complete unsuccessfully >> "%Log_File%"
	echo [%curdate%] error creating backup, error: !errorlevel! >> "%Log_File%"
	goto emergyExit 
)

:startBackupDB
echo start backup 1c base
"%PROGRAMFILES%\7-Zip\7z.exe" a -tzip -ssw -mx3 -r0 "%dest%\%curdate%-backup" "%source%"
if !errorlevel! equ 0 (
    timeout /nobreak /t 5 >nul
	echo [%curdate%] backup base complete successfully >> "%Log_File%"
    goto rmOldBackups
) else (
    echo [%curdate%] error creating backup, error: !errorlevel! >> "%Log_File%"
	goto allowUserNetworkAccess
)

:rmOldBackups
echo start remove old backups
forfiles /P "%dest%" /M "*.zip" /D -%Number_Archives% /C "cmd /c del /q @PATH"
echo [%curdate%] backups older than %Number_Archives% days has been deleted >> "%Log_File%"
goto allowUserNetworkAccess

:allowUserNetworkAccess
echo start enable share
net share %shareName%=%source% /GRANT:"%domainGroupAccess%",FULL >> %Log_File% 2>&1
if !errorlevel! equ 0 (
    timeout /nobreak /t 5 >nul
	echo [%curdate%] enable share DB is complete successfully >> "%Log_File%"
	goto emergyExit
) else (
    echo [%curdate%] enable share DB is complete unsuccessfully >> "%Log_File%"
    goto emergyExit
)

:emergyExit
echo Emergy Exiting
exit /b