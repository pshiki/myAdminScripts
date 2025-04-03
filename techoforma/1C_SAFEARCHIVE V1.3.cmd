
:: ╔════════════════════════════════╗
:: ║      1C_SafeArchive - v1.3     ║
:: ║                                ║
:: ║  Автор: Кухар Богдан           ║
:: ║  kuharbogdan.com               ║
:: ╚════════════════════════════════╝

:: Скрипт предназначен для безопасного резервного копирования файловых баз 1С на Windows

@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

:: Основные настройки скрипта ══════════════════════════

:: Расположения базы 1C, пользователя в 1С и платформы
set "base_location=C:\base1c"
set "user_name=Абдулов (директор)"
set "user_pass=1234"
set "platforma_1C=C:\Program Files\1cv8\8.3.24.1368\bin\1cv8.exe"


:: Расположение 7z.exe (Установите предварительно 7-Zip)
set "a7z=C:\Program Files\7-Zip\7z.exe"

:: Путь куда делаем бэкап
set "kuda=c:\bak"

:: Название бэкапа базы
set "backup_name=MyBackup"

:: Сколько бэкапов хранить в каталоге, где создаем бэкапы (По умолчанию храним два бэкапа)
set "backup_old=2"

:: Разрешить использовать принудительное завершение процессов 1С командой taskkill после успешного штатного завершения (Можно указать no оставив только штатное).
set "perform_taskkill=yes"

:: Принудительное завершение процессов 1С командой taskkill до штатного завершения процессов 1С (Можно указать yes).
set "taskkill_on=no"

:: Какой процесс завершать принудительно командой taskkill 
set "process_mask=1cv8"

:: ИБ опубликована на веб сервере Apache ? (Если работает веб сервер Apache укзать yes)
set "stop_apache_service=no"

:: Версия веб сервера Apache
set "service_name=Apache2.4"

:: Путь к файлу логов (указать путь)
set "log_file=c:\log_file.txt"

:: ══════════════════════════════════════════════════════════════════════════════════════════

rem Фильтр по имени файла ".1CD"
set "file_filter=*.1CD"

rem Получение текущей даты и времени 
for /f %%a in ('powershell Get-Date -Format "yyyy-MM-dd_HHmm"') do set "current_datetime=%%a"

set "otkuda=%base_location%"

rem Очистим предыдущий лог перед выполнением скрипта
echo. > "%log_file%"

if /i "%taskkill_on%"=="yes" (
    tasklist /V /FI "IMAGENAME eq %process_mask%*" 2>nul | findstr /i "%process_mask%*" > "%log_file%"
    timeout /t 5 /nobreak >nul
    if errorlevel 1 (
        echo [%current_datetime%] Процессы 1С не найдены. >> "%log_file%"
    ) else (
        echo [%current_datetime%] Завершаю процессы 1С командой taskkill >> "%log_file%"
        taskkill /F /T /FI "IMAGENAME eq %process_mask%*" /IM "%process_mask%*" >> "%log_file%"
        timeout /t 5 /nobreak >nul
    )
)

echo Попытка заблокировать вход в базу 1С и вызов штатного завершения сеансов 1С… >> "%log_file%"
"%platforma_1C%" ENTERPRISE /F%base_location% /N"%user_name%" /P"%user_pass%" /WA- /CЗавершитьРаботуПользователей /UCКодРазрешения /DisableStartupMessages /UTF-8 >> "%log_file%" 2>&1

rem Проверка успешности выполнения команды 1C
if !errorlevel! neq 0 (
    echo [%current_datetime%] Команда завершилась с ошибкой. Код завершения: !errorlevel! >> "%log_file%"
    echo [%current_datetime%] Скрипт завершился из-за сбоя выполнения команды. >> "%log_file%"
    goto AllowUserAccess
)

