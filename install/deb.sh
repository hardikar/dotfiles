#!/bin/bash

apt-get update && apt-get upgrade
apt-get install -y build-essential

apt-get install -y apt-file

apt-get install -y font-inconsolata
apt-get install -y vim-nox git tmux tree cscope

# For installing virutalbox guest additions
sudo apt-get install module-assistant
apt-get install linux-headers-$(uname -r)

