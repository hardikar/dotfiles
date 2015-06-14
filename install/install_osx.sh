#!/bin/bash

echo "installing homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "brewing all the things"
source install/brew.sh

echo "updating OSX settings"
# source osx_settings.sh

