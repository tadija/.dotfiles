# https://github.com/tadija/.dotfiles
# vscode.sh

# https://github.com/microsoft/vscode-remote-release/issues/1688#issuecomment-1708577380
alias sudocode='SUDO_EDITOR="$(which code) --wait" sudoedit'

function sudocodelink() {
    sudocode $(readlink "$1")
}

alias scl='sudocodelink'
