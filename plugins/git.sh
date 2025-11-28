# https://github.com/tadija/.dotfiles
# git.sh

function git() {
  # check if we're in WSL
  if [ -f /proc/sys/kernel/osrelease ] && grep -qi "microsoft" /proc/sys/kernel/osrelease; then
    # check if current directory is on a Windows-mounted drive (/mnt/*)
    if [[ $(pwd -P) =~ ^/mnt/[a-zA-Z]/ ]]; then
      git.exe "$@"
    else
      command git "$@"
    fi
  else
    # not in WSL, use default git
    command git "$@"
  fi
}

alias gits="git status"
alias gitstate="git remote update && git status -uno"
alias gitgraph="git log --pretty=format:'%h %s' --graph"
alias gitsmupdate="git submodule update --init --recursive"
alias gitsmpull="git submodule foreach git pull origin master"
alias gitcm="git add . && git commit --allow-empty-message -m ''"
alias gitam="git add . && git commit --amend --no-edit --allow-empty-message"
alias gitamd="git commit --amend --date=now"
alias gitcmui="git add . && git gui citool"
alias gitamui="git add . && git gui citool --amend"
alias gitss="gitStashWithTimestamp"
alias gitsa="git stash apply"
alias gitssa="gitss && gitsa"
alias gitsc="git stash clear"
alias gitundo="git reset --soft HEAD^"
alias gitrh="git reset --hard"
alias gitlocstr="echo \"*.strings diff=localizablestrings\" > .gitattributes"
alias gitcleanup="git remote prune origin && git repack && git prune-packed && git reflog expire --expire=1.month.ago && git gc --aggressive"
alias gitdt="git difftool -y"
alias gitmt="git mergetool -y"
alias gitpf="git push --force"
alias gitsy="gitss && git pull && gitsa"
alias gitsyf="gitss && gitundo && gitrh && git pull && gitsa"

function gitStashWithTimestamp() {
  ts=$(date "+%Y%m%d-%H%M%S")
  git stash save $ts
}

function gitlog() {
  git log --oneline --reverse --no-decorate $(git branch --show-current) -n "${1-10}"
}

function gitlogbranch() {
  git log --oneline --reverse --no-decorate $(gitParentBranch)..$(git branch --show-current)
}

function gitParentBranch() {
  git reflog show --no-abbrev $(git branch --show-current) | grep "branch: Created from" | awk '{print $1;}'
}

alias lg="lazygit"
