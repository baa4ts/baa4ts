$hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"
Copy-Item $hostsFile "$hostsFile.bak" -Force

$dominios = @(
"storeedgefd.dsx.mp.microsoft.com","displaycatalog.mp.microsoft.com","download.microsoft.com","officecdn.microsoft.com","ctldl.windowsupdate.com","fe3.delivery.mp.microsoft.com","www.microsoft.com",
"www.php.net","windows.php.net","www.apachefriends.org","sourceforge.net","www.laragon.org","localhost","localhost/phpmyadmin","localhost/xampp","localhost/laragon",
"chatgpt.com","www.chatgpt.com","gemini.ai","deepseek.ai","venice.ai","openai.com","api.openai.com","chat.openai.com","bard.google.com","bard.google.co","claude.ai","anthropic.com","cohere.ai","perplexity.ai","you.com","huggingface.co","deepmind.com","replika.ai","writesonic.com","copy.ai","jasper.ai","synthesia.io","midjourney.com","runwayml.com","stability.ai","elevenlabs.io","tome.app","phind.com","notion.ai","humata.ai",
"steamcommunity.com","store.steampowered.com","discord.com","www.discord.com","pokerogue.net",
"itch.io","www.itch.io","g2g.com","www.g2g.com","eneba.com","www.eneba.com"
)

foreach ($dom in $dominios) {
    $dom = $dom.Trim()
    if ($dom -ne "") {
        $entry = "127.0.0.1 `t$dom"
        if (-not (Select-String -Path "$hostsFile" -Pattern ([regex]::Escape($dom)))) {
            Add-Content -Path "$hostsFile" -Value $entry
        }
    }
}
