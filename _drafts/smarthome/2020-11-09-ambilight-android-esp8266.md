---
layout: post
title:  "Ambient backlight on Android + Hyperion + ESP8266 + WS2812"
tags: ['smart home', 'ambilight', 'hyperion-ng', 'esp8266', 'ws2812']
categories: smarthome
---

Boy oh boy how many attempts at this I've done.

### Hyperion installation
https://github.com/hyperion-project/hyperion.ng/releases

### WLED Configuration
https://github.com/Aircoookie/WLED

* Set LED pin - `NpbWrapper.h` - LEDPIN
* Set Wifi Host - `wled.h` - CLIENT_SSID and CLIENT_PASS
* Set MQTT details - `wled.h` (MQTT section)
* Disable unused components - `wled.h` start of file

or use Easy way - use manual from their Wiki on flashing firmware.

https://github.com/Aircoookie/WLED/wiki/Install-WLED-binary#what-binary-should-i-use

### Android TV Configuration
https://play.google.com/store/apps/details?id=com.abrenoch.hyperiongrabber&hl=en_US&gl=US

Set Host, and do not use - send colors instead of picture!

### Hyperion Configuration
Most importantly - to select correct source on the page with `remote control`.



Pros:
* Backlight for YouTube / VLC
* Awesome IDLE animations - for example `candle lights`

Cons:
* Netflix (and probably any protected content would not work)
* Frequent crashes