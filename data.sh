#!/bin/sh
. ./release_config.sh
. ./release_util.sh
. ./config.sh

rm -rf data
git clone "${DATA_REPO}"

cd data
git checkout -b master --track origin/master

if ! git flow init -f -d; then exit; fi
if ! git flow release start $DATA_RELEASE; then exit; fi
if ! bumpversion --new-version="${DATA_RELEASE}" patch; then exit; fi

sed -itmp -e "s/MODEL_GENERATOR_VERSION=.*/MODEL_GENERATOR_VERSION=$MODEL_GENERATOR_RELEASE/" Makefile
sed -itmp -e "s/MINCER_VERSION=.*/MINCER_VERSION=$MINCER_RELEASE/" Makefile

if ! make data.mch; then exit; fi

git add Makefile
git commit -m "Update tool version numbers."
if ! git flow release finish; then exit; fi

sed -itmp -e "s/MODEL_GENERATOR_VERSION=.*/MODEL_GENERATOR_VERSION=$MODEL_GENERATOR_SNAPSHOT/" Makefile
sed -itmp -e "s/MINCER_VERSION=.*/MINCER_VERSION=$MINCER_SNAPSHOT/" Makefile
if ! make data.mch; then exit; fi
git add Makefile
git commit -m "Update tool version numbers to SNAPSHOT release."

if ! bumpversion --verbose minor; then exit; fi

push_confirmation "data"
