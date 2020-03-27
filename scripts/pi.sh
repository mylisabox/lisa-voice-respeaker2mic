#!/usr/bin/env bash

apt-get update
apt-get -y upgrade
apt-get install -y curl git
apt-get install -y build-essential

#install node
if which node > /dev/null ; then
    wget https://nodejs.org/dist/latest-v10.x/node-v10.19.0-linux-armv6l.tar.gz
    tar -xvf node-v10.19.0-linux-armv6l.tar.gz
    cd node-v10.19.0-linux-armv6l
    cp -R * /usr/local/
    cd ..
    rm -R node-v10.19.0-linux-armv6l
else
    echo "node is installed, skipping..."
fi

#install yarn
if which yarn > /dev/null ; then
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
    apt-get update && apt-get install -y yarn
else
    echo "yarn is installed, skipping..."
fi

#sox install for sonus speech recognition
apt-get install -y sox libsox-fmt-all alsa-utils libatlas-base-dev

# others
apt-get install -y libzmq3-dev libavahi-compat-libdnssd-dev

#respeaker
git clone https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard
./install.sh

if [ ! -d "/var/www" ]; then
  mkdir /var/www
fi

cd /var/www

git clone https://github.com/jaumard/lisa-voice-respeaker2mic

cd lisa-voice-respeaker2mic
yarn
yarn global add forever

cd /etc/init.d/
wget https://raw.githubusercontent.com/jaumard/lisa-voice-respeaker2mic/master/scripts/lisa
chmod 755 /etc/init.d/lisa
update-rc.d lisa defaults

echo "now reboot your system to make minilisa working"
