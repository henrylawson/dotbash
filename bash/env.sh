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

# google cloud
[ -f ~/google-cloud-sdk/completion.bash.inc ] && source ~/google-cloud-sdk/completion.bash.inc
[ -f ~/google-cloud-sdk/path.bash.inc ] && source ~/google-cloud-sdk/path.bash.inc
[ -x "$(command -v kubectl)" ] && source <(kubectl completion bash)

# fzf
if hash rg 2>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
else
  export FZF_DEFAULT_COMMAND='ag -l --nocolor -g ""'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# zoxide
hash zoxide 2>/dev/null && eval "$(zoxide init bash)"
