#!/bin/sh
set -euo pipefail

WORKSPACE_PATH=~/Workspace

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
  curl -O https://torguard.net/downloads/OpenVPN-UDP.zip
  unzip "OpenVPN-UDP.zip"
  cd "OpenVPN -UDP"
  open *.ovpn
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

create_workspace_folder
install_brew
install_brew_apps
clone_app dotbash
configure_dotbash
clone_app dotvim
configure_dotvim
clone_app dotgit
configure_dotgit
clone_app dotslate
configure_dotslate
configure_tunnelblick
manually_configure_apps
wait_for_confirmation
symlink_dropbox
update_all_apps
