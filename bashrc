BOX_HOSTNAME=`cat ~/Workspace/dotbash/.hostname`
BOX_HOSTNAME_BASH_PROFILE=~/Workspace/dotbash/configs/$BOX_HOSTNAME/bash_profile.sh
[ -f $BOX_HOSTNAME_BASH_PROFILE ] && source $BOX_HOSTNAME_BASH_PROFILE

. ~/.bash/env.sh
. ~/.bash/config.sh
. ~/.bash/aliases.sh

CUSTOM=~/.bash/custom
[ -f "$CUSTOM" ] && source $CUSTOM
