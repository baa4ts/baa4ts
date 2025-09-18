$hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"
Copy-Item $hostsFile "$hostsFile.bak" -Force -ErrorAction SilentlyContinue

$dominios = @(
    # Microsoft / Windows
    "storeedgefd.dsx.mp.microsoft.com",
    "displaycatalog.mp.microsoft.com",
    "download.microsoft.com",
    "officecdn.microsoft.com",
    "ctldl.windowsupdate.com",
    "fe3.delivery.mp.microsoft.com",
    "www.microsoft.com",

    # PHP / Frameworks
    "www.php.net",
    "windows.php.net",
    "www.apachefriends.org",
    "www.laragon.org",
    "www.laravel.com",
    "symfony.com",

    # Localhost (dev)
    "localhost",
    "localhost/phpmyadmin",
    "localhost/xampp",
    "localhost/laragon",

    # IA / Chatbots / APIs
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

    # Juegos / Plataformas / Steam
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

    # Seguridad / Antivirus
    "malwarebytes.com",
    "www.malwarebytes.com"
)


foreach ($dom in $dominios) {
    $dom = $dom.Trim()
    if ($dom -ne "") {
        $entry = "127.0.0.1 `t$dom"
        try {
            if (-not (Select-String -Path "$hostsFile" -Pattern ([regex]::Escape($dom)) -Quiet)) {
                Add-Content -Path "$hostsFile" -Value $entry
            }
        } catch {}
    }
}


# Limpiar historial de Ejecutar (Win + R)
$runKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"

if (Test-Path $runKey) {
    # Eliminar todas las entradas del historial
    Get-ItemProperty -Path $runKey | ForEach-Object {
        $_.PSObject.Properties | Where-Object { $_.Name -match "^[a-z]$" } | ForEach-Object {
            Remove-ItemProperty -Path $runKey -Name $_.Name -ErrorAction SilentlyContinue
        }
    }
}
