# SETTINGS
## History
HISTSIZE=100000
HISTFILE=~/.bash_history

# PATHS
## Android tools
export PATH=$PATH:~/android-sdk-macosx/tools
export PATH=$PATH:~/android-sdk-macosx/platform-tools

## Use brew
export PATH=$HOME/brew/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

## Use dotfiles' bash bin
export PATH=$PATH:~/.bash/bin

## Composer PHP Phars
export PATH=$PATH:~/.composer/vendor/bin

## GNU Tar
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"

# Bash shell options
shopt -s globstar
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s dotglob
shopt -s expand_aliases

# Java
export PATH=$JAVA_HOME/bin:$PATH

# Tunnelblick Script
export PATH=~/Workspace/tunnelblick-script:$PATH

# ccat
export PATH=$PATH:/usr/local/opt/go/libexec/bin

# go
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# user pip
export PATH=~/Library/Python/2.7/bin:$PATH

# google cloud
[[ -f ~/google-cloud-sdk/path.bash.inc ]] && source ~/google-cloud-sdk/path.bash.inc
[[ -f ~/google-cloud-sdk/completion.bash.inc ]] && source ~/google-cloud-sdk/completion.bash.inc

# Google App Engine
export PATH=$PATH:~/appengine-java-sdk-1.9.53/bin/

# Travis CI
[ -f ~/.travis/travis.sh ] && source /Users/hlawson/.travis/travis.sh

if [[ "$OSTYPE" == "darwin"*  ]]
then
  # Java
  JAVA_HOME=$(/usr/libexec/java_home)

  # NVM
  export NVM_DIR=~/.nvm
  source $(brew --prefix nvm)/nvm.sh

  # Bash completion
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi