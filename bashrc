
export PATH=$HOME/local/node/bin:$HOME/local/bin:$PATH
# TODO: texlive x64
# export PATH=/usr/local/texlive/2012/bin/i386-linux:$PATH

alias serve="python -m SimpleHTTPServer"
function cf() { find "$@" -type f -name *.cpp -o -name *.h -o -name *.c ;}
function cs() { find "$1" -type f -name *.cpp -o -name *.h -o -name *.c | xargs grep "$2" ;}
function hf() { find "$@" -type f -name *.h ;}
function hs() { find "$1" -type f -name *.h | xargs grep "$2" ;}
function jf() { find "$@" -type f -name *.js | grep -v node_modules ;}
function nj() { . ./env_linux-amd64.sh && jam -j8 -q "$@" > /dev/null; }

# git shortlog equivalent
alias hgshort='hg log --template "{author|person}\n" | sort | uniq -c | sort -nr'
