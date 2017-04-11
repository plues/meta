#!/bin/sh
. ./release_config.sh
. ./config.sh

rm -rf model-generator
git clone $MODELGENERATOR_REPO

cd model-generator
git checkout -b master --track origin/master

if ! git flow init -f -d; then exit; fi
if ! git flow release start $MODEL_GENERATOR_RELEASE; then exit; fi
if ! ./gradlew check; then exit; fi

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
