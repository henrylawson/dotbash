# History
HISTSIZE=100000
HISTFILE=~/.bash_history

# Use dotfiles' bash bin
export PATH=$PATH:~/.bash/bin

# Bash shell options
shopt -s globstar
shopt -s autocd
shopt -s cdspell
shopt -s dirspell
shopt -s dotglob
shopt -s expand_aliases

# Java
export PATH=$JAVA_HOME/bin:$PATH

if [[ "$OSTYPE" == "darwin"*  ]]
then
  # gcloud
  source ~/google-cloud-sdk/completion.bash.inc
  source ~/google-cloud-sdk/path.bash.inc

  # Use brew
  export PATH=$HOME/brew/bin:$PATH
  export PATH=$HOME/brew/sbin:$PATH
  export PATH=/usr/local/bin:$PATH
  export PATH=/usr/local/sbin:$PATH

  # Brew bash completion
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi

  # GNU Tar
  export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"

  # user pip
  export PATH=~/Library/Python/2.7/bin:$PATH

  # Java
  JAVA_HOME=$(/usr/libexec/java_home)

  # NVM
  export NVM_DIR=~/.nvm
  source $(brew --prefix nvm)/nvm.sh
fi
