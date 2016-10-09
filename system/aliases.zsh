# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

# Basic directory operations
alias ..='cd ../'
alias ...='cd ../..'
alias ....='cd ../../..'

# Diff
#   Arguments only work with a function 
alias diffFolder='function _diffFolder(){ diff -qr $1 $2 | grep -v -e 'DS_Store' -e 'Thumbs' };_diffFolder'