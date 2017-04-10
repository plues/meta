#!/bin/sh
. ./release_config.sh

rm -rf models
git clone git@github.com:plues/models.git
git submodule update --init

cd models
git checkout -b master --track origin/master
if ! git flow init -f -d; then exit; fi
if ! git flow release start $MODELS_RELEASE; then exit; fi
if ! git submodule update --init; then exit; fi
(cd data; git checkout master; git pull origin master)
git add data
git commit -m 'Updated submodule to the latest release.'

virtualenv venv
. ./venv/bin/activate
pip install -r tests/requirements.txt

sed -itmp -e "s/MODEL_GENERATOR_VERSION=.*/MODEL_GENERATOR_VERSION=$MODEL_GENERATOR_RELEASE/" tests/data/raw/Makefile
sed -itmp -e "s/MINCER_VERSION=.*/MINCER_VERSION=$MINCER_RELEASE/" tests/data/raw/Makefile
git add tests/data/raw/Makefile
git commit -m 'Updated test dependencies to release versions.'
if ! make test-data; then exit; fi

if ! make data.mch solver7_tests tests; then exit; fi

git add tests/data/raw
git commit -m 'Regenerated test data files.'
if ! bumpversion --verbose release; then exit; fi
if ! git flow release finish; then exit; fi

sed -itmp -e "s/MODEL_GENERATOR_VERSION=.*/MODEL_GENERATOR_VERSION=$MODEL_GENERATOR_SNAPSHOT/" tests/data/raw/Makefile
sed -itmp -e "s/MINCER_VERSION=.*/MINCER_VERSION=$MINCER_SNAPSHOT/" tests/data/raw/Makefile
git add tests/data/raw/Makefile
git commit -m 'Updated test dependencies to SNAPSHOT versions.'
if ! make test-data; then exit; fi

git add tests/data/raw
git commit -m 'Regenerated test data files.'
if ! bumpversion --verbose release; then exit; fi
if ! git flow release finish; then exit; fi

(cd data; git checkout develop; git pull)
git add data
git commit -m 'Updated submodule to the latest development version.'
if ! bumpversion --verbose minor; then exit; fi

if ! git push origin master:master --tags; then exit; fi
if ! git push origin develop:develop; then exit; fi
