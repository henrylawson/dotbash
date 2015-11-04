. ~/.bash/env
. ~/.bash/config
. ~/.bash/aliases
CUSTOM=~/.bash/custom
if [ -f "$CUSTOM" ]
then
  . $CUSTOM
fi
