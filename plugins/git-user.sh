# https://github.com/tadija/.dotfiles
# git-user.sh

function git-user() {
  value=${git_user[$1]}
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
    git-who
  fi
}

function git-who() {
  echo "git user: $(git config user.name) | $(git config user.email)"
}
