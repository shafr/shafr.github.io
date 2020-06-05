---
layout: default
title: Witty Cloud Spider
version: 3.3
release_date: 13.05.2020

components: [esp8266, ams1117-3.3v]
---

I was looking a way how to integrate ESP12-E/ESP-12F with my smart home thigies. 
One of the first devices I've bought was Witty cloud - It's a great form factor and concept, so I was trying to make my own pluggable device like that.

The idea here was to use `AMS1117-3.3V` linear voltage converter to drop down voltage from 5v to 3.3v.

Changes in 3.3:
* Added ADC solder pad and resistors + capacitor for measuring input voltage.
* Some reordering of components to fit everything better

Changes in 3.2:
* Added microusb (2-pin, power only)
* Removed Flash pin - replaced with solder pag.
* Added ground plane on top layer
* Added 5V output
* Added through hole under AMS1117 for better heat dissipation
* Added better text 
* Updated pins definition
* Better tracks to some pins

Changes in 2.0:
* Removed Flash Button - replaced it with x2 2.54 pins
* Added separate plane under AMS1117

Changes in 1.0:
* My first revision of the board, failed one. I've messed up mandatory pins and spent a lot of time trying to fix it. See [that](fixing)



[fixing]: https://shafr.github.io/smarthome/2019/10/15/creating-pcb-witty-cloud.html