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
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --batch --yes --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list

  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/

  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22

  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --batch --yes --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

  sudo apt update
  sudo apt install 1password -y
}

install_terraform() {
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

  sudo apt update
  sudo apt install terraform -y
}

install_docker() {
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

  sudo groupadd --force docker || true
  sudo usermod -aG docker $USER || true
}

install_vscode() {
  sudo apt-get install wget gpg
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --yes --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  rm -f packages.microsoft.gpg

  sudo apt update
  sudo apt install -y apt-transport-https code 
}

install_nordvpn() {
  sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh)

  sudo groupadd --force nordvpn || true
  sudo usermod -aG nordvpn $USER || true
}

install_spotify() {
  curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
  sudo apt-get update -y
  sudo apt-get install -y spotify-client
}

install_golang() {
  local go_version=1.22.4

  if [ hash go 2>/dev/null ] && [ go version | grep "${go_version}" ]
  then
    echo "go already installed"
  else
    curl -OL "https://golang.org/dl/go${go_version}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go${go_version}.linux-amd64.tar.gz" || true
    sudo rm -f "go${go_version}.linux-amd64.tar.gz" || true
  fi
}

install_nodejs() {
  local node_version=22

  if [ hash node 2>/dev/null ] && [ node -v | grep "${node_version}" ]
  then
    node -v
  else
    sudo apt remove -y nodejs || true
    sudo apt autoremove -y || true

    curl -fsSL "https://deb.nodesource.com/setup_${node_version}.x" -o /tmp/nodesource_setup.sh
    sudo -E bash /tmp/nodesource_setup.sh
    sudo apt install -y nodejs
    rm -f /tmp/nodesource_setup.sh
  fi
}

install_gcloud_pip() {
  $(gcloud info --format="value(basic.python_location)") -m pip install numpy
}

install_ruby() {
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv || true
  cd ~/.rbenv 
  git pull --rebase
}

remove_snapd
install_rclone
install_google_chrome
install_1password
install_terraform
install_docker
install_vscode
install_nordvpn
install_spotify
install_golang
install_nodejs
install_gcloud_pip