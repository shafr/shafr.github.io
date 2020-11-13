---
layout: post
title:  "Octoprint on OrangePi configuration"
tags: [octoprint]
categories: life
---

# How to finish `octoprint` installation on Orange PI or whatever PI
Follow [this guide][orangepi-octoprint] for details


## Permissions / services configuration
Create 2 files inside `/etc/sudoers.d`, so it would be possible to restart / shutdown as octopi user without root permissions.

* octoprint-restart-service
```bash
octoprint ALL=NOPASSWD: /usr/sbin/service octoprint restart
```

* octoprint-shutdown
```bash
octoprint ALL=NOPASSWD: /sbin/shutdown
```

UI config would look like this:
* Restart OctoPrint -> `sudo /usr/sbin/service octoprint restart`
* Restart system    -> `sudo shutdown -r now`
* Shutdown system   -> `sudo shutdown -h now`

## Camera configuration
* Create 2 scripts - one service, one script
* Update config.yaml - include camera actions:
```bash
system:
  actions:
  - action: streamon
    command: /home/octoprint/scripts/webcam.sh start
    confirm: false
    name: Start video stream
  - action: streamoff
    command: /home/octoprint/scripts/webcam.sh stop
    confirm: false
    name: Stop video stream
```

* Add permissions to view video
```bash
mcedit /etc/group
video:x:44:user1,octoprint
```

* Configure UI
Not here - that you need to put URL's with actual host IP / name, not localhost or 127.0.0.1!

## Dual cameras support
See [this manual][multiple-cameras-support] for details.

List cameras
```bash
ls -l /dev/ | grep video
```


[orangepi-octoprint]: https://www.iot-experiments.com/orange-pi-zero-and-webcam-for-octoprint/
[multiple-cameras-support]: https://printoid.net/2017/04/29/trick-12-support-two-cameras-in-printoid-premium/