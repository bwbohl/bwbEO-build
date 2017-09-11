#!/bin/bash

cd submodules/webapp-xul-wrapper
echo "switching directory to $(pwd)"
#rm -R xulrunner
#echo "fetching xulrunner"
#bash fetch_xulrunner.sh

#echo
#echo "initializing git submodule…"
#echo $(git submodule init)
#echo
#echo "updating git submodule…"
#echo $(git submodule update)

echo
echo "building"
./build.sh -p m -d
