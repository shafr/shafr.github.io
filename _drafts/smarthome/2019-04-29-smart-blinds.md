---
layout: post
title:  "Smart Blinds for Smart home"
tags: [L293D, 28BYJ-48, ESP8266, ESPHOMEYAML]
categories: smarthome
---

I've been looking for this project since i've bought my own flat and saw Home-assistant power. 

The idea that your blinds would close with the sun down and then would open in the morning seemed to me like some futuristic thing.

One of the thing that stopped me from implementation was price and size of the block.


Price for components:

| Count | Component              | Price $ | Link                                             |     
| ----- | ---------------------- | ------- | ------------------------------------------------ |
| 1     | ESP8266                | 1.39    | https://www.aliexpress.com/item/32633529267.html |     
| 1     | 28byj-48 motor         | 1.50    | https://www.aliexpress.com/item/32896006818.html | 
| 100   | 1K 0603 resistors      | 0.75    | https://www.aliexpress.com/item/32847135098.html |     
| 50    | ceramic capactior      | 2.20    | https://www.aliexpress.com/item/32943454441.html |     
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
|       | Total for 10 devices   | 42.15   |                                                  |     

Calc: 0.75+2.20+1.23+0.59+1.01+1.42+1.50+1.09+1.09+2.37+(1.50+1.39)*1

* note that power supply is not here in the list since i have not decided how to use it


|                 |                   Top                       |                    Bottom                        |
| --------------- | ----------------------------------------    | ----------------------------------------         |
| PCB View        | ![](/assets/smarthome/2019-04-29/toppcb.png) | ![](/assets/smarthome/2019-04-29/bottompcb.png) |

Here is a code that made it possible:
```yaml
mqtt:
  broker: 192.168.1.1
  username: user
  password: password
  client_id: user
  discovery: false

  on_message:
    - topic: motor/left
      then:
        - stepper.set_target:
            id: my_stepper
            target: 1000
    - topic: motor/right
      then:
        - stepper.set_target:
            id: my_stepper
            target: -1000
stepper:
  - platform: uln2003
    id: my_stepper
    pin_a: GPIO16
    pin_b: GPIO12
    pin_c: GPIO15
    pin_d: GPIO01
    max_speed: 1000 steps/s

    # Optional:
    acceleration: inf
    deceleration: inf
    step_mode: "HALF_STEP"
```

[similar-issue]: https://github.com/esphome/feature-requests/issues/48
[belgianlink]: http://www.jangeox.be/2013/10/change-unipolar-28byj-48-to-bipolar.html