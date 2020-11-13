---
layout: post
title:  "Goto Fail - failed attempts at DIY and what i've learned from them"
tags: [smart-home, diy]
categories: smarthome
---

Following goto-fail articale and my recent airsoft-flash-pcb's took me few days / weeks trying to find root cause and make it work. I wanted to sum up lessons that I've learned:

##  Narrow down the orgigin of issue - eliminate ESP from the forumla: Upload blink sketch using testing-board before soldering it to PCB. This would allow you to eliminate issues with faulty ESP's.

I've made one from Witty-cloud type PCB, on which I stick my ESP's:
![Commercial Tester]({{ "assets/2020-07-23/commercial_tester.jpg" | absolute_url}})

There are also commercial one's from aliexpress for 10$:
![DIY Tester]({{ "assets/2020-07-23/diy_tester.jpg" | absolute_url}})

## Always try something new
I found lying around logic analyzer and tried to see if it would help. 
`PulseView` is a great tool that allows you to capture communitcation and decrypt different protocols.
![PCB's]({{ "assets/2020-07-23/pulseview.png" | absolute_url}})

## Reverse-solder components
So I had a short-circuit or over-current when I was connecting Serial programmer to my PCB. 

Since I've ordered by accident 30 PCB's, I felt no regret de-soldering components one-by-one and checking if would fix it. 

And yes - the issue was in incorrect pull-down resistors for ESP and in PNP transistor that was wired incorrectly.

![PCB's]({{ "assets/2020-07-23/pcbs.jpg" | absolute_url}})