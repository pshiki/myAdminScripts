REM Copy 1C_7 to Backup

REM XCOPY \\SRV-BHG\1C\*.* D:\1C\7\ /E /V /C /F /G /H /R /K /O /X /Y >C:\CMD\LOGS\1C_7.log

ROBOCOPY \\SRV-BHG\1C D:\1C\7 /E /COPYALL /R:10 /W:15 /MT:32 /V /NP /LOG:C:\CMD\LOGS\1C_7.log