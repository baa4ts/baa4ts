$check = true  # Cambia a true para que el bucle se ejecute

function reporte {
    try {
        $webhook = "https://discord.com/api/webhooks/1345942563156393994/BDkrnul-xcAlgRjHjROWTfB17ZS7HSKvtXeaFWESO-NJQfc4JAfjPb-KO2ZXRQWIM9nX"
        
        param (
            $mensaje
        ) 
        
        $body = @{
            content = $mensaje
        }

        Invoke-RestMethod -Uri $webhook -Method Post -Body ($body | ConvertTo-Json) -ContentType "application/json"
    }
    catch {
        Write-Host "Ocurrió un error al enviar el reporte"
        Exit
    }
}

while ($check) {
    try {
        # Define la ruta principal
        $root = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Proton"

        # Verifica si la carpeta existe, y si no, la crea
        if (-not (Test-Path $root)) {
            New-Item -Path $root -ItemType Directory
            reporte "Se creó la carpeta en $root"
        } else {
            reporte "La carpeta ya existe en $root"
        }
    }
    catch {
        reporte "REPORTE: ERROR"
    }
}
