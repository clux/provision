#!/usr/bin/env bash

# only set prefix if we didn't install from source
#npm config set prefix ~/npm
#npm config set loglevel info

globalModules=(
  ansimd      # markdown viewer terminal
  jshint      # static analysis
  jsonlint    # analysis of json files
  json        # curl jsonUrl | json key
  nd          # nd `moduleName` for README.md in stdout
  npm         # alwyas update this
  pkginit     # for quick making a npm module shell (though bugged atm)
  browserify  # npm style webapps
  testling    # for browser tests
  asciify     # CLI asciifier
  ytdl        # streaming youtube downloader
  symlink     # node module link helper
  badgify     # readme badge generator
  bower       # web components currently here..
  # tests
  nodeunit
  tap
  coveralls
  jscoverage
  vulcanize   # polymer concat
)
for i in ${globalModules[@]}
do
  echo $i
  npm install -g $i
done

pkginit add default pkg.json
