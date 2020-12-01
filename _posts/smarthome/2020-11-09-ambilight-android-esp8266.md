---
layout: post
title:  "Ambient backlight on Android + Hyperion + ESP8266 + WS2812"
tags: ['smart home', 'ambilight', 'hyperion-ng', 'esp8266', 'ws2812']
categories: smarthome
---

Boy oh boy how many attempts at this I've done.

Most of manuals either require you to use PC or HDMI splitter. 
The ones that use external microcontroller for LED's connection are using Arduino (mostly nano)
That was not what I was looking

## My requests and configuraton 

* Android Box as a player / host.
* ESP8266 as LED microcontroller. (Probably would work with ESP32 as well).
* WS2812 as a LED output.
* 88 LED's and 5V power supply. (5 Amps. I would calculate something like 20mA * LED + 100mA for MC)
* Orange PI PC with Hyperion as processing device. Any RPI clone would work.

### WLED Configuration 💡
Clone repository `https://github.com/Aircoookie/WLED` & make next adjustments to code:

Hard way: 

* Set LED pin - `NpbWrapper.h` - LEDPIN
* Set Wifi Host - `wled.h` - CLIENT_SSID and CLIENT_PASS
* Set MQTT details - `wled.h` (MQTT section)
* Disable unused components - `wled.h` start of file
* also you can select IR port as well.

> use Easy way - use manual from their Wiki on flashing firmware. [Configuration URL][wled-url]


Upload firmware to your WLED device and connect to assigned IP. (Check in platformio console or your router connected devices)



## Hyperion installation & configuration

Get [installer][hy-inst] (.deb) or docker file and deploy it on your linux machine.

Personally I had to do manual intallaton of 2 packages `` and ``, because hyperion service would fail to start otherwise.

Start `hyperion` service and connect to `host:8080`.




### Android TV Configuration 📺
Downlaoad and install [Hyperion Grabber][hy-grab] app.



Set Host, and do not use - send colors instead of picture!

### Hyperion Configuration 🧮
Most importantly - to select correct source on the page with `remote control`.



Pros:
* Backlight for YouTube / VLC
* Awesome IDLE animations - for example `candle lights`

Cons:
* Netflix (and probably any protected content would not work)
* Frequent crashes


[wled-url]: https://github.com/Aircoookie/WLED/wiki/Install-WLED-binary#what-binary-should-i-use
[hy-grab]: https://play.google.com/store/apps/details?id=com.abrenoch.hyperiongrabber&hl=en_US&gl=US
[hy-inst]: https://github.com/hyperion-project/hyperion.ng/releases