#!/bin/sh
. ./release_config.sh
. ./release_util.sh
. ./config.sh

rm -rf model-generator
git clone $MODELGENERATOR_REPO

cd model-generator
git checkout -b master --track origin/master

if ! git flow init -f -d; then exit; fi
if ! git flow release start $MODEL_GENERATOR_RELEASE; then exit; fi
if ! ./gradlew check; then exit; fi

continue_confirmation

if ! bumpversion --verbose release; then exit; fi
if ! git flow release finish; then exit; fi

if ! bumpversion --verbose minor; then exit; fi

push_confirmation "model-generator"
