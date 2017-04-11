#!/bin/sh

. ./config.sh

rm -rf artifacts
mkdir artifacts

#
# mincer
if [ ! -d mincer/.git ]; then git clone $MINCERREPO; fi

cd mincer
git checkout -b master --track origin/master
git pull --rebase

lein uberjar launch4j

# copy mincer artifacts
cd ../
find mincer/target -name "*standalone*" -or -name "*.exe" | xargs  -I {} cp {} artifacts/

#
# model-generator
if [ ! -d model-generator/.git ]; then git clone "${MODELGENERATOR_REPO}"; fi

cd model-generator
git checkout -b master --track origin/master
git pull --rebase

./gradlew buildStandaloneJar
cd ../
find model-generator/build/libs -name "*.jar*" | xargs -I {} cp {} artifacts/

#
# databases
if [ ! -d data/.git ]; then git clone "${DATA_REPO}"; fi

cd data
git checkout -b master --track origin/master
git pull --rebase

mkdir bin/
cp ../artifacts/* bin/

make philfak-data.sqlite3
make cs-data.sqlite3 flavor=cs
make wiwi-data.sqlite3 flavor=wiwi

cd ../
find data/ -name "*-data.sqlite3" | xargs -I {} cp {} artifacts/

# handbooks
if [ ! -d handbook/.git ]; then git clone "${HANDBOOK_REPO}"; fi

cd handbook
git checkout -b master --track origin/master
git pull --rebase

make

cd ../
find handbook/ -name "handbook-*" | xargs -I {} cp {} artifacts/
#
# models
if [ ! -d models/.git ]; then git clone "${MODELS_REPO}"; fi

cd models
git submodule update --init
git checkout -b master --track origin/master
git pull --rebase

make very_clean dist

cd ../
cp models/dist/models.zip artifacts

#
# plues
if [ ! -d plues/.git ]; then git clone "${PLUES_REPO}"; fi

cd plues
git submodule update --init
git checkout -b master --track origin/master
git pull --rebase

cp ../artifacts/models.zip src/main/resources/models.zip

mkdir src/main/resources/doc/
find ../artifacts -name "handbook-*.pdf" | xargs -I {} cp {} src/main/resources/doc/handbook.pdf
find ../artifacts -name "handbook-*.html" | xargs -I {} cp {} src/main/resources/doc/handbook.html

./gradlew clean createDmg winZip distTar


cd ../

find plues/build/distributions -name "plues*.tar" -or -name "plues*.zip" -or -name "plues*.dmg" | xargs -I {} cp -v {} artifacts/

echo "DONE"
