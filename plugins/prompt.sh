# https://github.com/tadija/.dotfiles
# prompt.sh

autoload -Uz promptinit
promptinit

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%F{yellow}[%b]%f'
zstyle ':vcs_info:*' enable git

# vi mode prompt colors
function zle-keymap-select {
  case $KEYMAP in
    vicmd)      VI_MODE="%F{red}[N]%f" ;;
    viins|main) VI_MODE="%F{green}[I]%f" ;;
    *)          VI_MODE="%F{yellow}[?]%f" ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

# set initial mode when shell starts
VI_MODE="%F{green}[I]%f"

PROMPT='${VI_MODE} %F{blue}%~%f ${vcs_info_msg_0_}
%F{green}%n@%m%f %# '
