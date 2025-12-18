# https://github.com/tadija/.dotfiles
# general.sh

alias ..="cd .."

alias update="brew update && brew upgrade && brew cleanup && mas upgrade"
alias restore='pgrep -vxq tmux && tmux new -d -s delete-me && tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh && tmux kill-session -t delete-me && tmux attach || tmux attach'

case $OSTYPE in
  linux) alias ls='ls --color';;
  darwin) alias ls='ls -GFh';;
  *) ;;
esac

alias la="eza -lah --group-directories-first"
alias ll="la --icons"
alias lt="eza -T --git --icons --level=3"
alias lz="eza -l --total-size --sort=size --reverse"
alias lm="eza -l --sort=modified --reverse"
alias lsd="eza -D --group-directories-first --icons"

alias grep="grep --color=auto"
alias ht="htop -t"
alias hme='htop -u "$USER"'
alias o="open ."
alias rmd="rm -rf"

alias show="defaults write com.apple.finder AppleShowAllFiles true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles false && killall Finder"

alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias off="pmset sleepnow"

alias paths="echo $PATH | sed 's/:/\n/g' | sort | uniq -c"

gt() {
  local dir
  dir="$(eza -D | fzf --preview-window=right:0%)" || return
  cd "$dir"
}

npp() {
  "/mnt/c/Program Files/Notepad++/notepad++.exe" "$(wslpath -w "$1")"
}

