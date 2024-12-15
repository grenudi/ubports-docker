#!/bin/bash

# Paths to the directories
ROOT_FOLDER="./permanent_storage"
UBPORTS_FOLDER="./permanent_storage/ubports"
UBPORTS_BUILDS_FOLDER="./permanent_storage/ubports-builds"

#TODO: make sure docker docker-compose is installed , install for both deb and arch

# Check if the root folder exists
if [ ! -d "$ROOT_FOLDER" ]; then
    echo "Root folder $ROOT_FOLDER does not exist. Creating it now..."
    mkdir -p "$ROOT_FOLDER"  # Create root folder
    echo "Root folder $ROOT_FOLDER created successfully."
else
    echo "Root folder $ROOT_FOLDER already exists."
fi

# Check if the ubports folder exists
if [ ! -d "$UBPORTS_FOLDER" ]; then
    echo "Folder $UBPORTS_FOLDER does not exist. Creating it now..."
    mkdir -p "$UBPORTS_FOLDER"  # Create ubports folder
    echo "Folder $UBPORTS_FOLDER created successfully."
else
    echo "Folder $UBPORTS_FOLDER already exists."
fi

# Check if the ubports-builds folder exists
if [ ! -d "$UBPORTS_BUILDS_FOLDER" ]; then
    echo "Folder $UBPORTS_BUILDS_FOLDER does not exist. Creating it now..."
    mkdir -p "$UBPORTS_BUILDS_FOLDER"  # Create ubports-builds folder
    echo "Folder $UBPORTS_BUILDS_FOLDER created successfully."
else
    echo "Folder $UBPORTS_BUILDS_FOLDER already exists."
fi


#udev rules
sudo ./apply-udev-rules.sh

docker-compose up --build

#download repositories