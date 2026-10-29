@echo off
echo ============================================================
echo   SSH SOCKS5 Proxy  -  administrator@192.168.40.64
echo   Local SOCKS5 listen: 127.0.0.1:1080
echo   Keep this window open. Press Ctrl+C to stop.
echo ============================================================
echo.
echo Connecting to 192.168.40.64, please enter password when prompted...
echo.
"C:\Program Files\Git\usr\bin\ssh.exe" -N -D 127.0.0.1:1080 administrator@192.168.40.64
echo.
echo Proxy stopped.
pause
