export PATH=$HOME/local/bin:$PATH
export DOWNLOAD_DIR=/media/clux/Zeus/DL/
alias dl="cd $DOWNLOAD_DIR"
export CC=clang
export CXX=clang++

color_code() { [ "$1" -eq  0 ] && echo "" || echo -e "\e[1;31m[$1]\e[m"; }
yellow() { echo -e "\e[1;33m$1\e[m"; }
PS1='$(color_code $?)\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w $(yellow \$) '

alias grep='grep --colour'

gh='git@github.com:'
ghclone() { git clone ${gh}$1; }

# helpers to search through specific file types
filefind() { find "$1" -type f -name "$2" 2> /dev/null ;}

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
ghclone() { git clone git@github.com:clux/"$1".git ;}
bbclone() { git clone git@bitbucket.org:clux/"$1".git ;}

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

ssh-eval-hack() {
  eval "$(ssh-agent -s)"
  ssh-add  ~/.ssh/github_id_rsa
}

hg-export-reverse() {
  hg export $1 | patch -p1 -R
}

du-biggest() {
  du -hs * | sort -n | tail
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
alias up1="cd .."
alias up2="cd ../.."
alias up3="cd ../../.."
alias up4="cd ../../../.."
alias up5="cd ../../../../.."
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

# TODO: get some more helpers to find new stuff in other directories based on mtime

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

alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"
