#! /bin/bash


sudo apt install ant bison build-essential ccache curl dirmngr flex git-core iputils-ping iproute2 jq
sudo apt install libapr1-dev libbz2-dev libcurl4-gnutls-dev libevent-dev libkrb5-dev libpam-dev libperl-dev
sudo apt install libreadline-dev libssl-dev libxml2-dev libyaml-dev maven net-tools
sudo apt install pkg-config zlib1g-dev libzstd-dev
sudo apt install python3-pip python3-psutil python3-setuptools python3-dev python3-pygresql

# for 6X_STABLE
sudo apt install python python-dev
wget 'https://bootstrap.pypa.io/pip/2.7/get-pip.py'
python get-pip.py
python -m pip install pygresql psutil pg

# general tools
sudo apt install unzip vim vim-gtk wget ninja-build openssh-server cmake libxml2-utils parallel
sudo apt install clang-11 clang clang-format

 
locale-gen en_US.UTF-8 

mkdir -p ~/.ssh
if [[ ! -f ~/.ssh/id_rsa ]];
then
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    chmod 0600 ~/.ssh/authorized_keys
fi

git clone https://github.com/greenplum-db/gp-xerces.git ~/gp-xerces
pushd ~/gp-xerces
./configure && make -j8
sudo make install
popd

# This step is very much manual
echo yes | sudo cpan -i IPC::Run

# sudo bash -c "echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local.conf"
# sudo pip3 install pygresql psutil pg
