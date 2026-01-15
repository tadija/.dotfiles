if [ "$(uname -s)" = "Linux" ] && [ -r /proc/version ] && grep -qi microsoft /proc/version; then
  npp() {
    "/mnt/c/Program Files/Notepad++/notepad++.exe" "$(wslpath -w "$1")"
  }
  zed() {
    "/mnt/c/Program Files/Zed/zed.exe" "$(wslpath -w "$1")"
  }
fi

