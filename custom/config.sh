# https://github.com/tadija/.dotfiles
# config.sh

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

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export TERM='xterm-256color'
export COLORTERM='truecolor'
export EDITOR='nvim'
export LESS='-RXMF'
export PAGER='less'

export MANPAGER='less'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_so=$'\e[1;44;93m'

# Git User
# plugins/git-user.sh

typeset -Ag git_user
git_user[my]="Marko Tadic;tadija@me.com"

# Shell Plugins
# plugins/*.sh

## "system/init.sh" will source each file (included on this list) from "plugins" dir
## any file can be overriden by making a new file with the same name in "custom" dir
dfplugins=(
  my
  bat
  brew
  colors
  defaults
  dotnet
  fastlane
  fzf
  general
  git-user
  git
  hub
  mise
  nvm
  prompt
  random
  rbenv
  subl
  swift
  swiftenv
  vscode
  xcode
  zsh
)

# Quicklook Plugins
# ~/Library/QuickLook

qlplugins=(
  provisioning
  qlcolorcode
  qlmarkdown
  qlstephen
  quicklook-json
)

# Command Line Tools
# /usr/local/Cellar

cli=(
  ast-grep # https://github.com/ast-grep/ast-grep
  bat # https://github.com/sharkdp/bat
  cloc # https://github.com/AlDanial/cloc
  dotnet # https://aka.ms/dotnet/info
  fd # https://github.com/sharkdp/fd
  font-roboto-mono-nerd-font # https://www.nerdfonts.com
  fzf # https://github.com/junegunn/fzf
  gh # https://cli.github.com
  git # https://git-scm.com
  git-lfs # https://git-lfs.github.com
  git-flow # https://github.com/nvie/gitflow
  graphicsmagick # http://www.graphicsmagick.org
  heroku/brew/heroku # https://cli.heroku.com
  htop # https://htop.dev/
  hub # https://hub.github.com
  jq # https://stedolan.github.io/jq
  lazygit # https://github.com/jesseduffield/lazygit
  luarocks # https://luarocks.org
  mas # https://github.com/mas-cli/mas
  mise # https://mise.jdx.dev
  mysql # https://dev.mysql.com
  npm # https://www.npmjs.com
  nvim # https://neovim.io
  pipx # https://pipx.pypa.io
  ranger # https://github.com/ranger/ranger
  rbenv # https://github.com/rbenv/rbenv
  ripgrep # https://github.com/BurntSushi/ripgrep
  swiftly # https://github.com/swiftlang/swiftly
  speedtest-cli # https://github.com/sivel/speedtest-cli
  swiftformat # https://github.com/nicklockwood/SwiftFormat
  swiftgen # https://github.com/SwiftGen/SwiftGen
  swiftlint # https://github.com/realm/SwiftLint
  tig # https://github.com/jonas/tig
  tldr # https://tldr.sh
  tmux # http://tmux.github.io
  tree # http://oldmanprogrammer.net/source.php?dir=projects/tree
  vapor # https://vapor.codes
  wget # https://www.gnu.org/software/wget
  xcbeautify # https://github.com/cpisciotta/xcbeautify
  xcode-build-server # https://github.com/SolaWing/xcode-build-server
  xcp # https://github.com/wojciech-kulik/XcodeProjectCLI
  zsh-autosuggestions # https://github.com/zsh-users/zsh-autosuggestions
  zsh-syntax-highlighting # https://github.com/zsh-users/zsh-syntax-highlighting
)

# Homebrew Apps
# /Applications

apps_installation_path="/Applications"

apps=(
  alfred
  appcleaner
  db-browser-for-sqlite
  docker
  fork
  macdown
  rapidapi
  red-eye
  sequel-ace
  sf-symbols
  sherlock
  simsim
  sketch
  sublime-text
  textmate
  visual-studio-code
  xcodes
  xscope
  zoom
  zed
)