if "%perform_taskkill%"=="yes" (
    set "process_found=false"
    for /f "tokens=2 delims= " %%i in ('tasklist ^| findstr /i "%process_mask%"') do (
        set "process_found=true"
        echo Процесс 1C с PID: "%%i" найден. Завершаем его. >> "%log_file%" 2>&1
        taskkill /F /T /IM "%%i" >> "%log_file%" 2>&1
        timeout /t 5 /nobreak >nul
    )

    if not !process_found! equ true (
        echo Процесс 1C с маской "%process_mask%" не найден. >> "%log_file%" 2>&1
    )
) else (
    echo Опция perform_taskkill установлена в "%perform_taskkill%". Возможные процессы 1С не будут жестко завершены после штатного завершения. >> "%log_file%" 2>&1
)

:: Подождем некоторое время перед созданием резервной копии
timeout /nobreak /t 10 >nul

:: Проверка статуса службы Apache и остановка при необходимости
sc query %service_name% | find "STATE" | find "RUNNING" >nul
set "webserver_running=%errorlevel%"

if /i "%stop_apache_service%"=="yes" (
    if %webserver_running% equ 0 (
        echo [%current_datetime%]  Веб-сервер Apache работает. Остановка... >> "%log_file%"
        net stop %service_name% >> "%log_file%"
        timeout /nobreak /t 10 >nul
        set "webserver_running=yes"
    ) else (
        echo [%current_datetime%]  Веб-сервер Apache не запущен. >> "%log_file%"
    )
)

echo [%current_datetime%] Создаю бэкап... >> "%log_file%"

rem Используем for /r для рекурсивного поиска файлов file_filter в каталоге
for /r "%base_location%" %%i in (%file_filter%) do (
    "%a7z%" a "%kuda%\%backup_name%_%current_datetime%.7z" "%%i" >> "%log_file%" 2>&1
)

rem Проверка успешности создания бэкапа
if !errorlevel! equ 0 (
    rem Удаление более старых бэкапов
    rem Подождем некоторое время перед удалением старых бэкапов
    timeout /nobreak /t 5 >nul
    for /f "skip=%backup_old% eol=: delims=" %%F in ('dir /b /o-d "%kuda%\%backup_name%_*.7z"') do (
        echo Удален старый бэкап: %%F >> "%log_file%"
        del "%kuda%\%%F" >> "%log_file%" 2>&1
    )

    echo [%current_datetime%] Бэкап был успешно создан! >> "%log_file%"
    goto AllowUserAccess
) else (
    echo [%current_datetime%] Создание бэкапа завершилось с ошибкой: !errorlevel! >> "%log_file%"
    echo [%current_datetime%] Скрипт завершился из-за сбоя при создании резервной копии. >> "%log_file%"
    
    rem Удаление неудачного бэкапа
    echo [%current_datetime%] Удаление неудачного бэкапа... >> "%log_file%"
    timeout /nobreak /t 5 >nul
    del "%kuda%\%backup_name%_%current_datetime%.7z" >> "%log_file%" 2>&1
    timeout /nobreak /t 10 >nul
)

:AllowUserAccess
if "%webserver_running%"=="yes" (
    echo [%current_datetime%] Запуск веб сервера... >> "%log_file%"
    net start %service_name% >> "%log_file%"
    timeout /nobreak /t 10 >nul
) else (
    echo [%current_datetime%] ... >> "%log_file%"
)

rem Добавленный код для разрешения входа пользователям
echo [%current_datetime%] Попытка разрешить вход в базу 1С >> "%log_file%"
"%platforma_1C%" ENTERPRISE /F%base_location% /N"%user_name%" /P"%user_pass%" /WA- /CРазрешитьРаботуПользователей /UCКодРазрешения /DisableStartupMessages /UTF-8 >> "%log_file%"
echo [%current_datetime%] Вход в базу 1С разрешен >> "%log_file%"

echo [%current_datetime%] Скрипт завершил работу >> "%log_file%"
goto :eof