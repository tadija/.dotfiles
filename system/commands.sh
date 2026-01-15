# https://github.com/tadija/.dotfiles
# commands.sh

source $df/custom/config.sh
source $df/custom/install.sh

function df-reload() {
  source ~/.zshrc
  echo "platform: $OS"
  exec zsh
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

function df-destroy() {
  . $df/system/setup.sh destroy
}
function df-deploy() {
  . $df/system/setup.sh deploy
}

# usage: df-terminal AE
# afterwards: `rm ~/.zcompdump` and restart Terminal
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
  echo "[brew] installing command line tools..."
  brew install ${cli_tools[@]} --force

  echo ""
  echo "[brew] installing apps..."
  brew install --cask --appdir=$apps_path ${apps[@]} --force

  echo ""
  echo -e "[brew] cleanup...\n"

  brew cleanup
}

function df-git-usr() {
  echo "git user: $(git config user.name) | $(git config user.email)"
}

function df-git() {
  value=${df_git[$1]}
  name=$(echo $value | cut -d ';' -f1)
  email=$(echo $value | cut -d ';' -f2)

  if [[ -z $name || -z $email ]]; then
    echo "name or email not found in git_user[$1]"
  else
    if [[ $2 == "--global" ]]; then
      echo "configuring global git user..."
      git config --global user.name $name
      git config --global user.email $email
    else
      echo "configuring local git user..."
      git config user.name $name
      git config user.email $email
    fi
    # print current git user after change
    df-git-usr
  fi
}

