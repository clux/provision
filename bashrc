
#export PATH=$HOME/npm/bin:$PATH
export PATH=$HOME/local/node/bin:$PATH


function xgrep() { xargs grep "$@" 2> /dev/null ;}
function filefind() { find "$1" -type f -name "$2" 2> /dev/null ;}

function cf() { find "$@" -type f -name *.cpp -o -name *.h -o -name *.c 2> /dev/null ;}
function cs() { cf "$1" | xgrep "$2" ;}

function hf() { filefind "$@" "*.h" ;}
function hs() { hf "$1" | xgrep "$2" ;}

function jf() { filefind "$@" "*.js" | grep -vE "node_modules|bower_components|\.min" ;}
function js() { jf "$1" | xgrep "$2" ;}

function mf() { filefind "$@" "*.md" | grep -vE "node_modules|bower_components" ;}
function ms() { mf "$1" | xgrep "$2" ;}

function cmks() { filefind . "CMakeLists.txt" | xgrep "$1" ;}


alias clip="xclip -sel clip"


alias colorgcc="grc -es -c conf.gcc --colour=on"
function nj() { . ./env_linux-amd64.sh && colorgcc INPUT/jam/host/jam -j6 -q "$@" > /dev/null ;}

function validate() { jsonlint package.json -q ;}

function aptin() { sudo apt-get install "$1" ;}
function aptrem() { sudo apt-get remove "$1" ;}
function gclone() { git clone git@github.com:clux/"$1".git ;}


# git shortlog equivalent
alias hgshort='hg log --template "{author|person}\n" | sort | uniq -c | sort -nr'
# my last changes (use with say -l 10)
alias hgselflast="hg log -u ealbrigt --template \"{date(date, '%d.%m @ %H:%M')} - {desc}\n\""
# ditto but for all users
alias hglast="hg log --template \"{date(date, '%d.%m @ %H:%M')} - {author|user} - {desc}\n\""
