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
  MAX_TRIES=30

  for try in $(seq 1 $MAX_TRIES)
  do
    INSTALLED_SNAPS=$(snap list 2> /dev/null | grep -c  ^Name || true)

    if (( $INSTALLED_SNAPS == 0 ))
    then
      echo "all snaps removed"
      break
    fi

    echo "Attempt $try of $MAX_TRIES to remove $INSTALLED_SNAPS snaps."

    snap list 2> /dev/null | grep -v ^Name |  awk '{ print $1 }'  | xargs -r -n1 sudo snap remove || true
  done

  sudo systemctl disable --now snapd || true

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

install_google_chrome() {
  wget https://dl-ssl.google.com/linux/linux_signing_key.pub -O /tmp/google.pub
  sudo gpg --no-default-keyring --keyring /etc/apt/keyrings/google-chrome.gpg --import /tmp/google.pub
  echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg]  https://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

  sudo apt update
  sudo apt install google-chrome-stable -y
  sudo systemctl daemon-reload
}

install_1password() {
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list

  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/

  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22

  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

  sudo apt update
  sudo apt install 1password -y
}

remove_snapd
install_rclone
install_google_chrome
install_1password
