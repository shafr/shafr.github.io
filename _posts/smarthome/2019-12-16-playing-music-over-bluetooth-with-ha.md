---
layout: post
title:  "Using Bluetooth Speaker and White noise with Home Assistant"
tags: ["Mopidy", "Home Assistant", "bluetooth", "bluealza"]
categories: smarthome
---

![Mopidy tab view](/assets/2019-12-16/mopidy_tab.png)

So since the child was born my wife had this idea that we need white noise in bedroom. I've made a quick dirty implementation with small speakers + usb-bluetooth <-> AUX adapter  and Android phone connected over bluetooth.

Problem being that if you had to stop/start or change volume you had to carry phone with you (and charge it) or keep it on charger constantly and reach over to it to change sounds and volume.

I was looking into solution from my Smart Home standpoint - a way to play using `Home Assistant`. I had some experience using MPD and `PI MusicBox` with playing radio stations on my Rpi Zero W, but it was too laggy for 1 CPU.

I recommend reading [GUIDE][complete-flow] for detailed instructions on installation. I will just provide high level guide.

## Building all pre-requesites (checklist)
We would need few tools/packages for it to work:

* bluez
* bluealsa
* mopidy
* bluetoothctl

### Installing bluez
If you don't have already - grab latest distributive (or one that is known to be bug-free) from http://www.bluez.org. (Follow GUIDE for details)

### Installing bluealsa
For me bluealsa was not available as a package so I had to grab a source code, compile and install it. After that I had to create service to be able to start it with os and control it:

```bash
[Unit]
Description=BluezALSA proxy
Requires=bluetooth.service
After=bluetooth.service

[Service]
Type=simple
User=root
ExecStart=/usr/bin/bluealsa --device=hci0
```

### Checking your bluetooth hardware
Check if your adapter is connected and is up and working:  

```
hciconfig list
hciconfig hci0 -a
sudo hciconfig hci0 up
```

### Connecting speaker and testing it:
You would need to use `bluetoothctl` utility in order for all bluetooth-pairing stuff.

```
list # lists your BT devices
select <mac> # select your BT device (adapter)
power on
agent on

scan on <scan>
# find your device mac in list
scan off

pair <mac>
trust <mac>
connect <mac>
exit
```

Check if everything is ok:

```
aplay -D bluealsa:HCI=hci<index like 0>,DEV=<bt mac>,PROFILE=a2dp /usr/share/sounds/alsa/Front_Center.wav
```
If you can hear sound continue. 


Now let's save this speaker for permanent use inside `/etc/asound.conf` so you would not need to specify it each time you play music:

```
pcm.!default {
    type asym
    playback.pcm "btspeaker"
}


pcm.btspeaker {
        type plug
        slave.pcm {
                type bluealsa
                device "00:11:22:33:44:55"
                profile "a2dp"
        }
        hint {
                show on
                description "My Bluetooth Speaker"
        }
}
```

if everything goes fine you can run script and hear music:
```bash
aplay -D bluealsa:DEV=<device>,PROFILE=a2dp /usr/share/sounds/alsa/Rear_Left.wav
```

# Troubleshooting

Check logs before doing anything - it would give you hints on what's wrong:
```console
journalctl -u bluetooth -b
journalctl -u bluealsa -b
journalctl -u mopidy -b
dmesg -w
```

#### a2dp-sink profile connect failed for <adapter_mac>: Protocol not available

__Reason__: bluealsa not started properly, or is misconfigured

If you have more than one bluetooth adapter (or even if you have one, just to be sure) put `device` parameter into `bluealsa.service`. See `installing bluealsa` section for example.

To find out which adapter id to use - list them using
```
hciconfig list command
```

#### /usr/bin/bluealsa: E: Couldn't release transport: GDBus.Error:org.freedesktop.DBus.Error.UnknownObject: Method "Release" with signature "" on interface "org.bluez.MediaTransport1" doesn't exist

I just restart bluealsa here - usually it helps.


#### "Operation not possible due to RF-kill (132)" or something is fishy with adapter
1) I would check if it's not blocked with rfkill application. Unblock it if it was blocked:

```
rfkill list all
rfkill unblock <index of adapter>
```

restart your bluealsa and bluetooth services.


#### Bluetooth device is disconnected after some timeout if no music is playing
I ended up using this script to re-connect (thankfully bluetoothctl can be ran as bash script):

```console
#!/usr/bin/env bash

sudo bluetoothctl disconnect
sudo bluetoothctl agent off
sudo bluetoothctl power off

sleep 3

sudo bluetoothctl power on
sudo bluetoothctl agent on
sudo bluetoothctl connect 00:11:22:33:44:55
```

#### New tracks added to mopidy local folder cannot be played
Run local scan and restart mopidy (without restart it would not see those tracks):

```
sudo mopidyctl local scan
systemctl restart mopidy
```

also ensure that your media files belong to `mopidy:audio` user and group.

# Integrating into Home Assistant
First - you need to configure Media player (mopidy in our case) - this would allow us to control speaker:

```yaml
media_player:
  - platform: mpd
    name: mopidy
    host: 127.0.0.1
    port: 6600
```

If you want to play local tracks (for white noise for example) - copy them to `/var/lib/mopidy/media/white_noise`.

Add to config file (for example track that is located in folder /var/lib/mopidy/media/white_noise/cat.m4a):
```yaml
  mopidy_white_noise_cat:
   sequence:
    - service: media_player.play_media
      data:
        entity_id: media_player.mopidy
        media_content_type: music
        media_content_id: local:track:white_noise/cat.m4a
```        

If you want to listen to radio stations - you can also configure like this:
```yaml
  mopidy_stream_rock:
   sequence:  
    - service: media_player.play_media
      data:
        entity_id: media_player.mopidy
        media_content_type: audio/mpeg
        media_content_id: http://live.radioec.com.ua:8000/rock.m3u
```

Also remember the script from troulbeshooting part? I've also added it as a button:
```yaml
shell_command:
  restart_white_noise: /opt/white_noise/restart_speaker.sh
```


[complete-flow]: https://www.sigmdel.ca/michel/ha/rpi/bluetooth_02_en.html#bluez