#!/bin/bash

echo "installing dotfiles"

echo "initializing submodule(s)"
git submodule update --init --recursive

source install/link.sh

if [ "$(uname)" == "Darwin" ]; then
    echo "running on OSX"
    source osx/install_osx.sh
elif [ "$(uname)" == "Linux" ]; then
    echo "running on Linux"
    # Really I only want to support CentOS for now.
    # source osx/install_centos.sh
fi

echo "configuring zsh as default shell"
chsh -s $(which zsh)

