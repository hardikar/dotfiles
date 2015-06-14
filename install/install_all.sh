#!/bin/sh

# Installation scripts for all OSes run after OS specific scripts

# Install pip packages
echo 'installing pip packages'
source install/pip.sh


# Install Rust
echo 'installing rust'
curl -sSf https://static.rust-lang.org/rustup.sh | sh


