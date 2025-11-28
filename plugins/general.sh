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
alias ll="ls -lo"
alias la="ll -a"

alias grep="grep --color=auto"
alias o="open ."
alias rmd="rm -rf"

alias show="defaults write com.apple.finder AppleShowAllFiles true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles false && killall Finder"

alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias off="pmset sleepnow"

alias paths="echo $PATH | sed 's/:/\n/g' | sort | uniq -c"
