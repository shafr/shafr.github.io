---
layout: default
title: airsoft-o-tactical
version: 1.0
release_date: 01.02.2020

components: [esp8266, XB3303A, TLV70033, WS2812B]
---

Although I was working with linear voltage regulators before (using AMS1117) - for USB use, 
I wanted to make another device that would work with 18650 LIPO battery, and would use 3.3V. 
And this device should have as less fragile components as possible.
See [discussion on stackexchange](discussion) on choosing specific chip.

This is also my first experiment device with lipo protection - initially I was using `FS312F-G`, but it requires also external mosfet, has 6 pins and is much easier to mess up. (And also is external device, so costs money to assemble). I was vary happy with `XB3303A` chip that is tiny, has only 3 pins and does not require much external components.

## Wins (what does work):

* ESP-12F works! Blink is ok. 
* Programming through Serial pins.
* 3.3V converter does work, shifting voltage to 3.3V. 
* Lipo Unvervoltage protection also works
* WS2812B socket and LED's control
* Buttons
* ADC
* Flash pad

## Fails

Now to the sad parts:
* I've messed up PullUp/Pulldown for GPIO15 and GPIO00, so device failed to start for me. And I've ordered 30 pcbs to be assembled! So one reistor array should be desoldered and 3 resistors should be added.
* For some reason NPN transistor was placed incorrect - causing short circuit on the board. It took me 6 boards, desoldering components one-by-one to get it wright. So no buzzer this time.
* Flash pad has not the best location - I should point carefully with tweezers for it to work. 
* Buttons are too close to each other. I need some fancy case for them to work.
* LiPo undervoltage protection - not as expected - it kills voltage supply at around 2.5 volts. Hope that it would would not destroy 18650 batteries for me.


[discussion]: https://electronics.stackexchange.com/questions/499135/linear-voltage-regulator-for-lipo-and-3-3v200ma-esp8266-most-juice