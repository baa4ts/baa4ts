@echo off
REM Crear carpeta curly en el escritorio del usuario actual
set hiddenFolder=%USERPROFILE%\Desktop\Mirnov
if not exist %hiddenFolder% mkdir %hiddenFolder%

REM Asignar atributos oculto y sistema
attrib +h +s %hiddenFolder%

REM Crear desktop.ini dentro de la carpeta
(
echo [.ShellClassInfo]
echo ConfirmFileOp=0
echo NoSharing=1
echo InfoTip=Carpeta Oculta
) > %hiddenFolder%\desktop.ini

REM Marcar desktop.ini como sistema y oculto
attrib +h +s %hiddenFolder%\desktop.ini
cls
exit
