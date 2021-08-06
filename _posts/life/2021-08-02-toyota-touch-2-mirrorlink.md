---
layout: post
title:  "Toyota touch 2 & MirrorLink 1.0 research"
tags: [toyota auris, mirrorlink 1.0]
categories: life
---

So after I've bought my car I found out that it is missing GPS module ($900 USD) + maps subscription (around $100 early). 
I started going though the forums to see what else can be done. 

Boy all this reading it took me back to Luxoft / Harman times - with Head Units, MIB, MMI stuff and mainly diagnostic tools - ODIS, `<add>`

## Android boxes

Some guys have figured out that it is possible to put specially crafted car-android-box behind Screen on place where GPS should be and launch it using GPS button. There's plenty of benefits except old android & price.

## Mirror Link intro
So it is possible to connect your Android phone to HU using cable using MirrorLink. That's like VNC that transfers screen data to device. Here phone acts as server & HU acts as client.

So first I went through my phones collection and found out that I have __Samsung Galaxy A3__ - I had to downgrade it to lowest possible original firmware and there I found MirrorLink menu inside `NFC and sharing`:

![Mirror Link menu](/assets/2021-08-02/ml_menu.png)
![Mirror Link apps](/assets/2021-08-02/ml_apps.png)


And some apps that are supported.

But connecting to car would not give any result - no menu appear, etc. 

I was starting questioning if that capability should be enabled in some diagnostic menu or if it is built-in external GPS module.

## Mirror Link 1.0 
So apparently there were few revisions of MirrorLink - 1.0 till 1.3. If phone & HU has different version of MirrorLink - they would not pair and desirable menu would not appear.

There was 1.3 version total before it was replaced by android auto and other apps

According to forums & official user manual - `Toyota Touch 2` (that's what my car is using) has MirrorLink 1.0 support only. That means that exactly 2.5 devices are supported. 
![User manual p1](/assets/2021-08-02/mk_um_1.png)
![User manual p2](/assets/2021-08-02/mk_um_2.png)

So here's what models should work:
* Samsung S3
* Nokia 701, N8, N9 for god sake
* also guys from [4pda][4pda-model] had found out other models that are supported are `Sony Xperia`

So MirrorLink 1.0 was only installed on devices with android < 4.3. 
First I tried downloading & searching apk files inside firmware from Samsung S3, but I was not able to find anything resembling __DriveLink__ __MirrorLink__ , etc. I went through few firmwares without any result. 

## Samsung S3

That's when I had to buy Samsung S3 to figure it out. After buying one & installing Samsung Store from .apk - (since old one had expired certificates & phone refused to open any aps pages) - I've installed `Drive Link` application.

After that installation 2 applications had appear:
* __TMServerApp.apk__ inside /sys/app
* __app.scm.apk__ inside app

Now I've installed every possible application from [4pda][4pda-apps]. After connecting usb cable to phone it starts launching drive application where you can go to navigation, choose music, etc. For some reason only Waze & Google Maps was working there.

Finally I connected phone to car and DriveLink menu had appeared! I was able to launch `Google Maps` and phone screen was mirrored on display. However when going to desktop or choosing any other application, it woulds stop working.

There was plenty of talks about it on 4pda and workarounds with floating windows, etc.


```
Firmware: Android_Revolution_HD-SGS3_53.0
Kernel: i9300_LiteGX-KERNEL_v5.1.0_CWM.zip
```

[samsung-s3-mention]: https://forum.xda-developers.com/t/mod-drivelink-mirrorlink-full-mirroring.1951960/post-72440448
[4pda-model]: https://4pda.to/forum/index.php?act=findpost&pid=16142738&anchor=Spoil-16142738-2
[4pda-apps]: apps