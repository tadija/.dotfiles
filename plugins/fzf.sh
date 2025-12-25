# https://github.com/tadija/.dotfiles
# fzf.sh

function setup-fzf() {
  $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
}

load_fzf_bindings() {
  # macOS / homebrew
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh; 
  # WSL / apt 
  if [ -d /usr/share/doc/fzf/examples ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
  fi
}

# https://github.com/junegunn/fzf
if [ -x "$(command -v fzf)" ]; then
  FZF_COMMON_EXCLUDES="--exclude .git --exclude .hg --exclude .svn --exclude node_modules --exclude Pods --exclude Vendor --exclude vendor --exclude build --exclude target --exclude .direnv --exclude .cache --exclude .Trash --exclude Library/Caches"

  export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS" --height 100% --layout=reverse"
  export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS" --preview 'bat --color "always" {}'"

  export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS" --bind pgup:preview-up --bind pgdn:preview-down"
  export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS" --bind='ctrl-p:toggle-preview'"
  export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS" --bind='ctrl-f:execute(open {})'"
  export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS" --bind='ctrl-o:execute(subl {})'"
  export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS" --bind='ctrl-c:execute-silent(cat {} | pbcopy)'"

  export FZF_DEFAULT_COMMAND="fd --type f --hidden $FZF_COMMON_EXCLUDES --max-depth ${FZF_FD_MAX_DEPTH:-12} --strip-cwd-prefix"

  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_T_OPTS="--preview-window=right:60%:wrap"

  export FZF_CTRL_R_OPTS="--preview-window=right:0%"

  export FZF_ALT_C_COMMAND="fd --type d --hidden $FZF_COMMON_EXCLUDES --max-depth ${FZF_ALT_C_MAX_DEPTH:-6}"
  export FZF_ALT_C_OPTS="--preview-window=right:0%"

  # Use fd (https://github.com/sharkdp/fd) instead of the default find command for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden $FZF_COMMON_EXCLUDES . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden $FZF_COMMON_EXCLUDES . "$1"
  }


  if [[ -o interactive ]]; then
    load_fzf_bindings

    (( $+widgets[_fzf_history_widget] )) && bindkey '^R' _fzf_history_widget
    (( $+widgets[_fzf_file_widget] )) && bindkey '^T' _fzf_file_widget
    (( $+widgets[_fzf_cd_widget] )) && bindkey '^[c' _fzf_cd_widget
  fi

  j() {
    local search="$FZF_ALT_C_COMMAND . $HOME"
    local display="fzf $FZF_ALT_C_OPTS -1 -0 -q"
    cd "`$(echo $search) | $(echo $display) "$1"`"
  }

  fif() {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    rg --files-with-matches --no-messages "$1" | \
    fzf --preview-window "right:60%:wrap" \
    --preview "highlight -O ansi -l {} 2> /dev/null | \
    rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || \
    rg --ignore-case --pretty --context 10 '$1' {}"
  }

fi

