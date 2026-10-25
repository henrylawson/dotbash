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
  sudo rm -f /etc/apt/sources.list.d/google-chrome.list /etc/apt/keyrings/google-chrome.gpg
  if [ -f /etc/apt/sources.list.d/google-chrome.sources ]; then
    echo 'Repo exists'
  else
    sudo install -m 0755 -d /usr/share/keyrings
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/google-chrome.gpg
    cat <<EOF | sudo tee /etc/apt/sources.list.d/google-chrome.sources
Types: deb
URIs: https://dl.google.com/linux/chrome-stable/deb/
Suites: stable
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/google-chrome.gpg
EOF
    sudo apt update -y
  fi

  sudo apt install google-chrome-stable -y
  sudo systemctl daemon-reload
}

install_1password() {
  sudo rm -f /etc/apt/sources.list.d/1password.list
  if [ -f /etc/apt/sources.list.d/1password.sources ]; then
    echo 'Repo exists'
  else
    sudo install -m 0755 -d /usr/share/keyrings
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --batch --yes --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    cat <<EOF | sudo tee /etc/apt/sources.list.d/1password.sources
Types: deb
URIs: https://downloads.1password.com/linux/debian/amd64
Suites: stable
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/1password-archive-keyring.gpg
EOF
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --batch --yes --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    sudo apt update -y
  fi

  sudo apt install 1password -y
}

install_terraform() {
  sudo rm -f /etc/apt/sources.list.d/hashicorp.list
  if [ -f /etc/apt/sources.list.d/hashicorp.sources ]; then
    echo 'Repo exists'
  else
    sudo install -m 0755 -d /usr/share/keyrings
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    cat <<EOF | sudo tee /etc/apt/sources.list.d/hashicorp.sources
Types: deb
URIs: https://apt.releases.hashicorp.com
Suites: $(lsb_release -cs)
Components: main
Signed-By: /usr/share/keyrings/hashicorp-archive-keyring.gpg
EOF
    sudo apt update -y
  fi

  sudo apt install terraform -y
}

install_docker() {
  sudo rm -f /etc/apt/sources.list.d/docker.list
  if [ -f /etc/apt/sources.list.d/docker.sources ]; then
    echo 'Repo exists'
  else
    sudo apt update
    sudo apt install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    cat <<EOF | sudo tee /etc/apt/sources.list.d/docker.sources
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
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
  sudo rm -f /etc/apt/sources.list.d/vscode.list
  if [ ! -f /usr/share/keyrings/microsoft.gpg ]; then
    echo 'Fetching Microsoft GPG key...'
    sudo apt install -y wget gpg apt-transport-https
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --yes --dearmor > microsoft.gpg
    sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
    rm -f microsoft.gpg
  else
    echo 'Microsoft GPG key already exists.'
  fi

  if [ -f /etc/apt/sources.list.d/vscode.sources ]; then
    echo 'Repo exists'
  else
    cat <<EOF | sudo tee /etc/apt/sources.list.d/vscode.sources
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64 arm64 armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
    sudo apt update
  fi

  sudo apt install -y code
}

install_spotify() {
  sudo rm -f /etc/apt/sources.list.d/spotify.list
  if [ -f /etc/apt/sources.list.d/spotify.sources ]; then
    echo 'Repo exists'
  else
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/spotify.gpg
    cat <<EOF | sudo tee /etc/apt/sources.list.d/spotify.sources
Types: deb
URIs: http://repository.spotify.com
Suites: stable
Components: non-free
Signed-By: /etc/apt/keyrings/spotify.gpg
EOF
    sudo apt update -y
  fi

  sudo apt install -y spotify-client
}

install_golang() {
  local go_version=1.22.4

  if hash go 2>/dev/null && go version | grep -q "${go_version}"
  then
    echo "go ${go_version} already installed"
  else
    curl -OL "https://golang.org/dl/go${go_version}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go${go_version}.linux-amd64.tar.gz" || true
    sudo rm -f "go${go_version}.linux-amd64.tar.gz" || true
  fi
}

