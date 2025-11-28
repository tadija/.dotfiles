# https://github.com/tadija/.dotfiles
# setup.sh

### - helpers

function print() {
  echo "> $1"
  echo ""
}

function printFile() {
  echo "- Displaying $1"
  dashes=----------------------------------------
  echo "<$dashes"
  cat $1
  echo "$dashes>"
  echo ""
}

function backupFile() {
  if [ -e $1 ]; then
    timestamp=$(date "+%Y%m%d-%H%M%S")
    backupFile=$1-$timestamp.backup
    mv "$1" "$backupFile"
    print "Moved existing $1 -> $backupFile"
  fi
}

### - main

echo ""
print "Hello $USER!"

shellFile=".zshrc"

backupFile "$HOME/$shellFile"
backupFile "$HOME/.gitconfig"
backupFile "$HOME/.lldbinit"
backupFile "$HOME/.tmux.conf"

df=$HOME/.dotfiles
ln -s $df/.shell_file $HOME/.shell_file
ln -s $df/.gitconfig $HOME/.gitconfig
ln -s $df/.lldbinit $HOME/.lldbinit
ln -s $df/.tmux.conf $HOME/.tmux.conf

mv $HOME/.shell_file $HOME/$shellFile

print "This is how your new $shellFile looks now:"
printFile $HOME/$shellFile

print "Loading $shellFile:"
source "$HOME/$shellFile"
echo "" && print "Finished loading $shellFile"

print "See more: https://github.com/tadija/.dotfiles"
