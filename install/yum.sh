#!/bin/bash

# This will download and install all the packages in the "Server with GUI" group
# TODO : remove this when the required packages have been narrowed down.
# yum groupinstall -y "Server with GUI"


# Install a "minimal" graphical system
# https://www.centos.org/forums/viewtopic.php?t=47088
# Use startx after this to start the X window system
yum groupinstall -y "X Window System"
yum install -y gnome-classic-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts


# Install missing development tools
yum groupinstall -y "Development Tools"
yum install -y java-1.7.0-openjdk.x86_64
yum install -y java-1.8.0-openjdk.x86_64
yum install -y python-pip

# Install other useful tools
yum install -y ffmpeg ffprobe
yum install -y youtube-dl
yum install -y tree
yum install -y zsh
yum install -y tmux
yum install -y vim

# Install NTFS
yum install -y ntfs-3g

# Install exFAT
yum install -y exfat-utils fuse-exfat

# Install ZFS
yum install -y kernel-devel zfs


# Install hardware monitoring tools
yum install -y lm_sensors
yum install -y hddtemp


