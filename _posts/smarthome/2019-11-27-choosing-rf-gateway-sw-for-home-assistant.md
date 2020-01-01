---
layout: post
title:  "Choosing 433MHZ RF gateway software for Home Assistant"
tags: [smart-home, diy, 433mhz]
categories: smarthome
---


## Introduction and configuration:

### [Tasmota][Tasmota]
This is the oldest one and the most feature-complete software. According to documentation from components list, it does support RF receiver:

```
106	RFrecv	RF Receiver (433Mhz module needed; Requires self-compile with RF_SENSOR and USE_RC_SWITCH)
```

All you need to do is update:
* `platformio.ini` - uncomment `tasmota-sensors` variable.
* `my_user_config` - update with your Wifi, Mqtt, and device data and uncomment `USE_RC_SWITCH` and `USE_RF_SENSOR`.

Then after building and flashing firmware and uploading it to device you will see Wifi address in serial console where you can log in and assign corresponding pin to RF receiver.

I also found out that signals from remote are coming in HEX format. To change it you need to either:
* send MQTT command `SetOption28` command value to `1`.
* change `settings.h` - update value of `uint32_t rf_receive_decimal : 1;` 


Benefits of using Tasmota:
* Web-UI for your device where you can check logs, configs or update ping assignment
* MQTT status updates with free mem, uptime, cpu load, etc. It's much easier to track status of device with Tasmota.
* Dozen of supported devices and sensors

### [EspHome][EspHome]
This one does not requires much programming, but you should declare configuration for it to work.

```yaml
esphome:
  name: 433mhreceiver
  platform: esp8266
  board: nodemcuv2

wifi:
  ssid: $ssid
  password: $password
  fast_connect: True

logger:

api:
  reboot_timeout: 0s

ota:

remote_receiver:
  pin: D2
  dump: all
  # Settings to optimize recognition of RF devices
  tolerance: 10%
  filter: 500ms
  idle: 5ms
  buffer_size: 1kb
```

Personally I had issues with lots and lots of parasite signals over here. I was not able to get actual signal from remote from hundreds of signals received.
I've played with tolerance, filter and idle values with no success.

Benefits of using EspHome:
* No C++ code writing / updating, everything is defined in YAML file. Ease of config update and tracking.
* Lots of existing examples
* Support for logging over wifi, OTA.


### [OpenMqttGateway][OpenMqttGateway]
This project main purpose to be RF / and others gateway, so theoretically this is what it should do the best.

Since it supports dozen of different ways to communicate (GSM, IR, RF), you should update configuration file with sensors that you would want to use.

Configuration is done through `User_config.h` file where you define used modules, Wifi, Mqtt configs.
Afterwards if you want to change pin definition you need to update specific `.ino` file.


[Tasmota]: https://github.com/arendst/Tasmota/wiki/Components
[EspHome]: https://esphome.io/components/remote_transmitter.html#remote-setting-up-rf
[OpenMqttGateway]: https://docs.openmqttgateway.com/setitup/rf.html#compatible-parts


