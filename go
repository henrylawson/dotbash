#!/bin/bash
set -euo pipefail

HOMEDIR=~
WORKSPACE_PATH=~/Workspace
BOX_HOSTNAME=`cat .hostname`

pp() {
  echo "====> EXECUTING STEP: $1"
}

wait_for_confirmation() {
  read -p "Have all applications been manually configured? [Yy]" -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      exit 1
  fi
}

create_workspace_folder() {
  mkdir -p $WORKSPACE_PATH
}

clone_app() {
  APP=$1

  if [ -d "$WORKSPACE_PATH/$APP" ]
  then
    cd "$WORKSPACE_PATH/$APP"
    git pull --rebase
    return 0
  fi

  cd $WORKSPACE_PATH
  git clone "https://github.com/henrylawson/$APP.git"
}

configure_dotbash() {
  ln -sfn $WORKSPACE_PATH/dotbash/bashrc ~/.bashrc
  ln -sfn $WORKSPACE_PATH/dotbash/bash_profile ~/.bash_profile
  ln -sfn $WORKSPACE_PATH/dotbash/bash ~/.bash
  ln -sfn $WORKSPACE_PATH/dotbash/inputrc ~/.inputrc
  chmod 755 ~/.bash/bin/*
  if [ "$OSTYPE" == "darwin"* ]
  then
    sudo bash -c "echo '$HOMEDIR/brew/bin/bash' >> /etc/shells"
    sudo chsh -s "$HOMEDIR/brew/bin/bash"
    chsh -s "$HOMEDIR/brew/bin/bash"
  fi
}

install_brew() {
  if hash brew 2>/dev/null
  then
    return 0
  fi

  cd ~
  git clone https://github.com/Homebrew/brew.git
  brew tap Homebrew/bundle
}

install_native_apps() {
  if [ "$OSTYPE" == "darwin"* ]
  then
    install_brew
    cd $WORKSPACE_PATH/dotbash/configs/$BOX_HOSTNAME
    brew bundle
  else
    xargs sudo apt-get --yes --force-yes install < $WORKSPACE_PATH/dotbash/configs/$BOX_HOSTNAME/packages.txt
  fi
}

install_pip_apps() {
  cd $WORKSPACE_PATH/dotbash/configs/$BOX_HOSTNAME
  pip install --user -r requirements.txt
}

manually_configure_apps() {
  echo "The below applications will require manual login:"
  echo "- Dropbox (login)"
  echo "- 1Password (login)"
  echo "- Google Drive (login, setup shortcuts)"
  echo "- Google Chrome (login)"
  echo "- Evernote (login)"
  echo "- Spotify (login)"
  echo "- Skype (login)"
  echo "- NordVPN (login)"
  echo "- Tunnelblick (login)"

  echo "The below applications will require manual setup:"
  echo "- MindNode (license)"
  echo "- iTerm (config in dotbash)"
  echo "- Alfred (license, config in Dropbox)"
  echo "- Slate (config, permissions)"
  echo "- Amphetamine (app store, config)"
}

configure_dotvim() {
  ln -sfn $WORKSPACE_PATH/dotvim/gvimrc ~/.gvimrc
  ln -sfn $WORKSPACE_PATH/dotvim/vimrc ~/.vimrc
  ln -sfn $WORKSPACE_PATH/dotvim/vim ~/.vim
  ln -sfn $WORKSPACE_PATH/dotvim/ctags ~/.ctags

  if [ "$OSTYPE" == "darwin"* ]
  then
    if [ -d "$WORKSPACE_PATH/powerline-fonts" ]
    then
      cd $WORKSPACE_PATH/powerline-fonts
      git pull --rebase
    else
      git clone https://github.com/powerline/fonts.git "$WORKSPACE_PATH/powerline-fonts"
    fi
    cd $WORKSPACE_PATH/powerline-fonts && ./install.sh
  fi
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

update_all_apps() {
  $WORKSPACE_PATH/dotbash/bash/bin/updateall
}

refresh_all_apps() {
  cd $WORKSPACE_PATH/dotbash
  ./refresh
}

setup_ruby() {
  if [ "$OSTYPE" == "darwin"* ]
  then
    eval "$(rbenv init -)"
    if [ ! -d ~/.rbenv/plugins/rbenv-bundle-exec ]
    then
      git clone https://github.com/maljub01/rbenv-bundle-exec.git ~/.rbenv/plugins/rbenv-bundle-exec
    fi
    rbenv install 2.3.1 --skip-existing
    rbenv global 2.3.1
  else
    sudo apt-get --yes --force-yes install ruby-full
  fi
}

install_gcloud_sdk() {
  if hash gcloud 2>/dev/null
  then
    return 0
  fi

  curl -H 'Cache-Control: no-cache' https://sdk.cloud.google.com > /tmp/gcpsdk
  bash /tmp/gcpsdk --disable-prompts
  rm /tmp/gcpsdk
}

prereq_apps() {
  echo "The below applications will require manual install:"
  echo "- git"
  echo "- Xcode (if on MacOS)"
  echo "- Java Development Kit (JDK)"
  wait_for_confirmation
}

pp "Creating workspace folder"        && create_workspace_folder
pp "Prerequisites"                    && prereq_apps
pp "Downloading dotbash"              && clone_app dotbash
pp "Installing native applications"   && install_native_apps
pp "Installing pip applications"      && install_pip_apps
pp "Installing gcloud sdk"            && install_gcloud_sdk
pp "Setup Ruby"                       && setup_ruby
pp "Configuring dotbash"              && configure_dotbash
pp "Downloading dotvim"               && clone_app dotvim
pp "Configuring dotvim"               && configure_dotvim
pp "Downloading dotgit"               && clone_app dotgit
pp "Configuring dotgit"               && configure_dotgit

if [ "$OSTYPE" == "darwin"* ]
then
  pp "Downloading dotslate" && clone_app dotslate
  pp "Configuring dotslate" && configure_dotslate

  if [ "$BOX_HOSTNAME" == "Picolo" ]
  then
    pp "Downloading apple scripts" && clone_app apple-scripts
    pp "Symlink Dropbox files"     && symlink_dropbox
  fi

  pp "Update all applications" && update_all_apps
  pp "Refresh packages"        && refresh_all_apps

  if [ "$BOX_HOSTNAME" == "Picolo" ]
  then
    pp "Manually configure apps" && manually_configure_apps
  fi
fi
