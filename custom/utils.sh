# https://github.com/tadija/.dotfiles
# my.sh

function my-radio() {
  echo "configuring radio..."
  cd ~/Downloads
  curl https://tadija.net/random/radio.zip > radio.zip
  unzip -qq radio.zip
  yes | cp -rf Radio.app /Applications
  rm radio.zip
  rm -rf Radio.app
  open -a /Applications/Radio.app
  cd -
  echo "ready to play! (check the menu bar)"
}

function my-dotfiles() {
  ln -s ~/Developer/GitHub/.dotfiles ~/.dotfiles
  la ~/.dotfiles
}

function my-cloud() {
  ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs ~/Cloud
  la ~/Cloud
}

function my-defaults() {
  # disable cursor blinking globally
  defaults write -g NSTextInsertionPointBlinkPeriod -float 60000
  # enable simulator beside Xcode in full screen mode
  defaults write com.apple.iphonesimulator AllowFullscreenMode -bool YES
  # show number of remaining files when indexing a project in xcode
  defaults write com.apple.dtXcode IDEIndexerActivityShowNumericProgress -bool true
  # disable creating .DS_Store file on network volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
}

function my-npm() {
  npm install -g @zed-industries/codex-acp
  npm install -g @zed-industries/claude-code-acp
}

function my-ssh() {
  cp -rf ~/Cloud/Documents/Sync/.ssh ~/.ssh
  cd ~/.ssh && la

  # chmod 400 each private key
  fd -e pub -x chmod 400 {.}

  # ssh-add --apple-use-keychain each private key manually
}

function my-tmux() {
  # install tmux plugin manager
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  if tmux ls; then
    # reload tmux
    tmux source-file ~/.tmux.conf
    echo "tmux reloaded"
  else
    # start new session
    tmux new-session
  fi
  # prefix + I (load plugins)
  # https://github.com/tmux-plugins/tmux-resurrect
  # https://github.com/tmux-plugins/tmux-continuum
}

function my-nvim() {
  mv ~/.config/nvim ~/.config/nvim-backup
  ln -s ~/.dotfiles/plugins/nvim ~/.config/nvim
}

function my-nvim-reset() {
  rm -rf ~/.local/share/nvim 2>/dev/null
  rm -rf ~/.local/state/nvim 2>/dev/null
  rm -rf ~/.cache/nvim 2>/dev/null
}

function my-nvim-backup() {
  mv ~/.local/share/nvim ~/.local/share/nvim-backup 2>/dev/null
  mv ~/.local/state/nvim ~/.local/state/nvim-backup 2>/dev/null
  mv ~/.cache/nvim ~/.cache/nvim-backup 2>/dev/null
}

function my-nvim-restore() {
  mv ~/.local/share/nvim-backup ~/.local/share/nvim 2>/dev/null
  mv ~/.local/state/nvim-backup ~/.local/state/nvim 2>/dev/null
  mv ~/.cache/nvim-backup ~/.cache/nvim 2>/dev/null
}

function my-plugins() {
  setup-fzf
  echo ""
  setup-rbenv
  echo ""
  setup-fastlane
  echo ""
  gem install cocoapods
  echo ""
}

function my-bin() {
  sudo mkdir -p /usr/local/bin
  sudo chown -R $(id -nu):admin /usr/local/bin
}

function my-services() {
  sudo rm -rf ~/Library/Services
  ln -s ~/Cloud/Documents/Sync/Services ~/Library/Services
  la ~/Library/Services
}

function my-sublime() {
  rm -rf ~/Library/Application\ Support/Sublime\ Text/Packages/User
  ln -s ~/Cloud/Documents/Sync/Sublime/User ~/Library/Application\ Support/Sublime\ Text/Packages/User
  la ~/Library/Application\ Support/Sublime\ Text/Packages/User
}

function my-xcode() {
  cd ~/Library/Developer/Xcode/UserData

  rmd CodeSnippets
  ln -s ~/Cloud/Documents/Sync/Xcode/CodeSnippets CodeSnippets

  rmd FontAndColorThemes
  ln -s ~/Cloud/Documents/Sync/Xcode/FontAndColorThemes FontAndColorThemes

  rmd KeyBindings
  ln -s ~/Cloud/Documents/Sync/Xcode/KeyBindings KeyBindings

  rmd xcdebugger
  ln -s ~/Cloud/Documents/Sync/Xcode/xcdebugger xcdebugger

  la ~/Library/Developer/Xcode/UserData
  cd -

  # select command line tools version
  # import accounts for code signing
}

function my-greenfield() {
  curl -L "tadija.net/swift-greenfield" | bash -s "$1"
}

function my-homebridge() {
  sudo npm install -g --unsafe-perm homebridge homebridge-config-ui-x
  sudo hb-service install
}

