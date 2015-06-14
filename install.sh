#!/bin/bash

echo "installing dotfiles"

source install/link.sh

if [ "$(uname)" == "Darwin" ]; then
    echo "running on OSX"
    source install/install_osx.sh
    # homebrew's zsh sits at /usr/local/bin/zsh
    ZSH="/usr/local/bin/zsh"
elif [ "$(uname)" == "Linux" ]; then
    echo "running on Linux"
    # Really I only want to support CentOS for now.
    # source install/install_centos.sh
    ZSH=$(which zsh)
fi

source install/install_all.sh


echo "configuring $ZSH as default shell"
if [[ -z $(grep $ZSH /etc/shells) ]]; then
    sudo -s 'echo /usr/local/bin/zsh >> /etc/shells'
fi
chsh -s $ZSH $USER

