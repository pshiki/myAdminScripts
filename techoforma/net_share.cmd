@echo off
chcp 866 > null
net share 1CBase_technoforma /delete /yes
net share 1CBase_technoforma=D:\1CBase_technoforma /GRANT:"satko\technoformaBUH",FULL
@echo on
exit /b