install_nodejs() {
  local node_version=22

  if hash node 2>/dev/null && node -v | grep -q "v${node_version}\."
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

  if hash ruby 2>/dev/null && ruby -v | grep -q "${ruby_version}"
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

    [ -d ~/.rbenv ] || git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    git -C ~/.rbenv pull --rebase --autostash || true

    local ruby_build_dir
    ruby_build_dir="$(~/.rbenv/bin/rbenv root 2>/dev/null || echo ~/.rbenv)/plugins/ruby-build"
    [ -d "$ruby_build_dir" ] || git clone https://github.com/rbenv/ruby-build.git "$ruby_build_dir"
    git -C "$ruby_build_dir" pull --rebase --autostash || true

    ~/.rbenv/bin/rbenv install --skip-existing "${ruby_version}"
    ~/.rbenv/bin/rbenv global "${ruby_version}"
    ~/.rbenv/shims/gem install bundler
  fi
}

install_framework_firmware() {
  sudo apt install -y fwupd
  fwupdmgr refresh --force || true
  fwupdmgr get-updates || true
  fwupdmgr update -y || true
}

install_google_antigravity() {
  if hash agy 2>/dev/null
  then
    echo "antigravity cli already installed"
  else
    curl -fsSL https://antigravity.google/cli/install.sh | bash
  fi
}

install_mullvad_vpn() {
  sudo rm -f /etc/apt/sources.list.d/mullvad.list
  if [ -f /etc/apt/sources.list.d/mullvad.sources ]; then
    echo 'Repo exists'
  else
    sudo install -m 0755 -d /usr/share/keyrings
    sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc
    cat <<EOF | sudo tee /etc/apt/sources.list.d/mullvad.sources
Types: deb
URIs: https://repository.mullvad.net/deb/stable/
Suites: stable
Components: main
Architectures: $(dpkg --print-architecture)
Signed-By: /usr/share/keyrings/mullvad-keyring.asc
EOF
    sudo apt update -y
  fi
  sudo apt install -y mullvad-vpn
}

install_bun() {
  if hash bun 2>/dev/null
  then
    echo "bun already installed"
  else
    curl -fsSL https://bun.com/install | bash
  fi
}

install_flutter() {
  if hash flutter 2>/dev/null
  then
    echo "flutter already installed"
  else
    git clone https://github.com/flutter/flutter.git -b stable ~/.flutter
  fi
}

customize_ubuntu_and_gnome() {
  # headphone jack buzzing sound 
  echo 0 | sudo tee /sys/module/snd_hda_intel/parameters/power_save

  # accidental window dragging
  gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag false

  # hide ubuntu live patch icon
  gsettings set com.ubuntu.update-notifier show-livepatch-status-icon false

  # hide accessibility icon
  if hash gnome-extensions 2>/dev/null && gnome-extensions list | grep -q 'hide-universal-access'; then
    gnome-extensions enable hide-universal-access@akiirui.github.io 2>/dev/null || true
  else
    echo "Manually install 'Hide Universal Access' gnome extension"
  fi

  # set font scaling factor
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.35

  # prefer light theme
  gsettings set org.gnome.desktop.interface color-scheme 'default'

  # change background to grey
  gsettings set org.gnome.desktop.background color-shading-type 'solid'
  gsettings set org.gnome.desktop.background picture-uri 'none'
  gsettings set org.gnome.desktop.background picture-uri-dark 'none'
  gsettings set org.gnome.desktop.background primary-color '#909090'

  # hide the dock
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
  gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
}

install_rclone
install_google_chrome
install_1password
install_terraform
install_docker
install_vscode
install_mullvad_vpn
install_spotify
install_golang
install_nodejs
install_ruby
install_framework_firmware
install_google_antigravity
install_bun
install_flutter
customize_ubuntu_and_gnome