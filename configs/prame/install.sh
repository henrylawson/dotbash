#!/bin/bash
set -euo pipefail

UTILS_PATH=~/utils

install_rclone() {
  if hash rclone 2>/dev/null
  then
    echo "rlcone already installed"
  else
    sudo -v ; curl https://rclone.org/install.sh | sudo bash
  fi
}

remove_snapd() {
  sudo snap remove $(snap list | awk '!/^Name|^core/ {print $1}')

  sudo systemctl disable --now snapd

  sudo apt remove --purge -y \
    snapd \
    gnome-software-plugin-snap

  sudo rm -rf \
    /snap \
    /var/snap \
    /var/lib/snapd \
    /var/cache/snapd \
    /usr/lib/snapd \
    ~/snap

  cat << EOF | sudo tee -a /etc/apt/preferences.d/no-snap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

  sudo chown root:root /etc/apt/preferences.d/no-snap.pref
}

remove_snapd
install_rclone
