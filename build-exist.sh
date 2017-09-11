#!/bin/bash

# Copyright (c) 2017 Benjamin W. Bohl

foldername="$(date +%Y%m%d%H%M)_exist-webapp"
calldir=$(pwd)
builddir="./build/$foldername"
stagingdir="./staging/exist"
echo
echo "Your settings will be saved to $builddir"
echo
read -n 1 -s -p "Press any key to continue…"

#setup build folders
#mkdir -p ./build
mkdir -p $builddir
rm -Rf $stagingdir
mkdir -p $stagingdir

# TODO retrieve filepath of latest release
filepath="exist-3.2.0.war"

# TODO undo temporary cp
cp $builddir/../exist-3.2.0.war $builddir
#curl -L "https://dl.bintray.com/existdb/releases/$filepath" -o $builddir$filepath"exist"

cd $stagingdir
jar xvf $calldir/$builddir/$filepath
cd $calldir

# TODO comments
# TODO get Edirom Online xar
# TODO get SoMa xar
# TODO get sic xar
# TODO get sampleEdition xar
# TODO copy xar files to WEB-INF autodeploy

#TODO write versioninfo and builddir to stagingdir/versioninfo
