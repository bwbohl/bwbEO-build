#!/bin/bash

# Copyright (c) 2017 Benjamin W. Bohl

# TODO switch between release and develop?

calldir=$(pwd)
builddir="./build"
stagingdir="./staging"

set -o pipefail

FAIL_CMD='echo -e \033[31;1mFAIL\033[0m'
FAILED=0

# check prerequisites
echo
echo "======="
echo "|bwbEO|"
echo "======="
echo
echo "checking build requirements:"
echo "============================"
echo
echo -n "Checking for git: "
which git || { $FAIL_CMD; FAILED=1; }
echo
# senchaCmd
echo "Edirom Online"
echo "-------------"
echo
echo -n "Checking for Sencha Cmd: "
which sencha || { $FAIL_CMD; FAILED=1; }
echo
echo "XAR packaging"
echo "-------------"
#ant
echo -n "Checking for ant: "
which ant || { $FAIL_CMD; FAILED=1; }
echo
echo

#test for fail
#echo -n "Checking for bla: "
#which bla || { $FAIL_CMD; FAILED=1; }
#echo
# TODO try with zotero-standalone-build
#echo "Fetch Zotero standalone build 4.0.29.5"
#echo "============================="
#echo
#git clone -b 4.0.29.5 https://github.com/zotero/zotero-standalone-build.git
#./zotero-standalone-build/scripts/check
## --help hint to mozilla prerequisites

if [ $FAILED == 1 ]
then
  echo "prerequisites not met"
else
  echo "Initializing git submodules…"
  git submodule init
  echo
  echo "Updating git submodules…"
  git submodule update

  echo
  # get eXist
  # build & sign exist as war
  # extract eXist.war
  ## done via build-exist.sh

  # get digilib
  # extract digilib.war to jetty webapps
  ## done via build-digilib.sh

  # get jetty
  ## done via build-jetty-module.sh
  # TODO copy exist and digilib to to jetty webapps

  # TODO conf of jetty and digilib ?port?
  # TODO set bwbEO ports

  # get edirom-online from git
  ## done via submodule

  # build edirom-online.xar
  # TODO determine how to get success/fail feedback from build process
  echo "building Edirom-Online…"
  cd submodules/edirom-online
  bash build.sh
  cd $calldir
  # copy edirom-online.xar to autodeploy
  mv -f ./submodules/Edirom-Online/build-xar/Edirom-Online.xar ./staging/exist/WEB-INF/autodeploy/Edirom-Online.xar

  # build EditionExample
  echo "building EditionExample…"
  cd submodules/EditionExample
  bash ant
  cd $calldir
  # copy edirom-online.xar to autodeploy
  mv -f ./submodules/EditionExample/build/EditionExample*.xar ./staging/exist/WEB-INF/autodeploy/

  # get latest release of source-manager from git
  # build sourceManager
  echo "building sourceManager…"
  cd submodules/sourceManager
  bash ant
  cd $calldir
  # copy edirom-online.xar to autodeploy
  mv -f ./submodules/SourceManager/build/edirom-SoMa-*.xar ./staging/exist/WEB-INF/autodeploy/
  # get latest release of sourceImageCartographer from git

  # build sourceImageCartographer
  echo "building sourceImageCartographer…"
  cd submodules/sourceImageCartographer
  bash ant -Ddigilib.server=http://nashira.upb.de:7000/Scaler/
  # TODO make digilib path configurable in init.sh
  cd $calldir
  # copy edirom-online.xar to autodeploy
  mv -f ./submodules/sourceImageCartographer/build/edirom-sourceImageCartographer-*.xar ./staging/exist/WEB-INF/autodeploy/
  # copy sourceImageCartographer.xar to autodeploy

  # get bwbEO assets
  ## done via prepare-webapp-xul-wrapper.sh

  # build module edirom-online
  ## TODO publish module

  # build module jetty
  #copy jetty to xul-wrapper modules
  cp -Rf $stagingdir/jetty/ ./submodules/webapp-xul-wrapper/modules/jetty/
  #copy exist to jetty webapps
  cp -Rf $stagingdir/exist ./submodules/webapp-xul-wrapper/modules/jetty/webapps/
  #copy digilib to jetty webapps
  cp -Rf $stagingdir/digilib ./submodules/webapp-xul-wrapper/modules/jetty/webapps/

fi
