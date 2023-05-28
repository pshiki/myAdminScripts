@echo off

set source="D:\1CBASE\v7"
set destination="\\dc-002\1CBase_NEW"
set passwd="Password"
set dd=%DATE:~0,2%
set mm=%DATE:~3,2%
set yyyy=%DATE:~6,4%
set curdate=%yyyy%-%mm%-%dd%

"C:\Program Files\7-Zip\7zG.exe" a -tzip -ssw -mx1 -r0 %destination%\v7_%curdate%.zip %source%