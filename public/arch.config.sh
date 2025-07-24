#!/bin/bash

main() {
  # Verificar si no sos root
  if [ "$EUID" -ne 0 ]; then
    echo "Para ejecutar este script necesitas permisos de administrador."
    sudo -v
    if [ $? -ne 0 ]; then
      echo "No se pudo obtener permisos de administrador. Abortando."
      exit 1
    fi
  fi

  echo "Tenés permisos de administrador. Continuando..."
  sleep 3
  clear

  sudo pacman -Syu --noconfirm

  echo "Instalando yay"
  sleep 3
  clear

  sudo pacman -S --needed --noconfirm base-devel git

  clear
  git clone https://aur.archlinux.org/yay.git
  sleep 2
  clear
  cd yay || { echo "No se pudo acceder a la carpeta yay"; exit 1; }
  sleep 1
  makepkg -si --noconfirm
  sleep 2
  clear
  cd ..
  rm -rf ./yay

  yay -Syu --noconfirm

  clear
  sleep 1
  echo "Instalando: Libre Wolf"
  sleep 2
  clear
  yay -S --noconfirm librewolf-bin
  sleep 2
  clear
  echo "Instalando Visual Studio Code"
  sleep 2
  clear
  yay -S --noconfirm visual-studio-code-bin
  sleep 2
  clear
  sudo pacman -S --noconfirm rofi

  echo "Instalación completa."
}

main
