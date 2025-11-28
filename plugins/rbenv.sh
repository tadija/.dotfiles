# https://github.com/rbenv/rbenv
# rbenv.sh

function setup-rbenv() {
  # https://stackoverflow.com/a/30191850
  latest=$(rbenv install --list-all | grep -v - | tail -1)
  echo "rbenv installing ruby $latest"
  rbenv install $latest
  rbenv global $latest
  rbenv rehash
}

export PATH="$HOME/.rbenv/shims:$PATH"

if [ -x "$(command -v rbenv)" ]; then
  eval "$(rbenv init -)"
fi
