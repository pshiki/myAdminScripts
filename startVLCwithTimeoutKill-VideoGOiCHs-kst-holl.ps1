Set-Location "C:\Program Files\VideoLAN\VLC"
[string]$way="C:\video\goichs-2019\2019-02.mkv"
[string]$way2="C:\Users\tv\Desktop\mosobr-tv-good.m3u"
[string]$par="--fullscreen"
Stop-Process -processname vlc
./vlc.exe $way $par
powershell -windowstyle Minimized TIMEOUT /T 1235
Stop-Process -processname vlc
./vlc.exe $way2 $par
exit
