REM Copy Company to Backup Daily
NET USE \\192.168.200.5 /u:admin nemo
ROBOCOPY "E:\Work Documents\Проекты" "\\192.168.200.5\total_backup\WD" /E /ZB /COPYALL /SECFIX /R:3 /W:5 /V /TS /FP /ETA /TEE /LOG:D:\backup\LOGS\WD-first-d-copy-projects.log
ROBOCOPY "E:\Work Documents\Проектирование" "\\192.168.200.5\total_backup\WD" /E /ZB /COPYALL /SECFIX /R:3 /W:5 /V /TS /FP /ETA /TEE /LOG:D:\backup\LOGS\WD-first-d-copy-projectirovanie.log
NET USE \\192.168.200.5 /D