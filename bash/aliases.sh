# Bash
alias dotbr="source ~/.bashrc && source ~/.inputrc"
alias dotba="v -f ~/.bash/aliases.sh && dotbr"
alias dotbc="v -f ~/.bash/config.sh && dotbr"
alias dotbe="v -f ~/.bash/env.sh && dotbr"
alias dotbashrc="v -f ~/.bashrc && dotbr"
alias dotinputrc="v -f ~/.inputrc && dotbr"
alias c=clear

# List files
alias l="ls -Glha"
alias ll=l

# Grep with colour
alias grep="grep --color --line-number"

# History
alias th=bash_top_history

# Open
alias o="open"

# Vim
alias v="vim"
alias vi="vim"

# Utility
alias t="take"
function take() { mkdir -p "$@" && cd "$@"; }
alias lol='echo "hahahaha"'

# Update them all!
alias uall=updateall

# fasd
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# fasd aliases
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias j=z
alias zz='fasd_cd -d -i' # cd with interactive selection

_fasd_bash_hook_cmd_complete a s d f sd sf z j zz