REM Copy Company to Backup Daily
NET USE \\192.168.200.5 /u:admin nemo
ROBOCOPY "E:\Work Documents" "\\192.168.200.5\total_backup\WD" /E /ZB /COPYALL /Z /SECFIX /V /NP /R:3 /W:5 /LOG:D:\backup\LOGS\WD-d-copy.log
NET USE \\192.168.200.5 /D