#! /bin/bash

sudo apt-get update -y 
sudo apt-get install -y --no-install-recommends apt-utils openjdk-8-jdk software-properties-common 
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test && apt-get update -y 
sudo apt-get install -y --no-install-recommends gcc-6 g++-6 cmake 
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6 
sudo update-alternatives --config gcc 
sudo gcc --version && g++ --version 

sudo apt-get install -y --no-install-recommends ant \
    bison \
    build-essential \
    ccache \
    curl \
    dirmngr \
    flex \
    git-core \
    iputils-ping \
    iproute2 \
    jq \
    libapr1-dev \
    libbz2-dev \
    libcurl4-gnutls-dev \
    libevent-dev \
    libkrb5-dev \
    libpam-dev \
    libperl-dev \
    libreadline-dev \
    libssl-dev \
    $([ "$BASE_IMAGE" = ubuntu:16.04 ] && echo libxerces-c-dev) \
    libxml2-dev \
    libyaml-dev \
    libzstd1-dev \
    locales \
    maven \
    net-tools \
    ninja-build \
    openssh-server \
    pkg-config \
    python-dev \
    python-pip \
    python-psutil \
    python-setuptools \
    python3-dev \
    less \
    rsync \
    ssh \
    sudo \
    time \
    unzip \
    vim \
    wget \
    zlib1g-dev

sudo rm -rf /var/lib/apt/lists/*
 
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
cpan -i IPC::Run

sudo bash -c "echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local.conf"
