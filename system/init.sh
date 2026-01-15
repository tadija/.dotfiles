# https://github.com/tadija/.dotfiles
# init.sh

source $df/system/commands.sh
source $df/custom/config.sh

for plugin in $df_plugins; do
  local file=$(df-find $plugin)
  if [ -e "$file" ]; then
    source $file
  fi
done

[ -f ~/.env.local ] && source ~/.env.local

