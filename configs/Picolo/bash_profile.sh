# Composer PHP Phars
export PATH=$PATH:~/.composer/vendor/bin

# Tunnelblick Script
export PATH=~/Workspace/tunnelblick-script:$PATH

# ccat
export PATH=$PATH:/usr/local/opt/go/libexec/bin

# go
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# Postgress
alias postgres_start="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/log/postgres/postgres.log start"
alias postgres_stop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"

# Virtual Box
alias vbx="VBoxManage"

# openvpnstart
alias openvpnstart=/Applications/Tunnelblick.app/Contents/Resources/openvpnstart

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(/Users/hlawson/brew/bin/rbenv init -)"
