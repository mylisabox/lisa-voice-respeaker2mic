#!/usr/bin/env bash

apt-get update
apt-get install -y curl git
apt-get install -y build-essential

#install node
if which node > /dev/null ; then
    curl -sL https://deb.nodesource.com/setup_8.x | bash -
    apt-get install -y nodejs
else
    echo "node is installed, skipping..."
fi

#install yarn
if which yarn > /dev/null ; then
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
    apt-get update && apt-get install -y yarn
fi

#sox install for sonus speech recognition
apt-get install -y sox libsox-fmt-all alsa-utils libatlas-base-dev libatlas3gf-base

#matrix board
echo "deb http://packages.matrix.one/matrix-creator/ ./" | sudo tee --append /etc/apt/sources.list
apt-get update
apt-get upgrade
apt-get install -y libzmq3-dev matrix-creator-init matrix-creator-malos
echo 'export AUDIODEV=mic_channel8' >>~/.bash_profile
echo 'export LANG=en-US' >>~/.bash_profile
source ~/.bash_profile

if [ ! -d "/var/www" ]; then
  mkdir /var/www
fi

cd /var/www

git clone https://github.com/jaumard/lisa-voice-respeaker2mic

cd lisa-voice-respeaker2mic
yarn