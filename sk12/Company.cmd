REM Copy Company to Backup Daily

REM XCOPY \\5-SRV-DSK\Company\*.* D:\New_Company /D /E /V /C /F /G /H /R /K /O /X /Y >C:\CMD\LOGS\Company_daily.log

ROBOCOPY \\5-SRV-DSK\Company D:\Company /E /COPYALL /XA:SH /R:10 /W:15 /MT:32 /V /NP /LOG:C:\CMD\LOGS\Company.log

REM ROBOCOPY \\5-SRV-DSK\Company D:\Company /E /COPYALL /PURGE /XA:SH /R:10 /W:15 /MT:32 /V /NP /LOG:C:\CMD\LOGS\Company.log