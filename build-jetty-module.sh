#!/bin/bash

# Copyright (c) 2017 Benjamin W. Bohl

foldername="$(date +%Y%m%d%H%M)_jetty-module"
calldir=$(pwd)
builddir="./build/$foldername"
stagingdir="./staging/jetty"
echo
echo "Your settings will be saved to $builddir"
echo
read -n 1 -s -p "Press any key to continue…"

#setup build folders
#mkdir -p ./build
mkdir -p $builddir
rm -Rf $stagingdir
mkdir -p $stagingdir

#get latest release info
echo
echo
maven="http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution"
echo "retrieving jetty release info from $maven …"
echo
wget -nc $maven/maven-metadata.xml -P "$builddir"

#get latest release name
latest=$(grep -oE '(<latest>)[0-9\.v]+' $builddir/maven-metadata.xml | grep -oE '[0-9\.v]+')

echo "Latest release number is: $latest"
echo
echo $maven/$latest/jetty-distribution-$latest.zip > $builddir/wget.txt
echo $maven/$latest/jetty-distribution-$latest.zip.md5 >> $builddir/wget.txt
wget -nc -i $builddir/wget.txt -P $builddir

checksum=$(cat "$builddir/jetty-distribution-$latest".zip.md5)
calc=$(md5 -q "$builddir/jetty-distribution-$latest".zip)
if [ $calc == $checksum ]
then
  echo "Checksum valid"
  echo "extracting…"
  echo
  unzip $builddir/jetty-distribution-$latest.zip -d $builddir
  mv -f $builddir/jetty-distribution-$latest/* $stagingdir
else
  echo "Checksum validation failed!"
  echo
  echo "Exiting…"
  exit
fi

#TODO write versioninfo and builddir to stagingdir/versioninfo
