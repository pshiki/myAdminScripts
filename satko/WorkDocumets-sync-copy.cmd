REM Copy Company to Backup two week sync
NET USE \\192.168.200.5 /u:admin nemo
ROBOCOPY "E:\Work Documents" "\\192.168.200.5\total_backup\WD" /E /ZB /COPYALL /PURGE /Z /SECFIX /V /NP /R:3 /W:5 /LOG:D:\backup\LOGS\WD-sync.log
NET USE \\192.168.200.5 /D