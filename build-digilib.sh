#!/bin/bash

# Copyright (c) 2017 Benjamin W. Bohl

foldername="$(date +%Y%m%d%H%M)_digilib-webapp"
calldir=$(pwd)
builddir="./build/$foldername"
stagingdir="./staging/digilib"
echo
echo "Your settings will be saved to $builddir"
echo
read -n 1 -s -p "Press any key to continue…"

#setup build folders
#mkdir -p ./build
mkdir -p $builddir
rm -Rf $stagingdir
mkdir -p $stagingdir

# unnecessary as sourceforge provides latest download
#filepath="exist-3.2.0.war"

#cp $builddir"../exist-3.2.0.war" $builddir
#curl -L "https://sourceforge.net/projects/digilib/files/latest/download" -o $builddir
#use wget for nc and trust server names
wget -nc --trust-server-names https://sourceforge.net/projects/digilib/files/latest/download -P $builddir

cd $stagingdir
jar xvf $(ls $calldir/$builddir/digilib-webapp*.war)
cd $calldir

#TODO write versioninfo and builddir to stagingdir/versioninfo
