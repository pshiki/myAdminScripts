REM Copy 1C_8 to Backup

REM XCOPY \\SRV-BHG\1c8_2_Base\*.* D:\1C\8\ /E /V /C /F /G /H /R /K /O /X /Y >C:\CMD\LOGS\1C_8.log

ROBOCOPY \\SRV-BHG\1c8_2_Base D:\1C\8 /E /COPYALL /PURGE /R:10 /W:15 /MT:32 /V /NP /LOG:C:\CMD\LOGS\Syn_1C_8.log
