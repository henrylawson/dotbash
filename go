#!/bin/sh
set -euo pipefail

WORKSPACE_PATH=~/Workspace

pp() {
  echo "====> EXECUTING STEP: $1"
}

create_workspace_folder() {
  mkdir -p $WORKSPACE_PATH
}

clone_app() {
  APP=$1

  if [ -d "$WORKSPACE_PATH/$APP" ]
  then
    cd $WORKSPACE_PATH/$APP
    git pull --rebase
    return 0
  fi

  cd $WORKSPACE_PATH
  git clone https://github.com/henrylawson/$APP.git
}

configure_dotbash() {
  ln -sfn $WORKSPACE_PATH/dotbash/bashrc ~/.bashrc
  ln -sfn $WORKSPACE_PATH/dotbash/bash_profile ~/.bash_profile
  ln -sfn $WORKSPACE_PATH/dotbash/bash ~/.bash
  ln -sfn $WORKSPACE_PATH/dotbash/inputrc ~/.inputrc
  chmod 755 ~/.bash/bin/*
  sudo bash -c "echo '/usr/local/bin/bash' >> /etc/shells"
  sudo chsh -s /usr/local/bin/bash
  chsh -s /usr/local/bin/bash
}

install_brew() {
  if hash brew 2>/dev/null
  then
    return 0
  fi

  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap Homebrew/bundle
}

install_brew_apps() {
  cd $WORKSPACE_PATH/dotbash
  brew bundle
}

manually_configure_apps() {
  echo "The below applications will require manual setup:"
  echo "- Dropbox (login)"
  echo "- 1Password (login)"
  echo "- Google Drive (login)"
  echo "- Google Chrome (login)"
  echo "- Evernote (login)"
  echo "- iTerm (setup preferences)"
  echo "- Spotify (login)"
  echo "- Skype (login)"
  echo "- Torguard - (login)"
  echo "- Tunnelblick (login)"
  echo "- MindNode (license)"
  echo "- Adobe Create Cloud (login, Photoshop, Lightroom)"
  echo "- Alfred (license)"
  echo "- iStat Menus (license)"
  echo "- Docker (beta) (manually download, install)"
  echo "- Amphetamine (mac store install)"
}

configure_dotvim() {
  ln -sfn $WORKSPACE_PATH/dotvim/gvimrc ~/.gvimrc
  ln -sfn $WORKSPACE_PATH/dotvim/vimrc ~/.vimrc
  ln -sfn $WORKSPACE_PATH/dotvim/vim ~/.vim

  ~/.vim/bundle/neobundle.vim/bin/neoinstall

  if [ -d "$WORKSPACE_PATH/powerline-fonts" ]
  then
    cd $WORKSPACE_PATH/powerline-fonts
    git pull --rebase
  else
    git clone https://github.com/powerline/fonts.git powerline-fonts
  fi
  cd $WORKSPACE_PATH/powerline-fonts && ./install.sh
}

configure_dotgit() {
  ln -sfn $WORKSPACE_PATH/dotgit/gitconfig ~/.gitconfig
  ln -sfn $WORKSPACE_PATH/dotgit/gitignore ~/.gitignore
}

symlink_dropbox() {
  ln -sfn ~/Dropbox/GnuPG ~/.gnupg
  ln -sfn ~/Dropbox/SSH ~/.ssh
}

configure_dotslate() {
  ln -sfn $WORKSPACE_PATH/dotslate/slate ~/.slate
}

configure_tunnelblick() {
  cd /tmp
  curl -O https://torguard.net/downloads/OpenVPN-UDP.zip
  unzip -u "OpenVPN-UDP.zip" -d "openvpn"
  open "openvpn"
}

update_all_apps() {
  $WORKSPACE_PATH/dotbash/bash/bin/updateall
}

wait_for_confirmation() {
  read -p "Have all applications been manually configured? [Yy]" -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      exit 1
  fi
}

setup_ruby() {
  eval "$(rbenv init -)"
  if [ ! -d ~/.rbenv/plugins/rbenv-bundle-exec ]
  then
    git clone https://github.com/maljub01/rbenv-bundle-exec.git ~/.rbenv/plugins/rbenv-bundle-exec
  fi
  rbenv install 2.3.1
  rbenv global 2.3.1
}

pp "Creating workspace folder" && create_workspace_folder
pp "Installing brew"           && install_brew
pp "Downloading dotbash"       && clone_app dotbash
pp "Installing applications"   && install_brew_apps
pp "Configuring dotbash"       && configure_dotbash
pp "Setup Ruby"                && setup_ruby
pp "Downloading dotvim"        && clone_app dotvim
pp "Configuring dotvim"        && configure_dotvim
pp "Downloading dotgit"        && clone_app dotgit
pp "Configuring dotgit"        && configure_dotgit
pp "Downloading dotslate"      && clone_app dotslate
pp "Configuring dotslate"      && configure_dotslate
pp "Configuring tunnelblick"   && configure_tunnelblick
pp "Manually configure apps"   && manually_configure_apps
pp "Waiting for confirmation"  && wait_for_confirmation
pp "Symlink Dropbox files"     && symlink_dropbox
pp "Update all applications"   && update_all_apps
