export PATH=$HOME/npm/bin:$PATH
#export PATH=$HOME/local/node/bin:$PATH
export PATH=$HOME/Downloads/llvm-3.6.0.src/tools/clang/tools/scan-build:$PATH

ngrep() { grep -vE "$@" ;}
xgrep() { xargs grep "$@" 2> /dev/null ;}

filefind() { find "$1" -type f -name "$2" 2> /dev/null ;}

# JS files
jf() { filefind "$@" "*.js" | ngrep "node_modules|bower_components|\.min" ;}
js() { jf "$1" | xgrep "$2" ;}

# markdowns
mf() { filefind "$@" "*.md" | ngrep "node_modules|bower_components" ;}
ms() { mf "$1" | xgrep "$2" ;}

validate() { jsonlint package.json -q ;}

# package/repo fetching shortcuts
aptin() { sudo apt-get install "$1" ;}
aptrem() { sudo apt-get remove "$1" ;}
gclone() { git clone git@github.com:clux/"$1".git ;}

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

movies_unsynced () {
  ls /media/clux/Zorn/NewMP4/BluRay/ | grep "" > zornFiles.log
  ls /media/clux/TOOL/MP4/Movies/ | grep "" > toolFiles.log
  diff toolFiles.log zornFiles.log
  rm toolFiles.log
  rm zornFiles.log
}

# usage: torrent file.torrent
torrent () {
  rsync -chzP -e ssh "$1" broxy:/home/bro/dumptruck/DL/.torr/
}
