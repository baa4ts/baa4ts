# Probar con "Everyone"
try {
    $account = New-Object System.Security.Principal.NTAccount("Everyone")
    $sid = $account.Translate([System.Security.Principal.SecurityIdentifier])
    Write-Host "Everyone SID: $($sid.Value)"
} catch {
    Write-Host "Error resolviendo Everyone: $($_.Exception.Message)"
}

# Probar con "NT AUTHORITY\SYSTEM"
try {
    $account = New-Object System.Security.Principal.NTAccount("NT AUTHORITY\SYSTEM")
    $sid = $account.Translate([System.Security.Principal.SecurityIdentifier])
    Write-Host "SYSTEM SID: $($sid.Value)"
} catch {
    Write-Host "Error resolviendo SYSTEM: $($_.Exception.Message)"
}
