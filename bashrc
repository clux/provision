
export PATH=$HOME/local/node/bin:$HOME/local/bin:$PATH
# TODO: texlive x64
# export PATH=/usr/local/texlive/2012/bin/i386-linux:$PATH

alias serve="python -m SimpleHTTPServer"
function cf() { find "$@" -type f -name *.cpp -o -name *.h -o -name *.c ;}
function cs() { cf "$1" | xargs grep "$2" ;}
function hf() { find "$@" -type f -name *.h ;}
function hs() { hf "$1" | xargs grep "$2" ;}
function jf() { find "$@" -type f -name *.js | grep -vE "node_modules|bower_components|\.min" ;}
function js() { jf "$1" | xargs grep "$2" ;}
function mf() { find "$@" -type f -name *.md | grep -vE "node_modules|bower_components" ;}
function ms() { mf "$1" | xargs grep "$2" ;}

alias colorgcc="grc -es -c conf.gcc --colour=on"
function nj() { . ./env_linux-amd64.sh && colorgcc jam -j8 -q "$@" > /dev/null ;}

function validate() { jsonlint package.json > /dev/null ;}


# git shortlog equivalent
alias hgshort='hg log --template "{author|person}\n" | sort | uniq -c | sort -nr'
# my last changes (use with say -l 10)
alias hgselflast="hg log -u ealbrigt --template \"{date(date, '%d.%m @ %H:%M')} - {desc}\n\""
# ditto but for all users
alias hglast="hg log --template \"{date(date, '%d.%m @ %H:%M')} - {author|user} - {desc}\n\""
