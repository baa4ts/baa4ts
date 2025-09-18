# Definir ruta del hosts
$hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"

# Crear backup
Try {
    Copy-Item $hostsFile "$hostsFile.bak" -Force
} Catch {
    Write-Warning "No se pudo crear backup del hosts. Ejecuta como administrador."
}

# Lista de dominios
$dominios = @(
    "storeedgefd.dsx.mp.microsoft.com",
    "displaycatalog.mp.microsoft.com",
    "download.microsoft.com",
    "officecdn.microsoft.com",
    "ctldl.windowsupdate.com",
    "fe3.delivery.mp.microsoft.com",
    "www.microsoft.com",
    "www.php.net",
    "windows.php.net",
    "www.apachefriends.org",
    "www.laragon.org",
    "www.laravel.com",
    "symfony.com",
    "localhost/phpmyadmin",
    "localhost/xampp",
    "localhost/laragon",
    "chatgpt.com",
    "www.chatgpt.com",
    "gemini.ai",
    "deepseek.ai",
    "venice.ai",
    "openai.com",
    "api.openai.com",
    "chat.openai.com",
    "bard.google.com",
    "bard.google.co",
    "claude.ai",
    "anthropic.com",
    "cohere.ai",
    "perplexity.ai",
    "you.com",
    "huggingface.co",
    "deepmind.com",
    "replika.ai",
    "writesonic.com",
    "copy.ai",
    "jasper.ai",
    "synthesia.io",
    "midjourney.com",
    "runwayml.com",
    "stability.ai",
    "elevenlabs.io",
    "tome.app",
    "phind.com",
    "notion.ai",
    "humata.ai",
    "steamcommunity.com",
    "store.steampowered.com",
    "discord.com",
    "www.discord.com",
    "pokerogue.net",
    "itch.io",
    "www.itch.io",
    "g2g.com",
    "www.g2g.com",
    "eneba.com",
    "www.eneba.com",
    "malwarebytes.com",
    "www.malwarebytes.com"
)

# Añadir entradas al hosts
foreach ($dom in $dominios) {
    $dom = $dom.Trim()
    if ($dom -ne "") {
        $entry = "127.0.0.1`t$dom"
        Try {
            if (-not (Select-String -Path $hostsFile -Pattern ([regex]::Escape($dom)) -Quiet)) {
                Add-Content -Path $hostsFile -Value $entry
            }
        } Catch {
            Write-Warning "No se pudo agregar $dom al hosts. Ejecuta como administrador."
        }
    }
}

# Limpiar historial de Ejecutar (Win + R)
$runKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
if (Test-Path $runKey) {
    Try {
        Get-ItemProperty -Path $runKey | ForEach-Object {
            $_.PSObject.Properties | Where-Object { $_.MemberType -eq 'NoteProperty' -and $_.Name -match '^[a-z]$' } | ForEach-Object {
                Remove-ItemProperty -Path $runKey -Name $_.Name -ErrorAction SilentlyContinue
            }
        }
    } Catch {
        Write-Warning "No se pudo limpiar el historial de Ejecutar."
    }
}

Write-Host "Script ejecutado correctamente."

$historyFile = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

if (Test-Path $historyFile) {
    Remove-Item $historyFile -Force
    Write-Host "Historial persistente eliminado."
} else {
    Write-Host "No se encontró historial persistente."
}
