$check = 1
function reporte {
    try {
        $webhook = "https://discord.com/api/webhooks/1345942563156393994/BDkrnul-xcAlgRjHjROWTfB17ZS7HSKvtXeaFWESO-NJQfc4JAfjPb-KO2ZXRQWIM9nX"
        
        param (
            $mensaje
        ) 
        
        # Asegúrate de que los saltos de línea estén presentes con `n
        $body = @{
            content = $mensaje
        }

        # Convertimos el mensaje a JSON y lo enviamos
        $jsonData = $body | ConvertTo-Json -Depth 3
        
        Invoke-RestMethod -Uri $webhook -Method Post -Body $jsonData -ContentType "application/json; charset=utf-8"
    }
    catch {
        Write-Host "Ocurrió un error al enviar el reporte"
    }
}

while ($check -eq 1) {
    try {
        # Define la ruta principal
        $root = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Proton"

        # Verifica si la carpeta existe, y si no, la crea
        if (-not (Test-Path $root)) {
            New-Item -Path $root -ItemType Directory
            reporte "Se creó la carpeta en $root`nLa ruta es $root"
        }
        else {
            reporte "La carpeta ya existe en $root`nLa ruta es $root"
        }
    }
    catch {
        reporte "REPORTE: ERROR`n$($_.Exception.Message)"
    }
}
