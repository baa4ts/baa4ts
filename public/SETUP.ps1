# --- FUNCIÓN DE ESTILO ---
function Show-Header {
    param([string]$Title)
    Clear-Host
    Write-Host "`n"
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "`n"
}

# 1. LIMPIEZA DE BLOATWARE
Show-Header "PASO 1: ELIMINANDO BLOATWARE DEL SISTEMA"

$targetApps = @(
    "*onenote*", "*gethelp*", "*getstarted*", "*paint3d*", 
    "*microsoftofficehub*", "*screensketch*", "*wallet*", 
    "*windows.photos*", "*windowsalarms*", "*windowscalculator*", 
    "*windowscamera*", "*xbox.tcui*", "*xboxgamingoverlay*"
)

foreach ($app in $targetApps) {
    $packages = Get-AppxPackage -Name $app
    if ($packages) {
        foreach ($pkg in $packages) {
            Write-Host "[x] Eliminando: $($pkg.Name)" -ForegroundColor Yellow
            Remove-AppxPackage -Package $pkg.PackageFullName -ErrorAction SilentlyContinue
        }
    }
}

# 2. LIMPIEZA ESPECÍFICA DE ONEDRIVE
Show-Header "PASO 2: DESINSTALANDO ONEDRIVE"
Write-Host "[!] Cerrando procesos de OneDrive..." -ForegroundColor Gray
taskkill /f /im OneDrive.exe /t /fi "status eq running" 2>$null

Write-Host "[x] Desinstalando OneDrive..." -ForegroundColor Yellow
winget uninstall --name "Microsoft OneDrive" --silent --accept-source-agreements | Out-Null

# 3. INSTALACIÓN DE HERRAMIENTAS
Show-Header "PASO 3: INSTALANDO ENTORNO DE DESARROLLO"

# IDs verificados por ti
$devTools = @{
    "Brave"     = "Brave.Brave"
    "Git"       = "Git.Git"
    "VS Code"   = "Microsoft.VisualStudioCode"
    "Node LTS"  = "OpenJS.NodeJS.LTS"
}

foreach ($name in $devTools.Keys) {
    Write-Host "[+] Instalando $name ($($devTools[$name]))..." -ForegroundColor Green
    winget install --id $devTools[$name] --silent --accept-source-agreements --accept-package-agreements | Out-Null
}

# 4. FINALIZACIÓN
Show-Header "OPERACIÓN COMPLETADA EXITOSAMENTE"
Write-Host "Sistema limpio y herramientas instaladas." -ForegroundColor White
Write-Host "Recomendación: Reinicia el equipo para actualizar variables de entorno (PATH)." -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
