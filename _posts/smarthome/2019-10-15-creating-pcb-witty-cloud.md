---
layout: post
title:  "Designing and creatign own PCB (simmilar to Witty Cloud)"
tags: [smart-home, esp-12f, esp8266]
categories: smarthome
---


## History Behind the problem

`ESP12-F` are pretty cheap wifi-mcu's. For around $1.20 you can get device to drive your smart home. 
I've been using white chinese PCB's that had very minimal wiring, no voltage control (actually they it plotted on pcb, but it was inverted), but they worked.

I've designed most of my PCB's around them so at some point I've decided that it's time to encapsulate most of resistors, capacitors, voltage control to this board, so each time I have to design only bare minimum for my feature, and not cary dozen of useless things along. 


I've designed first verison of this board almost year ago. After it had arrived, 
I was not able to make boards work - they were not able to be flashed.

I was thinking that reason was with the `esp-12f` boards that were wrong, so abandoned the effort for some time. 

But surprisingly for me - this esp's worked with chinese white adapters! 

## Lessons learned

### Reading error code to see state of pins

In order for ESP to boot in normal mode or in flash mode - some of the pins on the board should be pulled up or to the ground ( see [Error messages][error-messages] link below for the codes).

It is possible to see `boot status` by connecting with any serial tool (like putty or mobaxterm).


### Reference correct wiring instruction
I was using mostly this link for the reference [Wiki book][original-book] which instructions I either failed to follow correctly or had some issues.

So I finished up soldering reisitors everywhere to resolve this boot issue.

Using [minimal wiring][minimal-wiring] sketch opened my eyes to the problem.

[original-book]: https://tttapa.github.io/ESP8266/Chap02%20-%20Hardware.html
[error-messages]: https://riktronics.wordpress.com/2017/10/02/esp8266-error-messages-and-exceptions-explained/
[minimal-wiring]: https://easyeda.com/gerdmuller.de/ESP8266_12F_Minimal_Wiring-USM4lfxP7