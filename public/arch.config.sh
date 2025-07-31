#!/bin/bash

# Script para configuración mínima Openbox + Tint2

set -e

echo "Creando configuración mínima para Openbox y Tint2..."

# Directorios config
mkdir -p ~/.config/openbox
mkdir -p ~/.config/tint2

# Archivo .xinitrc para iniciar tint2 y openbox
cat > ~/.xinitrc << 'EOF'
#!/bin/sh
# Lanzar tint2 en background
tint2 &
# Lanzar openbox
exec openbox-session
EOF
chmod +x ~/.xinitrc

# Config básica openbox (rc.xml)
cat > ~/.config/openbox/rc.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<openbox_config xmlns="http://openbox.org/3.4/rc">
  <mouse>
    <context name="Desktop">
      <mousebind button="Right" action="Press">
        <action name="ShowMenu">
          <menu>root-menu</menu>
        </action>
      </mousebind>
    </context>
  </mouse>

  <menu id="root-menu" label="Openbox 3">
    <item label="Terminal">
      <action name="Execute">
        <command>kitty</command>
      </action>
    </item>
    <item label="Restart">
      <action name="Restart"/>
    </item>
    <item label="Exit">
      <action name="Exit"/>
    </item>
  </menu>
</openbox_config>
EOF

# Config básica tint2 (~/.config/tint2/tint2rc)
cat > ~/.config/tint2/tint2rc << 'EOF'
# tint2 configuration file

# Panel
panel_monitor = all
panel_position = top center horizontal
panel_size = 100% 28
panel_margin = 0 0
panel_padding = 2 2 2

# Taskbar
taskbar_mode = single_desktop
taskbar_hide_inactive = 0
taskbar_padding = 2 2 2 2
taskbar_background_id = 1

# System tray
systray = 1
systray_padding = 2 2 2
systray_sort = ascending

# Clock
time1_format = %H:%M
time1_font = Sans 10
time1_padding = 2 2 2 2
EOF

echo "Configuración mínima creada."

echo "Para iniciar el entorno gráfico, ejecuta:"
echo "startx"

