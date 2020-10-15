---
layout: post
title:  "DIY Smart Blinds for Smart home"
tags: [L293D, 28BYJ-48, ESP8266, EspHomeYaml]
categories: smarthome
---

I've been looking for this project since i've bought my own flat and saw Home-assistant power. 

The idea that your blinds would close with the sun down and then would open in the morning seemed to me like some futuristic thing.

One of the thing that stopped me from implementation was price and size of the block.

What got me started was this article about [28BYJ-48][belgianlink] turbocharging. 
I got all excited (since I have some of that around) and the breadboard prototype was working*. 
(Only if motors received voltage from 9 volts, ideally 12v)

Also check out the [explanation][explanation] about driver, motor.

`Update from 2020`: Finally I made it work ! See updated code and 3d models section.

# Price for components:

| Count | Component              | Price $ | Link                                             |     
| ----- | ---------------------- | ------- | ------------------------------------------------ |
| 1     | ESP8266                | 1.39    | https://www.aliexpress.com/item/32633529267.html |     
| 1     | 28byj-48 motor         | 1.50    | https://www.aliexpress.com/item/32896006818.html | 
| 100   | 1K 0603 resistors      | 0.75    | https://www.aliexpress.com/item/32847135098.html |     
| 50    | ceramic capacitor      | 2.20    | https://www.aliexpress.com/item/32943454441.html |     
| 10    | esp12f adapter board   | 1.23    | https://www.aliexpress.com/item/32721385289.html |     
| 10    | 9v connector           | 0.59    | https://www.aliexpress.com/item/32876984714.html |     
| 50    | 3.3v voltage regulator | 1.01    | https://www.aliexpress.com/item/32910803907.html |     
| 50    | 5v voltage regulator   | 1.42    | https://www.aliexpress.com/item/32821350559.html |     
| 10    | motor connector        | 1.50    | https://www.aliexpress.com/item/32911598577.html | 
| 1     | witty cloud            | 2.37    | https://www.aliexpress.com/item/32849208288.html | 
| 20    | 16 pin sockets         | 1.09    | https://www.aliexpress.com/item/32799785542.html | 
| 10    | 40 pin female header   | 1.09    | https://www.aliexpress.com/item/32867179300.html |
|       |                        |         |                                                  |
|       | Total for 1 device     | 16.14   | and lots of parts left ...                       |     
|       | Total for 10 devices   | 42.15   | that's $4 per one!                               |     

* Note that power supply is not here in the list since i have not decided how to use it.
Also note that a lot of components are left after any assembly.


|                 |                   Top                       |                    Bottom                        |
| --------------- | ----------------------------------------    | ----------------------------------------         |
| PCB View        | ![](/assets/smarthome/2019-04-29/toppcb.png) | ![](/assets/smarthome/2019-04-29/bottompcb.png) |

# Software part
From the very start I decided that writing own code in this case is a bad idea. 

OTA, MQTT, sleep, wifi serial logging, and other things would take plenty time to implemnet and I have already seen Tasmota and EspHomeYaml projects.

My precise combination was not available - with L293D driver and 28BYJ-48 motor, the closest I've found was uln2003 stepper. 
It does show good torque.

Here is a code that made it possible:
```yaml
# IN1 = 16
# IN2 = 12
# IN3 = 15
# IN4 = 01


stepper:
  - platform: uln2003
    id: my_stepper
    pin_a: 12
    pin_b: 16
    pin_c: 01
    pin_d: 15
    max_speed: 250 steps/s

    # Optional:
    acceleration: inf
    deceleration: inf
    sleep_when_done: true
    step_mode: WAVE_DRIVE

switch:
  - platform: gpio
    pin: 02
    id: red_pin

  - platform: template
    name: "Toggle_Position_Up"
    turn_on_action:
      - stepper.report_position:
          id: my_stepper
          position: 0
      - stepper.set_target:
          id: my_stepper
          target: -200

  - platform: template
    name: "Toggle_Position_Down"
    turn_on_action:
      - stepper.report_position:
          id: my_stepper
          position: 0
      - stepper.set_target:
          id: my_stepper
          target: 200    
```

# Issues / Warnings
* I've seen some corrupted / fake L293D drivers. Symphtoms - when toggling positions up or down - it always goes in one direction and has no torque at all.
* Bad motors - same as previous, but direction remains same all the time.

# 3D Printed models
* Housing: https://www.thingiverse.com/thing:1371349
* Husing 90": https://www.thingiverse.com/thing:3593641
* Even better housing: https://www.thingiverse.com/thing:3923529
* Chain connector: https://www.thingiverse.com/thing:1174117
* Cog (gear): https://www.thingiverse.com/thing:3586583


[similar-issue]: https://github.com/esphome/feature-requests/issues/48
[belgianlink]: http://www.jangeox.be/2013/10/change-unipolar-28byj-48-to-bipolar.html
[explanation]: https://www.engineersgarage.com/esp8266/nodemcu-and-l293d-motor-driver-controlling-dc-motor/