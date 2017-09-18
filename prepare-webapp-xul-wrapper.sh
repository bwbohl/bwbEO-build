#!/bin/bash

# Copyright (c) 2017 Benjamin W. Bohl

cd submodules/webapp-xul-wrapper
echo "switching directory to $(pwd)"
echo
echo "fetching xulrunner…"
bash fetch_xulrunner.sh

echo
echo "initializing git submodule…"
echo $(git submodule init)
echo
echo "updating git submodule…"
echo $(git submodule update)

# edirom online module for webapp-xul-wrapper
cp -R ../webapp-xul-wrapper-edirom-online-module/edirom-online/ ./modules/edirom-online/
#echo
#echo "building"
#bash build.sh
