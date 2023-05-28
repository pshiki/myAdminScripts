taskkill /F /IM spoolsv.exe
TIMEOUT /T 4 /NOBREAK
start %SYSTEMROOT%\System32\spoolsv.exe
net stop Spooler
TIMEOUT /T 2 /NOBREAK
net start Spooler
TIMEOUT /T 4 /NOBREAK
exit