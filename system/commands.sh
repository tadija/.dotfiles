# https://github.com/tadija/.dotfiles
# commands.sh

function df-reload() {
  source ~/.zshrc
  echo "platform: $OS"
}

function df-find() {
  local system="$df/system/$1.sh"
  local custom="$df/custom/$1.sh"
  local plugin="$df/plugins/$1.sh"

  if [ -e "$system" ]; then
    echo "$system"
  elif [ -e "$custom" ]; then
    echo "$custom"
  elif [ -e "$plugin" ]; then
    echo "$plugin"
  fi
}

function df-edit() {
  local file=$(df-find $1)

  if [ -e "$file" ]; then
    if [ -z "$EDITOR" ]; then
      open -t $file
    else
      $(echo $EDITOR) $file
    fi
  else
    cd $df
  fi
}

function df-run() {
  local file=$(df-find $1)

  if [ -e "$file" ]; then
    . "$file"
  else
    echo "not found: $1"
  fi
}

function df-update() {
  cd $df
  git stash
  git fetch && git pull
  git stash apply
  df-reload
}

function df-terminal() {
  local theme="$1"
  local file=$df/themes/$theme.terminal

  if [ -e "$file" ]; then
    echo "configuring theme for terminal..."
    open $file
    sleep 1
    defaults write com.apple.Terminal "Default Window Settings" -string $theme
    defaults write com.apple.Terminal "Startup Window Settings" -string $theme
    exit 0
  else
    echo "not found: $1"
  fi
}

function df-homebrew() {
  echo "[brew] checking..."
  if ! [ -x "$(command -v brew)" ]; then
    echo "[brew] installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  echo "[brew] updating..."
  brew update
  brew upgrade

  echo "[brew] cleanup..."
  brew cleanup

  # see: https://github.com/zsh-users/zsh-completions/issues/680#issuecomment-612960481
  compaudit | xargs chmod g-w
}

function df-install() {
  df-homebrew

  echo ""
  echo "[brew] installing quicklook plugins..."
  brew install --cask ${qlplugins[@]}
  # remove the quarantine attribute (see: https://github.com/sindresorhus/quick-look-plugins)
  xattr -d -r com.apple.quarantine ~/Library/QuickLook

  echo ""
  echo "[brew] installing command line tools..."
  brew install ${cli[@]}

  echo ""
  echo "[brew] installing apps..."
  brew install --cask --appdir=$apps_installation_path ${apps[@]} --force

  echo ""
  echo -e "[brew] cleanup...\n"

  brew cleanup
}
