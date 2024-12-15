#!/bin/bash

set -Eeou pipefail

# color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PLAIN='\033[0m'

# Define the container name or ID
CONTAINER_NAME="ubports-docker"
HALIUM_REPO="https://github.com/Halium/android"
echo "Please enter the Halium VERSION (e.g., 7.1, 10.0, etc.): "
read HALIUM_VERSION
echo "Please enter VENDOR for your Android device: "
read VENDOR
echo "Please enter the CODENAME for your Android device: "
read CODENAME
ROOT_FOLDER="android_device_${VENDOR}_${CODENAME}"
echo "Please enter how many JOBS you want to use when syncing repo: "
read JOBS

# Validate the input (optional)
if [[ -z "$HALIUM_VERSION" ]]; then
  echo "You must provide a Halium version. Exiting."
  exit 1
fi


cd /home/ubpuser/ubports-builds ;
mkdir -p $ROOT_FOLDER ;
cd $ROOT_FOLDER ;
mkdir -p "halium-$HALIUM_VERSION" ;
cd "halium-$HALIUM_VERSION" ;

# https://stackoverflow.com/questions/78396934/error-1824-bytes-of-body-are-still-expected-while-cloning-repository-from-git
# 1GB
# git config --global http.postBuffer 1073741824
# 100MB
git config --global http.postBuffer 104857600
git config --global http.version HTTP/1.1
git config --global core.compression 0
git config --global pack.window 10
git config --global pack.depth 50
git config --global pack.windowSize 10m
git config --global pack.packSizeLimit 2m
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 99999
git config --global http.keepAlive true

echo -e "${GREEN}INIT REPO${PLAIN}" ;
repo init -u $HALIUM_REPO -b "halium-$HALIUM_VERSION" --depth=1 --no-clone-bundle;

echo -e "${GREEN}SYNC START. This can take a very long time${PLAIN}" ;
repo sync -c --jobs=$JOBS --no-tags --force-sync --no-clone-bundle --optimized-fetch --prune;
repo sync -c --jobs=$JOBS --no-tags --force-sync --no-clone-bundle --optimized-fetch --prune;

