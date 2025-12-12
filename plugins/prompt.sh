# https://github.com/tadija/.dotfiles
# prompt.sh

autoload -Uz promptinit vcs_info
promptinit

precmd_vcs_info() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    vcs_info
  else
    vcs_info_msg_0_=""
  fi
}
# add precmd only once
if [[ -z "${precmd_functions[(r)precmd_vcs_info]}" ]]; then
  precmd_functions+=( precmd_vcs_info )
fi

setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%F{yellow}[%b]%f'
zstyle ':vcs_info:git:*' check-for-changes false
zstyle ':vcs_info:*' enable git

# vi mode prompt colors
function zle-keymap-select {
  case $KEYMAP in
    vicmd) VI_MODE="%F{red}[N]%f" ;;
    *)     VI_MODE="%F{green}[I]%f" ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

# set initial mode when shell starts
VI_MODE="%F{green}[I]%f"

PROMPT='${VI_MODE} %F{blue}%~%f ${vcs_info_msg_0_}
%F{green}%n@%m%f %# '

