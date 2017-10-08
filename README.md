# lisa-voice-respeaker2mic
L.I.S.A. standalone module for pi zero and respeaker 2 mic PI HAT

## Installation

You need to install the re speaker software http://wiki.seeed.cc/Respeaker_2_Mics_Pi_HAT/

And also L.I.S.A. dependencies:

```
apt-get install -y sox libsox-fmt-all alsa-utils libzmq3-dev libatlas-base-dev libatlas3gf-base

```

Install node dependencies: 

```
npm install
```

You need to export a variable to use respeaker as audio device:

```
export AUDIODEV=hw:1,0
```