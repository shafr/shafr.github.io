---
layout: default
title: airsoft-o-tactical
version: 1.2
release_date: 01.09.2020

components: [esp8266, XB3303A, TLV70033, WS2812B, microsd]
---

## Change list:
* Fixed resistors for ESP - now ESP can just be thrown there and would work
* Added MicroUSB for non-mobile applications
* Added reset 1.27x2 pin 
* Replaced programmer pads with 1.27x2 pin on the left side. Works great.
* Added MicroSD slot on the bottom side. 
* Moved power pads on the both sides. Now can use 2.54 90 degree pin.

## What worked (or was tested)
* ADC - battery voltage is reporting correctly. It was hard to mess it up.


## What does not work as expected:

[microsd]: http://