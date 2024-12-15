#!/bin/bash

set -Eeou pipefail

# color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PLAIN='\033[0m'

echo "Please enter VENDOR for your Android device: "
read VENDOR
echo "Please enter the CODENAME for your Android device: "
read CODENAME
ROOT_FOLDER="android_device_${VENDOR}_${CODENAME}"

echo "Clone an existing repo for a device from https://gitlab.com/ubports/community-ports. \n
Ideally choose a device with similar SoC/Android version as base."
# TODO: a script to automate device selection by specifying only the target device
echo "Enter url to repository for selected device's KERNEL: "
read KERNEL_REPO
echo "Enter url to repository for selected device's meta: "
read META_REPO

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

cd /home/ubpuser/ubports-builds ;
mkdir -p $ROOT_FOLDER ;
cd $ROOT_FOLDER ;
echo -e "${GREEN}GIT CLONE KERNEL $KERNEL_REPO${PLAIN}" ;
git clone --depth 1 $KERNEL_REPO
echo -e "${GREEN}GIT CLONE META $META_REPO${PLAIN}" ;
git clone --depth 1 $META_REPO


