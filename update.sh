#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TMP_DIR=$DIR/.tmp
rm -rf $TMP_DIR
git clone https://github.com/aveltras/arohi $TMP_DIR
rm -rf $DIR/app
cp -r $TMP_DIR/skeleton $DIR/app
mv $DIR/app/skeleton.cabal $DIR/app/app.cabal
sed -i 's/skeleton/app/g' $DIR/app/app.cabal
rm -rf $TMP_DIR
git add app/
git commit -m 'Bring up to date with arohi repo'
