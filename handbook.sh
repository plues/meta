#!/bin/sh
. ./release_config.sh

rm -rf handbook
git clone git@github.com:plues/handbook.git

cd handbook
git checkout -b master --track origin/master
if ! git flow init -f -d; then exit; fi
if ! git flow release start $HANDBOOK_RELEASE; then exit; fi

if ! bumpversion --verbose release; then exit; fi

sed -itmp -e "s/https:\/\/github.com\/plues\/data\/releases\/tag\/.*))/https:\/\/github.com\/plues\/data\/releases\/tag\/$DATA_RELEASE))/" dokumentation.md
sed -itmp -e "s/https:\/\/www3.hhu.de\/stups\/downloads\/plues\/mincer\/mincer.*\.exe/https:\/\/github.com\/plues\/mincer\/releases\/download\/$MINCER_RELEASE\/mincer-$MINCER_RELEASE.exe/" dokumentation.md
sed -itmp -e "s/https:\/\/www3.hhu.de\/stups\/downloads\/plues\/mincer\/mincer.*-standalone\.jar/https:\/\/github.com\/plues\/mincer\/releases\/download\/$MINCER_RELEASE\/mincer-$MINCER_RELEASE-standalone.jar/" dokumentation.md
sed -itmp -e "s/https:\/\/github.com\/plues\/plues\/releases\/tag\/.*))/https:\/\/github.com\/plues\/plues\/releases\/tag\/$PLUES_RELEASE))/" dokumentation.md
sed -itmp -e "s/\*\*plues-.*\*\*/**plues-$PLUES_RELEASE**/" dokumentation.md

if ! make; then exit; fi
git add dokumentation.md
git commit -m "Updated version numbers."

git flow release finish

if ! bumpversion --verbose minor; then exit; fi

sed -itmp -e "s/https:\/\/github.com\/plues\/mincer\/releases\/download\/.*\/mincer-.*\.exe/https:\/\/www3.hhu.de\/stups\/downloads\/plues\/mincer\/mincer-$MINCER_SNAPSHOT.exe/" dokumentation.md
sed -itmp -e "s/https:\/\/github.com\/plues\/mincer\/releases\/download\/.*\/mincer-.*-standalone\.jar/https:\/\/www3.hhu.de\/stups\/downloads\/plues\/mincer\/mincer-$MINCER_SNAPSHOT-standalone\.jar/" dokumentation.md
git add dokumentation.md
git commit -m "Updated version numbers to snapshot."

if ! git push origin master:master --tags; then exit; fi
if ! git push origin develop:develop; then exit; fi
