. ~/.bash/env
. ~/.bash/config
. ~/.bash/aliases
CUSTOM=~/.bash/custom
if [ -f "$CUSTOM" ]
then
  . $CUSTOM
fi

# added by travis gem
[ -f /Users/hlawson/.travis/travis.sh ] && source /Users/hlawson/.travis/travis.sh
