# https://github.com/tadija/.dotfiles
# config.sh

# git user(s)
typeset -Ag df_git
df_git[my]="Marko Tadic;tadija@me.com"

# defaults
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export COLORTERM='truecolor'
export TERM='xterm-256color'

export EDITOR="$(command -v nvim >/dev/null 2>&1 && echo nvim || echo vim)"
export VISUAL="$EDITOR"

export LESS='-RXMF'
export PAGER='less'

export MANPAGER='less'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_so=$'\e[1;40;36m'

# dot files
dot_files=(
  .shell
  .gitconfig
  .lldbinit
  .tmux.conf
)

# shell plugins
# `system/init.sh` will source each file on this list from "plugins" dir.
# any file can be overriden by a file with the same name in "custom" dir.
df_plugins=(
  bat
  brew
  colors
  dotnet
  fastlane
  fzf
  general
  git
  hub
  mise
  nvm
  orbstack
  prompt
  rbenv
  subl
  swift
  swiftenv
  utils
  vscode
  wsl
  xcode
  zsh
)

# path variable
path=(
  $HOME/bin
  $HOME/.local/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /opt/mssql-tools18/bin
  /usr/local/bin
  /snap/bin
  $path
)
