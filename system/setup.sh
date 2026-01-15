# https://github.com/tadija/.dotfiles
# setup.sh

source $df/custom/config.sh

### - helpers

function df-print() {
  echo "> $1"
  echo ""
}

function df-print-file() {
  echo "$1"
  dashes=----------------------------------------
  echo "<$dashes"
  cat $1
  echo "$dashes>"
  echo ""
}

function backup-file() {
  if [ -e $1 ]; then
    timestamp=$(date "+%Y%m%d-%H%M%S")
    backupFile=$1-$timestamp.dfb
    mv "$1" "$backupFile"
    df-print "Moved existing $1 -> $backupFile"
  fi
}

function dot-file() {
  local file="$1"
  local action="$2"

  if [ -e "$HOME/.dotfiles/$file" ]; then
    backup-file "$HOME/$file"

    if [ "$action" = "deploy" ]; then
      ln -s "$HOME/.dotfiles/$file" "$HOME/$file"
      df-print "deployed $file"
    fi

    if [ "$action" = "destroy" ]; then
      rm -f "$HOME/$file"
      df-print "destroyed $file"
    fi
  fi
}

### - main

function run() {
  local action="$1"

  echo ""
  df-print "Hello $USER!"

  shellFile=".zshrc"
  backup-file "$HOME/$shellFile"

  for file in "${dot_files[@]}"; do dot-file "$file" "$action"; done

  if [ "$action" = "deploy" ]; then
    mv "$HOME/.shell" "$HOME/$shellFile"
  fi

  if [ "$action" = "destroy" ]; then
    cat <<'EOF' > "$HOME/$shellFile"
autoload -Uz compinit && compinit
PS1='%~ ❯ '
bindkey -v
EOF
  fi

  df-print "Loading $shellFile"
  source "$HOME/$shellFile"
  df-print-file "$HOME/$shellFile"

  if [ "$action" = "deploy" ]; then
    df-print "dot files deployed!"
  fi

  if [ "$action" = "destroy" ]; then
    df-print "dot files destroyed!"
    df-print "setup again with: \`. ~/.dotfiles/system/setup.sh deploy\`"
    df-print "or remove all with \`rm -rf ~/.dotfiles\`"
  fi

  df-print "See more: https://github.com/tadija/.dotfiles"
}

function deploy() {
  run "deploy"
}

function destroy() {
  run "destroy"
}

"$@"

