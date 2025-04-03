REM Copy ADM to Backup Daily
NET USE \\192.168.200.5 /u:admin nemo
ROBOCOPY "D:\ADM" "\\192.168.200.5\total_backup\ADM" /E /ZB /COPYALL /PURGE /Z /SECFIX /V /NP /R:3 /W:5 /LOG:D:\backup\LOGS\ADM-d-copy.log
NET USE \\192.168.200.5 /D