---
layout: post
title:  "Mapping Actions to a separate keyboard"
tags: [keyboard, intercept, keybindings, productivity]
categories: hardware
---

## Mapping

So at some point it's impossible to remember all the shortcuts that each IDE or application comes with.

That's when you order NumPad keyboard from China and configure every key to match key combination.

![Example keyboards]({{ "assets/2018-01-25/keyboards.png" | absolute_url}})

## Intercept
Intercept is command line tool that allows you to map buttons on `specific` keyboard to a shortcuts.

## Installation
* You would need to install a special [driver/tool][interception-driver-url] first, and reboot your computer.
* Then download [incept][incept-url], run it, and try to add some mappings. 

The sequence is very simple - you click any button on addtional keyboard and then you map action to that combination and name it.

## See short screencast on CLI - how to display & add commands:
{% asciicast 189379 %}

## Links on some of chinese Numpad keyboards:

[6$ low travel keyboard][low-travel-keyboard]

[8$ classic style numpad keyboard][classic-keyboard]





[classic-keyboard]: https://www.aliexpress.com/item/New-Hot-2-4GHz-Mini-USB-Wireless-Numeric-Keypad-19-Keys-Number-Pad-Numpad-Receiver-For/32839510075.html
[low-travel-keyboard]: https://www.aliexpress.com/item/AVATTO-Small-size-2-4G-Wireless-Numeric-Keypad-Numpad-18-Keys-Digital-Keyboard-for-Accounting/32868175580.html
[interception-driver-url]: https://github.com/oblitum/Interception
[incept-url]: http://octopup.org/img/code/interception/intercept.zip