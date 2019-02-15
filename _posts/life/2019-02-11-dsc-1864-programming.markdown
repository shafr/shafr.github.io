---
layout: post
title:  "DSC alarm with dscKeybus programming guide"
tags: [alarm, smart-home]
categories: life
---

I am person who is (was) very far from home-alarms and industrial hardware. 
But I spend quite some time with `Smart Home`, so apparently I was looking in the direction of Smart-homing alarm as well. I found [DSC Keybus][dscKeyBus] project on github and tried to put it together for my old PC 2585 alarm with no result.

After about 5 iterations trying to implement the hardware (mostly using opto-couplers to be on the safe side) I finally made working prototype. (NB: First check that provided prototype is working and then improve from that)

![DSC prototypes front]({{ "assets/2019-02-11/front.png" | absolute_url}})
![DSC prototypes back] ({{ "assets/2018-02-11/back.png" | absolute_url}})


# Programming steps
Some hints for people who have 0 knowledge about security but want to do it themselves anyway (welcome to the club):

* Change Language          hold <> togather for 3 seconds 
* set time                 *6 <access> sroll right to time
* set zone types           *8 <master> 001 (select definition of zones sequentially for zone 1-16 here)
* select active partitions *8 <master> 201 (select unused zones)
* select active zones      *8 <master> 202 (select unused zones)
* change delay times       *8 <master> 005 (set entry time 030) - (exit delay 060)

* disable telephone
* change master code 


# Other great commands:
* `Enter download mode`    *8 - code - 499 - code 4999
* `Get Access code`        *8 - code - 403
* `Get panel ID`           *8 - code - 404
* `exit delay termination` *8 <mater> 014 (check 7)
* `quick exit feature`     *8 <master> 015 (check 3)

# PC Connection
It should be possible to connect DSC PC 1816/1832/1864 alarm to PC using usb-to-serial adapter. 
Unless you have lots of zones and partitions or you don't have keyboard - would not need it.

Here is a pinout instruction on that: [pinout link][pinout]. 

I had 4 different usb-to-serial adapters - none of which worked for me. 
* Prolific usb-to-com, 
* Prolific usb-to-serial,
* Zigbee (I always use it for tasmota programming, since it supports both 3.3v and 5v levels)
* TI usb-to-serial

I was only able to connect using my PC motherboard COM1 port. I had to dissasemble side panel, and use 4 wires directly from motherboard. 

According to some forums, DSC official USB-to-Serial adapter is: `Keyspan USA19-HS`

After that I've ran  [software][software], using admin/1234. Created profile with my alarm, and initiated `Upload all`. Then `Enter Download Mode` on keypad. After few seconds - download had started.

# What are the points that are not covered here:
* Remember - DSC box is shielded from interference! So you cannot put your Dsc-ESP8266 device inisde - wifi will dissapear after you will close lid.
* Wifi-jamming - how to prevent from jamming wi-fi (use ethernet + arduino ?). Do some keep-alive on mqtt query?
* Power - now you need to be sure that your RPI + router are connected to some kind of UPC. 
* Emergency notifications - use home-assistant with Usb-modem to send emergency notifications when internet is out.


# Useful links
http://wiki.micasaverde.com/index.php/USBSerial_Supported_Hardware
http://dlshelp.dsc.com/index.php?title=Communications_Troubleshooting

# Some helpfull videos:
https://www.youtube.com/watch?v=gj-KMZzZDhk&list=PL-pinkg3NSQ2yMJR2nBaUERtUi2yD2eOP
https://www.youtube.com/watch?v=Y1s-n1bF5G4&t=73s
https://www.youtube.com/watch?v=pvL0jzeGvwc&t=1382s

# Forum with DSC topics:
https://www.shieldlab.com/forum/index.php/board,3.80.html

[pinout]: http://pinouts.ru/visual/gen/dsc_pclink_conn.jpg
[software]: https://www.kelcom.cz/ke-stazeni/ezs/dls-5/


