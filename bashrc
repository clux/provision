export PATH=$HOME/local/bin:$PATH
export DOWNLOAD_DIR=/media/clux/Zeus/DL/
alias dl="cd $DOWNLOAD_DIR"
export CC=clang
export CXX=clang++

# helpers to search through specific file types
filefind() { find "$1" -type f -name "$2" 2> /dev/null ;}
# TODO: should probabaly clean up flags rather than dev nulling everything

# JS files
jf() { filefind "$@" "*.js" | grep -vE "node_modules|bower_components|\.min" ;}
js() { jf "$1" | xargs grep "$2" 2> /dev/null ;}

# markdowns
mf() { filefind "$@" "*.md" | grep -vE "node_modules|bower_components" ;}
ms() { mf "$1" | xargs grep "$2" 2> /dev/null ;}

# C++ files
cf() { find "$@" -type f -name *.cpp -o -name *.h -o -name *.c 2> /dev/null ;}
cs() { cf "$1" | xargs grep "$2" 2> /dev/null ;}
hf() { filefind "$@" "*.h" ;}
hs() { hf "$1" | xargs grep "$2" 2> /dev/null ;}

# CMakeLists from PWD
srchcmake() { filefind . "CMakeLists.txt" | xargs grep "$1" 2> /dev/null ;}


node_json_validate() { jsonlint package.json -q ;}
node_init() {
  local dir=$(dirname ${BASH_SOURCE[@]})
  find $dir/templates/npm/ -type f -not -iname pkg.json -exec cp {} $PWD \;
  pkginit
  echo "# $(basename $PWD)" > README.md
  badgify >> README.md
}

# package/repo fetching shortcuts
aptin() { sudo apt-get install "$1" ;}
aptrem() { sudo apt-get remove "$1" ;}
gclone() { git clone git@github.com:clux/"$1".git ;}

# rust helper
rust_doc_update() {
  cargo doc
  local repo=$(basename $PWD)
  echo "<meta http-equiv=refresh content=0;url=$repo/index.html>" > target/doc/index.html
  ghp-import -n target/doc
  git push -qf git@github.com:clux/${repo}.git gh-pages
}

polymer_doc_update() {
  local repo=$(basename $PWD)
  if [ ! -d demo ]; then
    echo "No demo directory found"
    return
  fi
  mkdir components/$repo -p
  cp demo/* components/$repo
  find -maxdepth 1 -type f -exec cp {} components/$repo/ \;
  cp bower_components/* components/ -R
  echo "<meta http-equiv=refresh content=0;url=$repo/index.html>" > components/index.html
  ghp-import -n components
  git push -qf git@github.com:clux/${repo}.git gh-pages
}

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

# longcommand; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history 1 | cut -c 8-)"'

# navigation shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias la="ls -la"
alias lsd="ls -l | grep --color=never '^d'"

# misc helpers
alias week='date +%V'

alias localip="sudo ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d ' ' -f1"

alias cwd='pwd | tr -d "\r\n" | xclip -sel clip'

movies_unsynced () {
  ls /media/clux/Zorn/NewMP4/BluRay/ | grep "" > zornFiles.log
  ls /media/clux/TOOL/MP4/Movies/ | grep "" > toolFiles.log
  diff toolFiles.log zornFiles.log
  rm toolFiles.log
  rm zornFiles.log
}

# usage: broxy_download after having copied a magnet to clipboard
broxy_download () {
  ssh broxy ./brotorr/torrent "\"$(xclip -o -sel clip)\""
}

broxy_check() {
  ssh broxy ls dumptruck/DL
}

# usage: `broxy_fetch name` where name is a substring from broxy_check
broxy_fetch() {
  local rs=$(ssh broxy ./list_downloads.sh | grep $1)
  test -n "$rs" || echo "No grep results for $1"
  local fldr=$(echo $rs | cut -d '/' -f 6)
  test -n "$fldr" || echo "Invalid folder for $rs"
  if [ -n "$fldr" ]; then
    echo "Downloading $fldr"
    rsync -cahzP -e ssh "broxy:$rs" .
    alert
  fi
}
