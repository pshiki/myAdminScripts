Посмотреть информацию по пользователям из AD
Get-ADUser
-server домен
-identity логин
-properties displayName (полное имя)
-properties EmailAddress (вывести почту)
-properties lockedOut (блокировка)
-properties memberof | select memberof -expandproperty memberof   (вывести группы)

if ($(Get-ADUser -Identity логин -server домен -Properties lockedout).LockedOut -eq $true){echo "user is locked"}

GREP в PS = ... | Select-String -Pattern cab

Проверка по AD на блокировку пользователей (PowerShell):
Import-Csv C:\Users\__\users-test.csv | ForEach-Object {if ($(Get-ADUser -Identity $_.user_cred -server логин -Properties lockedout).LockedOut -eq $true){echo "$_.user_cred is locked"}}
csv файл в формате:
"user_cred"
"login1"
"login2"