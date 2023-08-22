---
layout: post
title:  "FPV things I should've know about"
tags: ["hobby", "fpv", "drones"]
categories: life

---

Last autumn I was looking for a new hobby to get my mind out of things and I found out about FPV & drones stuff. 

There are a lot of misconceptions that no one tells you about as you enter the hobby. And some other things are pretty much defined.

So defined stuff first:
* There are basically 2 gurus that dedicated their lives to FPV - Oscar Ling (in his blog) & Joshua Bardwell (in Youtube). They cover most of material there.
* ExpressLrs is the protocol to go-to in 2022-2023. Just buy all drones with it or PNP drones & solder in ELRS transmitters. It's cheap - $6-$15 for receiver.
* Reddit have a few channels which have answers for your questions. r/fpv & r/multicopter. ELRS is using discord.

Misconceptions:
* `4-in-1 protocol module` claims that you can connect any device to your remote. None of my 5 different bought-in-store drones were able to connect due to absence of protocol. I've sent 3 of them to developer or protocol and never had heard back. So those `any` means ones from the list that you might not find in a stores. There is no way for regular person to identify protocol without just enumerating & going through all of them.
* `1S` batteries behave a bit different than other `2s-3s-4s` batteries. With default configs they would sag more, and you'll get a lot of warnings on them. They have a slightly lower minimum voltage (like 3.0v)
* Most of the stuff you see in reviews from year ago either costs now 1/3 more or is not available anymore. So if you are looking for a googles - there's no EV200, EV300 in stores, fatsharks, etc. You can always buy top of the line devices like ORQA or DJI.
* ExpressLRS is not backward compatible. You cannot pair v3 controller with v2 drone. If drone have SPI receiver, before Betaflight you were not able to have v3 there.

You have a lot of things to sag in in terms of firmware's: 
* `BlHeli` for Esc firmware
* `Betaflight` for Motherboard 
* `EdgeTx` for Controller, programming inputs, logic switches, outputs, mixers, etc.
* `ExpressLRS` firmware for both transmitter module & receiver module.

Everyone has it's own installer, configurator, etc.