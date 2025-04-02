$check = 1
$reportes = @()
$webhook = "https://discord.com/api/webhooks/1345942563156393994/BDkrnul-xcAlgRjHjROWTfB17ZS7HSKvtXeaFWESO-NJQfc4JAfjPb-KO2ZXRQWIM9nX"

# Función para enviar reportes a Discord
function Enviar-Reporte {
    param (
        [string]$mensaje
    )

    try {
        # Formato del mensaje para Discord
        $contenido = @"
```
$mensaje
```
"@

        # Cuerpo del mensaje en formato JSON
        $body = @{
            content = $contenido
        } | ConvertTo-Json -Depth 3

        # Envío del mensaje a Discord
        Invoke-RestMethod -Uri $webhook -Method Post -Body $body -ContentType "application/json; charset=utf-8"
    }
    catch {
        # Manejo de errores en el envío a Discord
        Write-Error "Error al enviar reporte a Discord: $($_.Exception.Message)"
    }
}

# Bucle principal para la verificación de la carpeta
while ($check -eq 1) {
    try {
        # Ruta de la carpeta "Proton" en AppData local
        $root = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Proton"

        # Verifica si la carpeta existe
        if (-not (Test-Path $root)) {
            # Crea la carpeta si no existe
            New-Item -Path $root -ItemType Directory
            $reportes += "La carpeta 'Proton' no existía y ha sido creada."
        }

        # Oculta la carpeta
        Set-ItemProperty -Path $root -Name Attributes -Value Hidden
        $reportes += "La carpeta 'Proton' existe o ha sido creada y oculta."

        # Envía todos los reportes acumulados a Discord
        if ($reportes.Count -gt 0) {
            $reportes | ForEach-Object { Enviar-Reporte -mensaje $_ }
            $reportes = @() # Limpia el array de reportes después de enviarlos
        }
    }
    catch {
        # Manejo de errores en la verificación/creación de la carpeta
        Enviar-Reporte -mensaje "REPORTE: ERROR`n$($_.Exception.Message)"
    }
}