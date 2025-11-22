# https://github.com/tadija/AEDotFiles
# swift.sh

alias sb="swift build"
alias st="swift test"
alias sr="swift run"
alias sp="swift package"
alias spi="swift package init"
alias spiexe="swift package init --type executable"
alias spu="swift package update"
alias spx="swift package generate-xcodeproj"
alias spm="swift package manager"

if [ -f "$HOME/.local/share/swiftly/env.sh" ]; then
  . "$HOME/.local/share/swiftly/env.sh"
fi
