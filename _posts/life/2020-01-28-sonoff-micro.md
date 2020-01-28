---
layout: post
title:  "Sonoff Micro Dissasembly and Flashing (kind of)"
tags: ["sonoff", "micro", "tasmota"]
categories: life
comments_id: 3

---

![dissasembly](/assets/2020-01-28//dissasembly.png)


### Dissasembly
In order to dissasemble it I had to scratch case all over.
It seems everything is much simpler - you need really thin screwdriver to be inserted exactly where red marks are. Than it will un-snap and you can use another scredriwer to un-snap other sides.

![bottom](/assets/2020-01-28/bottom.png)

![top](/assets/2020-01-28/top.png)


### SPI connection
Board contains `V`, `G`, `R`, `T` Pin group on one side

and `LOG`, `R`, `T`, `RST` and button on the other.

I've connected my programmer to the device (3.3V), but default way of copying firmware does not work here - not an ESP-compatible.

```
@esp_tool -pCOM12 -b115200 -a0x0000 -s0x100000 -or esp82XX.bin
```

### Consumption
Unit consumes around 0.06A according to my usb-doctor.

### Usage
I've noticed that there is no click sound when it turns on/off (compared to the `big` modules with relays like sonoff basic or pow). 

Button location is not perfect when you are connecting it to a USB hub (like orico), but it does not interfere with the other ports.

### Other usefull links:

[Hackaday comments on a chip](https://hackaday.com/2019/12/26/new-part-day-sonoff-usb-smart-adaptor-taps-a-new-wifi-chip/)

[FCC documentation](https://fccid.io/2APN5MICRO)
