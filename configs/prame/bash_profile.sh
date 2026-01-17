# golang
export PATH=$PATH:/usr/local/go/bin

# glcoud
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# ssh agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent` &> /dev/null
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# rbenv
export PATH="/home/hgl/.rbenv/bin:${PATH}"
export PATH="/home/hgl/.rbenv/shims:${PATH}"
export RBENV_SHELL=bash
source '/home/hgl/.rbenv/completions/rbenv.bash'
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}