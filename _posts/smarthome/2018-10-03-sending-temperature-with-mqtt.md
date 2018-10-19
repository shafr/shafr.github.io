---
layout: post
title:  "Sending Temperature from RPI or OrangePI with MQTT and Mosquitto"
tags: [mqtt, smart home, mosquitto]
categories: life
---

So say you want to have temperature from your RPI devices shown on your MQTT dashboard. 

Below are the steps to do it:

### Install Mosquitto client
```bash
sudo apt-get install mosquitto-clients
```
### Create bash script to calculate and send temperature 
Google or just list folder thermal (see below) to find what temp sensors you have on the machine.

```bash
#!/usr/bin/env bash

TEMPERATURE_BIG=$(cat /sys/class/thermal/thermal_zone1/temp)
TEMPERATURE=$(expr $TEMPERATURE_BIG / 1000)

mosquitto_pub -d -h mosquitto_host -u user_name -P password -t topic/topic -m ${TEMPERATURE} >&2
```

Now is a good time to test if scripts works and check MQTT queue for messages.


### Create service inside /etc/systemd/system/publish_temp.service

```
[Unit]
Description=Publish temperature to MQ service

[Service]
Type=simple
User=pi
WorkingDirectory=/opt
ExecStart=/opt/publish_temp.sh
```

### Create timer inside /etc/systemd/system/publish_temp.timer
```
[Unit]
Description=Execute task every minute

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min 

[Install]
WantedBy=multi-user.target
```
This script will send a message every minute within one minute of boot.

#### Validate that your messages are being delivered 
Use any client (I use mqtt-spy) to connect to Mosquitto server and listen to this topic. 

Profit!