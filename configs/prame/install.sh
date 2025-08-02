#!/bin/bash
set -xeuo pipefail

UTILS_PATH=~/utils

install_rclone() {
  if hash rclone 2>/dev/null
  then
    echo "rlcone already installed"
  else
    sudo -v ; curl https://rclone.org/install.sh | sudo bash
  fi
}

install_google_chrome() {
  if ls /etc/apt/sources.list.d/google-chrome.list 2>/dev/null
  then
    echo 'Repo exists'
  else
    wget https://dl-ssl.google.com/linux/linux_signing_key.pub -O /tmp/google.pub
    sudo gpg --no-default-keyring --keyring /etc/apt/keyrings/google-chrome.gpg --import /tmp/google.pub
    echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg]  https://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update -y
  fi

  sudo apt install google-chrome-stable -y
  sudo systemctl daemon-reload
}

install_1password() {
  if ls /etc/apt/sources.list.d/1password.list 2>/dev/null
  then
    echo 'Repo exists'
  else
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --batch --yes --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --batch --yes --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    sudo apt update -y
  fi

  sudo apt install 1password -y
}

install_terraform() {
  if ls /etc/apt/sources.list.d/hashicorp.list 2>/dev/null
  then
    echo 'Repo exists'
  else
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update -y
  fi

  sudo apt install terraform -y
}

install_docker() {
  if ls /etc/apt/sources.list.d/docker.list 2>/dev/null
  then
    echo 'Repo exists'
  else
    sudo apt update
    sudo apt install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
  fi

  sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

  sudo groupadd --force docker || true
  sudo usermod -aG docker $USER || true
}

install_vscode() {
  if ls /etc/apt/sources.list.d/vscode.list 2>/dev/null
  then
    echo 'Repo exists'
  else
    sudo apt install -y wget gpg apt-transport-https
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --yes --dearmor > microsoft.gpg
    sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f microsoft.gpg
    sudo apt update
  fi

  sudo apt install -y code 
}

install_nordvpn() {
  if ls /etc/apt/sources.list.d/nordvpn-app.list 2>/dev/null
  then
    echo 'Repo exists'
  else
    sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh)
  fi

  sudo groupadd --force nordvpn || true
  sudo usermod -aG nordvpn $USER || true
}

install_spotify() {
  if ls /etc/apt/sources.list.d/spotify.list 2>/dev/null
  then
    echo 'Repo exists'
  else
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update -y
  fi

  sudo apt install -y spotify-client
}

install_golang() {
  local go_version=1.22.4

  if go version | grep "${go_version}"
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

  if node -v | grep "${node_version}"
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

install_ruby() {
  local ruby_version=3.3.5

  if ruby -v | grep "${ruby_version}"
  then
    ruby -v
  else
    sudo apt install -y \
      libssl-dev \
      libreadline-dev \
      zlib1g-dev \
      autoconf \
      bison \
      build-essential \
      libyaml-dev \
      libreadline-dev \
      libncurses5-dev \
      libffi-dev \
      libgdbm-dev

    git clone https://github.com/rbenv/rbenv.git ~/.rbenv || true
    cd ~/.rbenv 
    git pull --rebase

    git clone https://github.com/rbenv/ruby-build.git "$(~/.rbenv/bin/rbenv root)"/plugins/ruby-build || true
    git -C "$(~/.rbenv/bin/rbenv root)"/plugins/ruby-build pull

    bin/rbenv install --skip-existing "${ruby_version}"
    bin/rbenv global "${ruby_version}"
    shims/gem install bundler
  fi
}

install_framework_firmware() {
  sudo apt install -y fwupd
  fwupdmgr refresh --force || true
  fwupdmgr get-updates || true
  fwupdmgr update || true
}

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
install_ruby
install_framework_firmware
