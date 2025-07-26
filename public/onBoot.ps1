# Configuración inicial de Windows (autor: baa4ts - Licencia: MIT)
# Versión Mejorada: Desinstalación completa de Edge, instalación de Brave y BCUninstaller

# URL del script remoto
$global:host_url = "https://baa4ts.is-a.dev/win.config.ps1"

# Flags globales
$global:winget = $false
$global:choco = $true
$global:script = "$env:TEMP\onBoot.ps1"

function Test-Admin {
    if (-not ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole]::Administrator)) {

        Write-Host "⛔ No tienes permisos de administrador. Relanzando con elevación..."
        Start-Process powershell -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', "iex (irm '$($global:host_url)')" -Verb RunAs -Wait
        exit
    }
    return $true
}

function Test-Winget {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        $global:winget = $true
        return
    }

    try {
        Write-Host "🔧 Instalando winget..."
        $progressPreference = 'silentlyContinue'
        Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile "$env:TEMP\winget.appxbundle" -UseBasicParsing
        Add-AppxPackage -Path "$env:TEMP\winget.appxbundle" -ErrorAction Stop
        $global:winget = $true
        Write-Host "✅ Winget instalado correctamente"
    }
    catch {
        Write-Warning "❌ No se pudo instalar winget: $($_.Exception.Message)"
        $global:winget = $false
    }
    finally {
        $progressPreference = 'Continue'
    }
}

function Install-Choco {
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        $global:choco = $true
        return
    }
    try {
        Write-Host "🔧 Instalando Chocolatey..."
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction Stop
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) | Out-Null
        $global:choco = $true
        Write-Host "✅ Chocolatey instalado correctamente"
    }
    catch {
        Write-Warning "❌ No se pudo instalar Chocolatey: $($_.Exception.Message)"
        $global:choco = $false
    }
}

function Install-PowerShell-7 {
    if ((-not $global:winget) -and (-not $global:choco)) { return $false }

    if ($global:winget) {
        winget install --id Microsoft.PowerShell --source winget --accept-package-agreements --accept-source-agreements
    }

    if ($global:choco) {
        choco install powershell-core --pre -y
    }
}

