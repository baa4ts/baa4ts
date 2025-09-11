# CUIDADO: Esto edita el registro directamente
# Solo procede si sabes lo que haces

# Eliminar la entrada del servicio del registro
Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Win2Internals" -Force -Recurse

Restart-Computer -Force
