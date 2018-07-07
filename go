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
  HTTPS_URL="https://github.com/henrylawson/$APP.git"
  GIT_URL=git@github.com:henrylawson/$APP.git

  if [ -d "$WORKSPACE_PATH/$APP" ]
  then
    cd "$WORKSPACE_PATH/$APP"
    git remote set-url origin $GIT_URL
    git pull --rebase
    return 0
  fi

  cd $WORKSPACE_PATH
  git clone $HTTPS_URL
  cd $APP
  git remote set-url origin $GIT_URL
}

configure_dotbash() {
  ln -sfn $WORKSPACE_PATH/dotbash/bashrc ~/.bashrc
  ln -sfn $WORKSPACE_PATH/dotbash/bash_profile ~/.bash_profile
  ln -sfn $WORKSPACE_PATH/dotbash/bash ~/.bash
  ln -sfn $WORKSPACE_PATH/dotbash/inputrc ~/.inputrc
  ln -sfn $WORKSPACE_PATH/dotbash/tmux.conf ~/.tmux.conf
  chmod 755 ~/.bash/bin/*

  echo $BOX_HOSTNAME > $WORKSPACE_PATH/dotbash/.hostname

  if [[ "$OSTYPE" == "darwin"* ]]
  then
    sudo bash -c "echo '$HOMEDIR/brew/bin/bash' >> /etc/shells"
    sudo chsh -s "$HOMEDIR/brew/bin/bash"
    chsh -s "$HOMEDIR/brew/bin/bash"
  fi
}

configure_brew_paths() {
  # minimum needed for first run
  export PATH=$HOME/brew/bin:$PATH
  export PATH=$HOME/brew/sbin:$PATH
  export PATH=/usr/local/bin:$PATH
  export PATH=/usr/local/sbin:$PATH
}

install_brew() {
  if hash brew 2>/dev/null
  then
    return 0
  elif [ -d ~/brew ]
  then
    configure_brew_paths
    return 0
  fi

  cd ~
  git clone https://github.com/Homebrew/brew.git

  configure_brew_paths

  brew tap Homebrew/bundle
  brew tap caskroom/cask
  brew update
  brew install bash nvm rbenv bash-completion
}

install_native_apps() {
  mkdir -p "${WORKSPACE_PATH}/dotbash/configs/${BOX_HOSTNAME}"

  if [[ "$OSTYPE" == "darwin"* ]]
  then
    install_brew
    cd "${WORKSPACE_PATH}/dotbash/configs/${BOX_HOSTNAME}"
    touch Brewfile
    brew bundle
  else
    cd "${WORKSPACE_PATH}/dotbash/configs/${BOX_HOSTNAME}"
    touch packages.txt
    xargs sudo apt-get --yes --force-yes install < packages.txt
 
    sudo mkdir -p /opt/user
    sudo chown hgl /opt/user
  fi
}

install_manual_apps() {
  if [[ -f "${WORKSPACE_PATH}/dotbash/configs/${BOX_HOSTNAME}/install.sh" ]]
  then
    bash -c "${WORKSPACE_PATH}/dotbash/configs/${BOX_HOSTNAME}/install.sh"
  else
    echo "No custom install script found"
  fi
}

install_pip_apps() {
  if [[ "$OSTYPE" == "darwin"* ]]
  then
    sudo easy_install pip
  fi

  cd "${WORKSPACE_PATH}/dotbash/configs/${BOX_HOSTNAME}"
  touch requirements.txt
  pip install --user -r requirements.txt
}

manually_configure_apps() {
  local manual_config="${WORKSPACE_PATH}/dotbash/configs/${BOX_HOSTNAME}/manual_config.txt"
  if [[ -f "${manual_config}" ]]
  then
    cat "${manual_config}"
  else
    echo "No steps to perform"
  fi
}

configure_dotvim() {
  ln -sfn $WORKSPACE_PATH/dotvim/gvimrc ~/.gvimrc
  ln -sfn $WORKSPACE_PATH/dotvim/vimrc ~/.vimrc
  [[ -L ~/.vim  ]] || rm -rf ~/.vim
  ln -sfn $WORKSPACE_PATH/dotvim/vim ~/.vim
  ln -sfn $WORKSPACE_PATH/dotvim/ctags ~/.ctags
}

configure_dotgit() {
  ln -sfn $WORKSPACE_PATH/dotgit/gitconfig ~/.gitconfig
  ln -sfn $WORKSPACE_PATH/dotgit/gitignore ~/.gitignore
}

symlink_drive() {
  ln -sfn ~/Google\ Drive/Dotfiles/GnuPG ~/.gnupg
  rm -rf ~/.ssh
  ln -sfn ~/Google\ Drive/Dotfiles/SSH ~/.ssh
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
  RUBY_VER=2.4.2

  if [[ "$OSTYPE" == "darwin"* ]]
  then
    eval "$(rbenv init -)"
    if [ ! -d ~/.rbenv/plugins/rbenv-bundle-exec ]
    then
      git clone https://github.com/maljub01/rbenv-bundle-exec.git ~/.rbenv/plugins/rbenv-bundle-exec
    fi
    rbenv install $RUBY_VER --skip-existing
    rbenv global $RUBY_VER
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
  source ~/google-cloud-sdk/path.bash.inc
  gcloud components install \
    app-engine-go \
    cbt \
    bigtable \
    datalab \
    cloud-datastore-emulator \
    gcd-emulator \
    pubsub-emulator \
    emulator-reverse-proxy \
    docker-credential-gcr \
    alpha \
    beta \
    app-engine-java \
    app-engine-python \
    kubectl \
    --quiet
}

prereq_apps() {
  echo "The below applications will require manual install:"
  echo "- git"
  echo "- Xcode (if on MacOS)"
  echo "- Java Development Kit (JDK)"
  wait_for_confirmation
}

clean_up() {
  rm -rf "${WORKSPACE_PATH}/dotbash/configs/${BOX_HOSTNAME}/default.profraw"
}

pp "Creating workspace folder"        && create_workspace_folder
pp "Prerequisites"                    && prereq_apps
pp "Downloading dotbash"              && clone_app dotbash
pp "Installing native applications"   && install_native_apps
pp "Installing manual applications"   && install_manual_apps
pp "Installing pip applications"      && install_pip_apps
pp "Installing gcloud sdk"            && install_gcloud_sdk
pp "Setup Ruby"                       && setup_ruby
pp "Configuring dotbash"              && configure_dotbash
pp "Downloading dotvim"               && clone_app dotvim
pp "Configuring dotvim"               && configure_dotvim
pp "Downloading dotgit"               && clone_app dotgit
pp "Configuring dotgit"               && configure_dotgit

if [[ "$OSTYPE" == "darwin"* ]]
then
  pp "Downloading dotslate" && clone_app dotslate
  pp "Configuring dotslate" && configure_dotslate

  if [ "$BOX_HOSTNAME" == "Picolo" ]
  then
    pp "Downloading apple scripts" && clone_app apple-scripts
    pp "Symlink Drive files"       && symlink_drive
  fi
fi

pp "Update all applications" && update_all_apps
pp "Refresh packages"        && refresh_all_apps
pp "Manually configure apps" && manually_configure_apps
pp "Cleanup" && clean_up
