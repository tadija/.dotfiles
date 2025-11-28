# https://github.com/tadija/.dotfiles
# colors.sh

export LSCOLORS=ExFxBxDxCxegedabagacad
export CLICOLOR=1

export CLR_BLACK="\[\e[30m\]"
export CLR_RED="\[\e[31m\]"
export CLR_GREEN="\[\e[32m\]"
export CLR_YELLOW="\[\e[33m\]"
export CLR_BLUE="\[\e[34m\]"
export CLR_MAGENTA="\[\e[35m\]"
export CLR_CYAN="\[\e[36m\]"
export CLR_WHITE="\[\e[37m\]"
export CLR_RESET="\[\e[0m\]"

# red color for root user
if [[ $(id -u) == 0 ]]
then
  export CLR_USER=$CLR_RED
else
  export CLR_USER=$CLR_GREEN
fi
