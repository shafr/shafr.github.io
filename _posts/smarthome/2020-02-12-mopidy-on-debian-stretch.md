---
layout: post
title:  "Mopidy installation and issues"
tags: [mopidy, gstreamer, pip2]
categories: smarthome
---

It took me a while (like 4 attempts) to get mopidy working. 

If it is installed from apt and works - great.  (not in armbian and orangepi case).

If not - there are a lot of broken dependecies. 

Just follow the errors trail and it would be easy to find what's wrong.

### TLDR:
Use python 2.7 and older version of mopidy to avoid all problems (if you don't need all the greatest and latest features):

```
pip2 install --upgrade --force-reinstall mopidy==2.1.0
```

### Add Systemctl file
```
[Unit]
Description=Mopidy music server
After=sound.target

[Service]
User=mopidy
ExecPre=/usr/local/bin/mopidy --config /etc/mopidy/mopidy.conf local scan
ExecStart=/usr/local/bin/mopidy --config /etc/mopidy/mopidy.conf

[Install]
WantedBy=default.target
```

sudo systemctl daemon-reload;

sudo systemctl restart mopidy.service ; journalctl -u mopidy.service -f;

sudo chown -R mopidy /var/lib/mopidy

sudo chown -R mopidy /etc/mopidy


### Issues after install
```
WARNING  Failed local:track:white_noise/fireplace.m4a: No audio found in file.
```

* sudo apt-get install gstreamer1.0-libav

```
ERROR    Failed to create audio output "alsasink device=soundbar": gst_parse_error: no element "alsasink" (1)
```

* apt install gstreamer1.0-alsa

# Going the hard way - attempt to install latest version:

### apt install mopidy

```
The following packages have unmet dependencies:
 mopidy : Depends: python3-pykka but it is not going to be installed
``` 

* pip install pykka
  
``` 
The following packages have unmet dependencies:
 python3-pykka : Depends: sphinx-rtd-theme-common (>= 0.4.3+dfsg) but it is not going to be installed 
```

* pip3 install sphinx-rtd-theme
 
### execute mopidy

```
ERROR: A GObject based library was not found.
...

Please see http://docs.mopidy.com/en/latest/installation/ for
instructions on how to install the required dependencies.

...

ModuleNotFoundError: No module named 'gi'
```

* pip3 install PyGObject

```
...
  Installing collected packages: setuptools, wheel, pycairo
      Running setup.py install for pycairo: started
      Running setup.py install for pycairo: finished with status 'error'
```

* sudo apt-get install libcairo2-dev libjpeg-dev libgif-dev

### execute mopidy again

```
*** Error in `/usr/lib/arm-linux-gnueabihf/gstreamer1.0/gstreamer-1.0/gst-plugin-scanner': free(): invalid pointer: 0xb3b1b5e0 ***
error: XDG_RUNTIME_DIR not set in the environment.
ERROR: Mopidy requires GStreamer >= 1.14.0, but found GStreamer 1.10.4.
```

Nothing here - you'll need to compile this package manually, since only older version exists in repo...