. ~/.bash/env
. ~/.bash/config
. ~/.bash/aliases
custom="~/.bash/custom"
if [ -b "$custom" ]
then
  . $custom
fi