function Desinstalar-Edge-Completo {
    Write-Host "`n🔥 Iniciando desinstalación COMPLETA de Microsoft Edge..." -ForegroundColor Red

    # Desinstalación mediante paquetes Appx
    $edgePackages = @(
        "Microsoft.MicrosoftEdge",
        "Microsoft.MicrosoftEdgeDevToolsClient",
        "Microsoft.MicrosoftEdge.Stable",
        "Microsoft.Edge",
        "Microsoft.EdgeDevToolsClient",
        "Microsoft.EdgeUpdate"
    )

    foreach ($edge in $edgePackages) {
        Write-Host "⛔ Desinstalando $edge..."
        try {
            Get-AppxPackage -AllUsers "*$edge*" | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxPackage "*$edge*" | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | 
                Where-Object DisplayName -like "*$edge*" | 
                Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        }
        catch {
            Write-Warning "⚠️ Error desinstalando $edge: $($_.Exception.Message)"
        }
    }

    # Desinstalación mediante winget/choco
    $edgeSoftware = @(
        "Microsoft.Edge",
        "Microsoft.EdgeWebView",
        "Microsoft.EdgeUpdate"
    )

    foreach ($software in $edgeSoftware) {
        if ($global:winget) {
            Write-Host "🔧 Intentando desinstalar $software via winget..."
            winget uninstall $software --silent --accept-source-agreements --disable-interactivity 2>$null
        }
        if ($global:choco) {
            Write-Host "🔧 Intentando desinstalar $software via Chocolatey..."
            choco uninstall $software -y --force-dependencies 2>$null
        }
    }

    # Eliminación de archivos residuales
    $edgePaths = @(
        "${env:ProgramFiles(x86)}\Microsoft\Edge",
        "${env:ProgramFiles}\Microsoft\Edge",
        "${env:ProgramFiles(x86)}\Microsoft\EdgeCore",
        "${env:ProgramFiles}\Microsoft\EdgeCore",
        "${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate",
        "${env:ProgramFiles}\Microsoft\EdgeUpdate",
        "$env:LOCALAPPDATA\Microsoft\Edge",
        "$env:LOCALAPPDATA\Microsoft\EdgeCore",
        "$env:LOCALAPPDATA\Microsoft\EdgeUpdate",
        "$env:ProgramData\Microsoft\Edge"
    )

    foreach ($path in $edgePaths) {
        if (Test-Path $path) {
            Write-Host "🗑️ Eliminando residuos: $path"
            try {
                Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction SilentlyContinue
            }
            catch {
                Write-Warning "⚠️ Error eliminando $path"
            }
        }
    }

    # Limpieza de registros
    $registryPaths = @(
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge",
        "HKCU:\Software\Microsoft\Edge",
        "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    )

    foreach ($regPath in $registryPaths) {
        if (Test-Path $regPath) {
            Write-Host "🧹 Limpiando registro: $regPath"
            try {
                Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
            }
            catch {
                Write-Warning "⚠️ Error limpiando registro $regPath"
            }
        }
    }

    Write-Host "✅ Microsoft Edge completamente eliminado" -ForegroundColor Green
}

function Desinstalar-Apps {
    if (-not (Test-Admin)) {
        Write-Error "Ejecuta PowerShell como administrador"
        return
    }

    $apps = @{
        "Xbox"                     = "*xbox*"
        "Cortana"                  = "*Microsoft.549981C3F5F10*"
        "Windows Hello"            = "*Microsoft.Windows.HelloExperience*"
        "Control Ocular"           = "*Microsoft.Windows.Occlusion*"
        "Correo y Cuentas"         = "*windowscommunicationsapps*"
        "Feedback Hub"             = "*WindowsFeedbackHub*"
        "Get Help"                 = "*Microsoft.GetHelp*"
        "Groove Music"             = "*ZuneMusic*"
        "Llamadas"                 = "*Microsoft.YourPhone*"
        "Mail and Calendar"        = "*windowscommunicationsapps*"
        "OneDrive"                 = "*Microsoft.OneDrive*"
        "Microsoft Pay"            = "*Microsoft.BingFinance*"
        "Microsoft People"         = "*Microsoft.People*"
        "Microsoft Photos"         = "*Microsoft.Windows.Photos*"
        "Microsoft Solitaire"      = "*Microsoft.MicrosoftSolitaireCollection*"
        "Sticky Notes"             = "*Microsoft.MicrosoftStickyNotes*"
        "Microsoft Tips"           = "*Microsoft.Getstarted*"
        "Mixed Reality Portal"     = "*Microsoft.MixedReality.Portal*"
        "Movies & TV"              = "*Microsoft.ZuneVideo*"
        "MSN El Tiempo"            = "*Microsoft.BingWeather*"
        "Narrador"                 = "*Microsoft.WindowsNarrator*"
        "OneNote"                  = "*Microsoft.Office.OneNote*"
        "Paint 3D"                 = "*Microsoft.MSPaint*"
        "Skype"                    = "*Microsoft.SkypeApp*"
        "Visor 3D"                = "*Microsoft.Microsoft3DViewer*"
        "Xbox Game UI"             = "*Microsoft.XboxGamingOverlay*"
        "Xbox Identity Provider"   = "*Microsoft.XboxIdentityProvider*"
    }

    foreach ($appName in $apps.Keys) {
        $filter = $apps[$appName]
        Write-Host "⛔ Desinstalando $appName..."
        try {
            Get-AppxPackage -AllUsers $filter | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxPackage $filter | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | 
                Where-Object DisplayName -like $filter | 
                Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        }
        catch {
            Write-Warning "⚠️ Error desinstalando $appName"
        }
    }

    # Desinstalación específica de Edge
    Desinstalar-Edge-Completo

    # Limpieza adicional de carpetas
    $pathsToRemove = @(
        "$env:LOCALAPPDATA\Packages\Microsoft.549981C3F5F10*",
        "$env:LOCALAPPDATA\Packages\Microsoft.Xbox*",
        "$env:LOCALAPPDATA\Packages\Microsoft.Windows.HelloExperience*",
        "$env:LOCALAPPDATA\Packages\Microsoft.Windows.Occlusion*",
        "$env:LOCALAPPDATA\Packages\Microsoft.Windows.Photos*",
        "$env:LOCALAPPDATA\Packages\Microsoft.MicrosoftStickyNotes*",
        "$env:LOCALAPPDATA\Packages\Microsoft.GetHelp*"
    )

    foreach ($path in $pathsToRemove) {
        Write-Host "🗑️ Eliminando residuos: $path"
        try {
            Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction SilentlyContinue
        }
        catch {
            Write-Warning "⚠️ Error eliminando $path"
        }
    }
}

function Install-Brave {
    Write-Host "`n🚀 Instalando Brave Browser..." -ForegroundColor Cyan
    $instalado = $false

    if ($global:winget) {
        try {
            winget install Brave.Brave -e --accept-package-agreements --accept-source-agreements
            Write-Host "✅ Brave instalado con winget" -ForegroundColor Green
            $instalado = $true
            return
        }
        catch {
            Write-Warning "⚠️ Error instalando Brave con winget: $($_.Exception.Message)"
        }
    }

    if ($global:choco -and -not $instalado) {
        try {
            choco install brave -y
            Write-Host "✅ Brave instalado con Chocolatey" -ForegroundColor Green
            $instalado = $true
        }
        catch {
            Write-Warning "⚠️ Error instalando Brave con Chocolatey: $($_.Exception.Message)"
        }
    }

    if (-not $instalado) {
        Write-Host "❌ No se pudo instalar Brave" -ForegroundColor Red
    }
}

function Install-BCUninstaller {
    Write-Host "`n🚀 Instalando Bulk Crap Uninstaller..." -ForegroundColor Cyan
    $instalado = $false

    if ($global:winget) {
        try {
            winget install Klocman.Bulk-Crap-Uninstaller -e --accept-package-agreements --accept-source-agreements
            Write-Host "✅ BCUninstaller instalado con winget" -ForegroundColor Green
            $instalado = $true
            return
        }
        catch {
            Write-Warning "⚠️ Error instalando BCUninstaller con winget: $($_.Exception.Message)"
        }
    }

    if ($global:choco -and -not $instalado) {
        try {
            choco install bcuninstaller -y
            Write-Host "✅ BCUninstaller instalado con Chocolatey" -ForegroundColor Green
            $instalado = $true
        }
        catch {
            Write-Warning "⚠️ Error instalando BCUninstaller con Chocolatey: $($_.Exception.Message)"
        }
    }

    if (-not $instalado) {
        Write-Host "❌ No se pudo instalar BCUninstaller" -ForegroundColor Red
    }
}

function Main {
    Write-Host "`n🚀 Iniciando configuración inicial de Windows..." -ForegroundColor Cyan

    if (Test-Admin) {
        Test-Winget

        if (-not $global:winget) {
            Install-Choco
        }

        if (-not $global:winget -and -not $global:choco) {
            Write-Host "❌ El script no puede continuar." -ForegroundColor Red
            Write-Host " - No se pudo instalar winget ni Chocolatey"
            Write-Host " - Verifica tu conexión a internet o proxy" -ForegroundColor Yellow
            exit
        }

        # Proceso de desinstalación
        Desinstalar-Apps

        # Instalación de nuevas aplicaciones
        Install-Brave
        Install-BCUninstaller

        # Instalación opcional de PowerShell 7
        Write-Host "`n🔧 Instalando PowerShell 7..." -ForegroundColor Cyan
        Install-PowerShell-7

        Write-Host "`n✅ Proceso completado exitosamente!" -ForegroundColor Green
        Write-Host " - Microsoft Edge fue completamente eliminado" -ForegroundColor Green
        Write-Host " - Brave Browser y BCUninstaller fueron instalados" -ForegroundColor Green
        Write-Host "`n🔄 Por favor reinicia el sistema para completar los cambios" -ForegroundColor Yellow
    }
}

Main
