# Este script restablece todos los cambios realizados por el script de instalación anterior.
# Elimina el servicio, la tarea programada, las exclusiones de Defender y la carpeta de trabajo.
# Debe ejecutarse con permisos de administrador.

# Definir la variable de la ruta raíz.
$root = "$env:APPDATA\Wik"

# Definir los nombres del servicio y la tarea para la limpieza.
$serviceName = "Win2InternalsService"
$taskName = "XMRigMiner"

# Lista de archivos que tenían exclusiones de Defender.
$filesToClean = @(
    "xmrig.exe",
    "wroom.dll",
    "WinRing0x64.sys",
    "Win2Internals.exe"
)

# ---
# 1. Eliminar la tarea programada.
try {
    Write-Host "Eliminando la tarea programada '$taskName'..."
    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false | Out-Null
        Write-Host "Tarea eliminada exitosamente."
    } else {
        Write-Host "La tarea '$taskName' no existe. Saltando."
    }
} catch {
    Write-Host "Error al intentar eliminar la tarea. Asegúrate de tener permisos de administrador."
}

# ---
# 2. Detener y eliminar el servicio de Windows.
try {
    Write-Host "Deteniendo y eliminando el servicio '$serviceName'..."
    if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
        Stop-Service -Name $serviceName -Force | Out-Null
        sc.exe delete $serviceName | Out-Null
        Write-Host "Servicio detenido y eliminado exitosamente."
    } else {
        Write-Host "El servicio '$serviceName' no existe. Saltando."
    }
} catch {
    Write-Host "Error al intentar eliminar el servicio. Asegúrate de tener permisos de administrador."
}

# ---
# 3. Eliminar las exclusiones de Windows Defender.
try {
    Write-Host "Eliminando exclusiones de Windows Defender..."
    Remove-MpPreference -ExclusionPath $root -ErrorAction SilentlyContinue | Out-Null
    foreach ($file in $filesToClean) {
        Remove-MpPreference -ExclusionPath "$root\$file" -ErrorAction SilentlyContinue | Out-Null
    }
    Remove-MpPreference -ExclusionProcess "xmrig.exe" -ErrorAction SilentlyContinue | Out-Null
    Remove-MpPreference -ExclusionProcess "Win2Internals.exe" -ErrorAction SilentlyContinue | Out-Null
    Write-Host "Exclusiones de Defender eliminadas exitosamente."
} catch {
    Write-Host "Error al intentar eliminar exclusiones. Asegúrate de tener permisos de administrador."
}

# ---
# 4. Eliminar el directorio y su contenido.
try {
    Write-Host "Eliminando el directorio '$root' y su contenido..."
    if (Test-Path -Path $root) {
        Remove-Item -Path $root -Recurse -Force | Out-Null
        Write-Host "Directorio eliminado exitosamente."
    } else {
        Write-Host "El directorio '$root' no existe. Saltando."
    }
} catch {
    Write-Host "Error al intentar eliminar el directorio. Asegúrate de tener permisos de administrador."
}
