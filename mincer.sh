#!/bin/sh
. ./release_config.sh
. ./release_util.sh
. ./config.sh

rm -rf mincer
git clone $MINCER_REPO

cd mincer
git checkout -b master --track origin/master

if ! git flow init -f -d; then exit; fi
if ! git flow release start $MINCER_RELEASE; then exit; fi
if ! lein ancient; then exit; fi
if ! lein test; then exit; fi

continue_confirmation

if ! bumpversion --verbose --new-version="${MINCER_RELEASE}" release; then exit; fi
if ! git flow release finish; then exit; fi

if ! bumpversion --verbose minor; then exit; fi

push_confirmation "mincer"
