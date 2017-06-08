#!/bin/sh
. ./release_config.sh
. ./release_util.sh
. ./config.sh

rm -rf plues
git clone "${PLUES_REPO}"

cd plues
git submodule update --init

git checkout -b master --track origin/master
if ! git flow init -f -d; then exit; fi
if ! git flow release start $PLUES_RELEASE; then exit; fi

(cd model-generator; git checkout master; git pull)
git add model-generator
git commit -m 'Updated submodule to the latest release.'

sed -itmp -e "s/model_version=.*/model_version=$MODELS_RELEASE/" src/main/resources/main.properties
git add src/main/resources/main.properties
git commit -m 'Updated required version of models.'

sed -itmp -e "s/handbook-url-html=.*/handbook-url-html=https:\/\/github.com\/plues\/handbook\/releases\/download\/$HANDBOOK_RELEASE\/handbook.html/" src/main/resources/main.properties
sed -itmp -e "s/handbook-url-pdf=.*/handbook-url-pdf=https:\/\/github.com\/plues\/handbook\/releases\/download\/$HANDBOOK_RELEASE\/handbook.pdf/" src/main/resources/main.properties
git add src/main/resources/main.properties
git commit -m 'Updated handbook url.'

sed -itmp -e "s/name:'de\.prob2\.kernel', version:.*/name:'de.prob2.kernel', version:'$PROB_VERSION'/" build.gradle

git add build.gradle
git commit -m 'Updated ProB2 to latest release.'

if ! ./gradlew clean check -Pheadless=true; then exit; fi
if ! bumpversion --verbose --new-version="${PLUES_RELEASE}" release; then exit; fi
git flow release finish

(cd model-generator; git checkout develop; git pull)
git add model-generator
git commit -m 'Updated submodule to the latest development version.'

sed -itmp -e "s/model_version=.*/model_version=$MODELS_SNAPSHOT/" src/main/resources/main.properties
git add src/main/resources/main.properties
git commit -m 'Updated required version of models.'

sed -itmp -e "s/handbook-url-html=.*/handbook-url-html=https:\/\/www3.hhu.de\/stups\/downloads\/plues\/handbook\/latest.html/" src/main/resources/main.properties
sed -itmp -e "s/handbook-url-pdf=.*/handbook-url-pdf=https:\/\/www3.hhu.de\/stups\/downloads\/plues\/handbook\/latest.pdf/" src/main/resources/main.properties
git add src/main/resources/main.properties
git commit -m 'Updated handbook url.'

if ! bumpversion --verbose minor; then exit; fi

push_confirmation "plues"
