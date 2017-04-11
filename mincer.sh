#!/bin/sh
. ./release_config.sh
. ./config.sh

rm -rf mincer
git clone $MINCER_REPO

cd mincer 
git checkout -b master --track origin/master

if ! git flow init -f -d; then exit; fi
if ! git flow release start $MINCER_RELEASE; then exit; fi
if ! lein ancient; then exit; fi
if ! lein test; then exit; fi

while true; do
    read -p "Continue? [Y/n] " yn
    case $yn in
        [Yy]* ) break;;
        "" ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no. ";;
    esac
done

if ! bumpversion --verbose release; then exit; fi
if ! git flow release finish; then exit; fi

if ! bumpversion --verbose minor; then exit; fi

if ! git push origin master:master --tags; then exit; fi
if ! git push origin develop:develop; then exit; fi
