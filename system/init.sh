# https://github.com/tadija/.dotfiles
# init.sh

source $df/custom/config.sh
source $df/system/commands.sh

for plugin in $dfplugins; do
  local file=$(df-find $plugin)
  if [ -e "$file" ]; then
    source $file
  fi
done

[ -f ~/.env.local ] && source ~/.env.local
