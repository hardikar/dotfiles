#!/bin/bash

echo "adding special repositories"
# rpm-forge
rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
# EPEL
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
# nux repo for exFat
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm

echo "installing packages"
source install/yum.sh

echo "installing centos settings"
# Settings include setting up config files at right places
# source centos_settings.sh
