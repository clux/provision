export PATH=$HOME/npm/bin:$PATH

ngrep() { grep -vE "$@" ;}
xgrep() { xargs grep "$@" 2> /dev/null ;}

filefind() { find "$1" -type f -name "$2" 2> /dev/null ;}

# C++ files
cf() { find "$@" -type f -name *.cpp -o -name *.h -o -name *.c 2> /dev/null ;}
cs() { cf "$1" | xgrep "$2" ;}
hf() { filefind "$@" "*.h" ;}
hs() { hf "$1" | xgrep "$2" ;}

# JS files
jf() { filefind "$@" "*.js" | ngrep "node_modules|bower_components|\.min" ;}
js() { jf "$1" | xgrep "$2" ;}

# markdowns
mf() { filefind "$@" "*.md" | ngrep "node_modules|bower_components" ;}
ms() { mf "$1" | xgrep "$2" ;}

# build system query helpers
srchjam() { find . -type f 2> /dev/null | grep -E "Jamfile|DEPS|Jamrules|opts" | xargs grep -E "$1" ;}
srchcmake() { filefind . "CMakeLists.txt" | xgrep "$1" ;}

alias colorgcc="grc -es -c conf.gcc --colour=on"
nj() { . ./env_linux-amd64.sh && colorgcc INPUT/jam/host/jam -j6 -q "$@" > /dev/null ;}
jj() { . ./env_linux-amd64.sh && colorgcc INPUT/jam/host/jam -j6 -q "$@" ;}
clean() { rm -rf ./cmake/ && jj clean ;}

validate() { jsonlint package.json -q ;}

# package/repo fetching shortcuts
aptin() { sudo apt-get install "$1" ;}
aptrem() { sudo apt-get remove "$1" ;}
gclone() { git clone git@github.com:clux/"$1".git ;}
hclone() { hg clone https://hg.lal.cisco.com/"$1" ;}

# insert xkcd tar joke here
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "unknown extension for '$1'" ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}
# usage: ball output [inputs]
ball () { tar czf "$1.tar" "${@:2}" ;}

#
alias clip="xclip -sel clip"


# git shortlog equivalent
alias hgshort='hg log --template "{author|person}\n" | sort | uniq -c | sort -nr'
# my last changes (use with say -l 10)
alias hgselflast="hg log -u ealbrigt --template \"{date(date, '%d.%m @ %H:%M')} - {desc}\n\""
# ditto but for all users
alias hglast="hg log --template \"{date(date, '%d.%m @ %H:%M')} - {author|user} - {desc}\n\""
