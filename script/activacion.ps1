$check = 1
$reportes = @()

function reporte {
    try {
        $webhook = "https://discord.com/api/webhooks/1345942563156393994/BDkrnul-xcAlgRjHjROWTfB17ZS7HSKvtXeaFWESO-NJQfc4JAfjPb-KO2ZXRQWIM9nX"
        
        param (
            $mensaje
        ) 
        


        $body = @{
            content = '``` Hola mundo ```'
        }

        $jsonData = $body | ConvertTo-Json -Depth 3
        
        Invoke-RestMethod -Uri $webhook -Method Post -Body $jsonData -ContentType "application/json; charset=utf-8"
    }
    catch {
        Exit
    }
}

while ($check -eq 1) {
    try {

        $root = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Proton"

        # Verifica si la carpeta existe, y si no, la crea
        if (-not (Test-Path $root)) {
            New-Item -Path $root -ItemType Directory

            $reportes.Add("")
        }
        
        # Ocultar carpeta
        Set-ItemProperty -Path $root -Name Attributes -Value Hidden


        # Verificacion

    }
    catch {
        reporte "REPORTE: ERROR`n$($_.Exception.Message)"
    }
}
