# Colors from http://wiki.archlinux.org/index.php/Color_Bash_Prompt
# misc
NO_COLOR='\e[0m' #disable any colors
# regular colors
BLACK='\e[0;30m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'
# emphasized (bolded) colors
EBLACK='\e[1;30m'
ERED='\e[1;31m'
EGREEN='\e[1;32m'
EYELLOW='\e[1;33m'
EBLUE='\e[1;34m'
EMAGENTA='\e[1;35m'
ECYAN='\e[1;36m'
EWHITE='\e[1;37m'
# underlined colors
UBLACK='\e[4;30m'
URED='\e[4;31m'
UGREEN='\e[4;32m'
UYELLOW='\e[4;33m'
UBLUE='\e[4;34m'
UMAGENTA='\e[4;35m'
UCYAN='\e[4;36m'
UWHITE='\e[4;37m'
# background colors
BBLACK='\e[40m'
BRED='\e[41m'
BGREEN='\e[42m'
BYELLOW='\e[43m'
BBLUE='\e[44m'
BMAGENTA='\e[45m'
BCYAN='\e[46m'
BWHITE='\e[47m'

export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
	local EXIT="$?"
	local EXIT_CODE="\[$CYAN\][$EXIT]\[$NO_COLOR\]"
  local HOST_USER="\[$RED\][\u@\h]\[$NO_COLOR\]"
	local CURRENT_PATH="\[$BLUE\]\w\[$NO_COLOR\]"
	local VCS_PROMPT="\[$EBLACK\]\$(vcprompt)\[$NO_COLOR\]"
	local INPUT_PROMPT="\[$RED\]$\[$NO_COLOR\]"
	
	PS1=""
	if [ $EXIT != 0 ]; then
		PS1+="$EXIT_CODE\n"
	fi
	
	PS1+="\n$HOST_USER:$CURRENT_PATH $VCS_PROMPT \n$INPUT_PROMPT "
}

INPUT_PROMPT_SECONDARY="\[$RED\]>\[$NO_COLOR\]"
PS2="$INPUT_PROMPT_SECONDARY "
