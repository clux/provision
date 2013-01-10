
export PATH=$HOME/local/node/bin:$HOME/local/bin:$PATH
# TODO: texlive x64
# export PATH=/usr/local/texlive/2012/bin/i386-linux:$PATH

alias serve="python -m SimpleHTTPServer"
function cfind() { find "$@" -type f -iregex '.*\(c|cpp|h\)' ;}
function jsfind() { find "$@" -type f -iregex '.*\(js\)' | grep -v node_modules ;}

# git shortlog equivalent
alias hgshort='hg log --template "{author|person}\n" | sort | uniq -c | sort -nr'
