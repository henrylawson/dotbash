#!/bin/bash
set -euo pipefail

WORKSPACE_PATH=~/Workspace
BOX_HOSTNAME=$(hostname)

source ./lib/utility

pp "Creating workspace folder"      && create_workspace_folder
pp "Prerequisites"                  && prereq_apps
pp "Installing brew"                && install_brew
pp "Downloading dotbash"            && clone_app dotbash
pp "Installing brew applications"   && install_brew_apps
pp "Installing pip applications"    && install_pip_apps
pp "Configuring dotbash"            && configure_dotbash
pp "Setup Ruby"                     && setup_ruby
pp "Downloading dotvim"             && clone_app dotvim
pp "Configuring dotvim"             && configure_dotvim
pp "Downloading dotgit"             && clone_app dotgit
pp "Configuring dotgit"             && configure_dotgit
pp "Downloading dotslate"           && clone_app dotslate
pp "Configuring dotslate"           && configure_dotslate

if [ "$BOX_HOSTNAME" == "Picolo.local" ]
then
  pp "Downloading apple scripts"      && clone_app apple-scripts
  pp "Symlink Dropbox files"          && symlink_dropbox
fi

pp "Update all applications"        && update_all_apps
pp "Refresh packages"               && refresh_all_apps

if [ "$BOX_HOSTNAME" == "Picolo.local" ]
then
  pp "Manually configure apps"        && manually_configure_apps
fi
