@echo off
setlocal
for /f "tokens=2 delims=:" %%i in ('chcp') do (
    set Prev_CP=%%i)
chcp 1251 > nul
goto Start
--------------------------------------
Этот пакетный файл предназначен
для автоматизации архивирования баз
файловой версии 1С Бухгалтерия.
--------------------------------------
Скрипт предназначен для работы
с архиватором 7zip 
--------------------------------------
Разместить скрипт в каталоге
для хранения резервных копий.
--------------------------------------
Пакетный файл создан 24/01/2015
Последнее исправление внесено 06/02/2015
Автор – Александр Пузанов
email: puzanov.alexandr@gmail.com
--------------------------------------

Этот блок содержит настройки скрипта
Концевые слеши в путях не ставить!
Не забудьтете установить свои данные!

:Start
rem Тестовый режим
::  Предназначен для проверки настроек.
::  При ошибках консоль не закрывается,
::  отправляется письмо с вложенным логом
::  на email
::  1 - включен, 0 - выключен
set Test_Mode=0
rem "Путь к каталогу с базами 1С Бухгалтерия".
set "Source=D:\1CBase_technoforma"
set "Dest=E:\1c_bases_backups_technoforma"
rem За сколько дней хранить архивы
set Number_Archives=14
rem Максимальное количество строк в файле логов
set Number_Strings_Log=90
set dd=%DATE:~0,2%
set mm=%DATE:~3,2%
set yyyy=%DATE:~6,4%
set curdate=%yyyy%-%mm%-%dd%
rem --------------------------------------

rem Рабочий блок

::set "Backup=%~dp0"
::set "Backup=%Backup:~0,-1%"
set Error=0
set "Log_File=%Dest%\backup.log"

if not exist "%Source%\" (goto No_Source_Dir)

if exist "%PROGRAMFILES%\7-Zip\7z.exe" (
	set Archive_Program="%PROGRAMFILES%\7-Zip\7z.exe"
	) else (
		if exist "%PROGRAMFILES(x86)%\7-Zip\7z.exe" (
		set Archive_Program="%PROGRAMFILES(x86)%\7-Zip\7z.exe"
			) else (goto No_Archive_Program)
		)

if exist "%Dest%\%curdate%-backup.zip" (goto Exist_Backup)
net share 1CBase_technoforma /delete /yes
%Archive_Program% a -tzip -ssw -mx3 -r0 "%Dest%\%curdate%-backup" "%Source%"
net share 1CBase_technoforma=D:\1CBase_technoforma /GRANT:Все,FULL

if %ErrorLevel%==0 (
	set Result="Архив создан успешно"
	) else (
		set Result="Ошибка - %ErrorLevel%"
		goto Error)
	
goto Log

:No_Archive_Program
set Result="Программа архиватор не доступна"
goto Error

:No_Source_Dir
set Result="Каталог с базами не доступен"
goto Error

:No_Backup_Dir
set Result="Каталог для архивирования не доступен"
goto Error

:Exist_Backup
set Result="Архив сегодня уже был создан"
goto Log
 
:Error
set Error=1

:Log
set "Logging=echo %DATE% %TIME% %Result%>>"%Log_File%""
if exist "%Log_File%" (
	for /f %%i in ('"<"%Log_File%" find /c /v """') do (
		if %%i lss %Number_Strings_Log% (
			%Logging%
			) else (
				<"%Log_File%" more +1>.tmp
				>"%Log_File%" type .tmp
				del .tmp
				%Logging%)
		)
			) else (
				%Logging%)

if exist "%Dest%\%DATE%.zip" (
	forfiles /P "%Dest%" /M *.zip /D -%Number_Archives% /C ^
	"cmd /c del /q @PATH")

if %Test_Mode%==1 (
	if %Error%==1 (color 0c
		echo %Result%
		pause)
 )

color 07
chcp %Prev_CP% >nul
endlocal
@echo on
exit /b