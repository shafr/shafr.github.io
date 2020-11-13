---
layout: post
title:  "ANET A8 + MKS GEN L 1.0 + TMC2208 + MARLIN"
tags: ["mks gen L 1.0", "TMC2208", "MARLIN"]
categories: life
---

Looks like I'm not the only person having problems with TMC2208 drivers.
After seeing this article [article] I've decided that now it's time to move on and updated my printer from `1.1.8` to `1.1.9` hoping that finally I can use UART mode of my TMC2208. (I had a few extra lying around with re-soldered pins and cables)


There were compilation issues which I was not able to resolve. So I decided, that it's time to move to `bugfix-2.0.0`.

Merge was sucesfull, there were not as much changes in configuration files as I expected and compliation was OK! Iv'e printed test cube with TMC2208 in __dumb__ mode and it looked exactly like my cube from 1.1.8 so no regression.

So then I spend 6 hours figuring out why:
* Software Serial is not working
* Some drivers are moving axis only in one direction

According to Atmel Mega board - there are 4 hardware serial port pairs which we can use - i've mapped them in the image below:
* AUX-1: (__Serial0__): seems like this guy is also used by USB serial connection, so it's not likely can be used with our drivers.
* Z-Z+ Endstop (__Serial1__): Also endstops for Z axis. I left them sitting there, but I gess if anyone need extra HW serial - he can use servos pins with cable rewiring for Endstops
* EXP-2: (__Serial2__): place where normal people have 2-ribbon-cable display. Not my case - since i'm using AUX2 for my ANET A8 display.
* Y-Y+ Endstop (__Serial3__): where endstops reside. Not a problem, since they are re-programmable and used only during homing - I just re-mapped them in `pins_RAMPS.h`, so my Y endstop is now X+ endstop.

So in order to use this pins you should set `X_HARWARE_SERIAL` as corresponding serial.

![Serial Mapping](/assets/2018-12-29/RX_TX_MKS_GEN_L.jpg)

[article]: https://www.instructables.com/id/UART-This-Serial-Control-of-Stepper-Motors-With-th/

| TFT Pin | Pin Name        | Node MCU (Wemos) Pin | Tasmota Config |
| ------- | --------------- | -------------------- | -------------- |
| RST     | Reset           | RST                  | ----           |
| CE      | chip select     | D8 (GPIO 15)         | SPI CS (66)    |
| DC      | Data/Command    | D0 (GPIO 16)         | SPI DC (67)    |
| Din     | Serial Data In  | D7 (GPIO 13)         | ----           |
| Clk     | Serial Clock    | D5 (GPIO 14)         | ----           |
| Vcc     | 3.3 voltage     | 3.3V                 | ----           |
| BL      | Backlight, 3.3V | D2 (GPIO 04)         | Backlight (68) |
| GND     | Ground          | Ground               | ----           |



# Current motor configuration
| Axis | Driver  | Mode | Vref Value | Steps |
| ---- | ------- | ---- | ---------- | ----- |
| X    | DRV8825 | 1/16 | 0.5        | 100   |
| Y    | TMC2208 | 1/16 |            | 100   |
| E1   | TMC2130 | 1/16 |            | 100   |
| Z1Z2 | TMC2208 | 1/16 |            | 100   |



| Count | Component              | Price $ | Link                                             |     |
| ----- | ---------------------- | ------- | ------------------------------------------------ | --- |
| 1     | ESP8266                | 1.39    | https://www.aliexpress.com/item/32633529267.html |     |
| 100   | 1K 0603 resistors      | 0.75    | https://www.aliexpress.com/item/32847135098.html |     |
| 50    | ceramic capactior      | 2.20    | https://www.aliexpress.com/item/32943454441.html |     |
| 10    | esp12f adapter board   | 1.23    | https://www.aliexpress.com/item/32721385289.html |     |
| 10    | 9v connector           | 0.59    | https://www.aliexpress.com/item/32876984714.html |     |
| 50    | 3.3v voltage regulator | 1.01    | https://www.aliexpress.com/item/32910803907.html |     |
| 50    | 5v voltage regulator   | 1.42    | https://www.aliexpress.com/item/32821350559.html |     |
| 10    | motor connector        | 1.50    | https://www.aliexpress.com/item/32911598577.html |     |
| 1     | 28byj-48 motors        | 1.50    | https://www.aliexpress.com/item/32896006818.html |     |
