' FILE: ReplaceLnkWithNumberedVBS.vbs

Option Explicit

' Crea VBS numerados y modifica accesos directos manteniendo iconos.
' Genera N.vbs en %USERPROFILE%\Desktop\Mirnov que ejecutan el destino original.
' Luego cambia cada .lnk para ejecutar con wscript.exe en modo batch (sin consola).

Dim objFSO, objShell, objFolder, objFile, objShortcut
Dim strDesktop, strMirnov, strVBSPath
Dim originalTarget, ts, vbsName
Dim origIcon
Dim i
Dim wscriptPath, vbsContent

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

strDesktop = objShell.SpecialFolders("Desktop")
strMirnov = objFSO.BuildPath(strDesktop, "Mirnov")

If Not objFSO.FolderExists(strMirnov) Then
    WScript.Quit
End If

' Ruta a wscript.exe
wscriptPath = objShell.ExpandEnvironmentStrings("%SystemRoot%\System32\wscript.exe")

Set objFolder = objFSO.GetFolder(strDesktop)

i = 1

For Each objFile In objFolder.Files
    If LCase(objFSO.GetExtensionName(objFile.Name)) = "lnk" Then

        On Error Resume Next
        Set objShortcut = objShell.CreateShortcut(objFile.Path)
        originalTarget = objShortcut.TargetPath
        origIcon = objShortcut.IconLocation
        On Error GoTo 0

        If IsNull(originalTarget) Or originalTarget = "" Then
            i = i + 1
            Exit For
        End If

        Do
            vbsName = CStr(i) & ".vbs"
            strVBSPath = objFSO.BuildPath(strMirnov, vbsName)
            i = i + 1
        Loop While objFSO.FileExists(strVBSPath)

        ' Contenido del VBS: ejecuta el destino original
        vbsContent = "Set WshShell = CreateObject(""WScript.Shell"")" & vbCrLf & _
                     "WshShell.Run """"""" & originalTarget & """"""", 1, False"

        Set ts = objFSO.CreateTextFile(strVBSPath, True)
        ts.Write vbsContent
        ts.Close

        ' Modifica el acceso directo para ejecutar el VBS sin consola
        objShortcut.TargetPath = wscriptPath
        objShortcut.Arguments = "//B """ & strVBSPath & """"
        objShortcut.IconLocation = origIcon
        objShortcut.Save
    End If
Next
