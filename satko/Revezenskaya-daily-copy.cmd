REM Copy Revezenskaya to Backup Daily
NET USE \\192.168.200.5 /u:admin nemo
ROBOCOPY "D:\Revezenskaya" "\\192.168.200.5\total_backup\Rev" /E /ZB /COPYALL /PURGE /Z /SECFIX /V /NP /R:3 /W:5 /LOG:D:\backup\LOGS\Rev-d-copy.log
NET USE \\192.168.200.5 /D