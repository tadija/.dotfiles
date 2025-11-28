# https://github.com/tadija/.dotfiles
# zsh.sh

function detect-platform() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
  elif grep -qi microsoft /proc/version 2>/dev/null; then
    OS="wsl"
  else
    OS="linux"
  fi
}

function zsh-init() {
  autoload -Uz compinit && compinit
  autoload -U colors && colors
}

function zsh-options() {
  # case-insensitive globbing
  setopt NO_CASE_GLOB
  # disable zsh options
  unsetopt CORRECT
  unsetopt CORRECT_ALL
  unsetopt AUTO_CD
}

function zsh-history() {
  # setup history file
  HISTFILE=~/.zsh_history
  HISTSIZE=1000000
  SAVEHIST=1000000
  # show timestamp and elapsed time of the command
  setopt EXTENDED_HISTORY
  # append to history
  setopt APPEND_HISTORY
  # share history across multiple zsh sessions
  setopt SHARE_HISTORY
  # adds commands as they are typed, not at shell exit
  setopt INC_APPEND_HISTORY
  # do not store duplications
  setopt HIST_IGNORE_DUPS
  # removes blank lines from history
  setopt HIST_REDUCE_BLANKS
}

function zsh-bindkeys() {
  # enable vi mode
  bindkey -v
  bindkey jj vi-cmd-mode
  bindkey -M vicmd "/" vi-history-search-forward
  bindkey -M vicmd "?" vi-history-search-backward
}

function source-if-present() {
  if [ -f "$1" ]; then
    source "$1"
  fi
}

function zsh-setup-macos {
  if [ -x "$(command -v brew)" ]; then
    PLUGINS_PATH="$(brew --prefix)/share"
    source-if-present $PLUGINS_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh
    source-if-present $PLUGINS_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
}

function zsh-setup-linux {
  PLUGINS_PATH="/usr/share"
  source-if-present $PLUGINS_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh
  source-if-present $PLUGINS_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}

function zsh-setup() {
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
  case "$OS" in
    macos) zsh-setup-macos ;;
    linux|wsl) zsh-setup-linux ;;
  esac
}

if [ -n "$ZSH_VERSION" ]; then
  detect-platform
  zsh-init
  zsh-options
  zsh-history
  zsh-bindkeys
  zsh-setup
fi

