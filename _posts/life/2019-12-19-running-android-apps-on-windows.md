---
layout: post
title:  "Running android Apps on Windows"
tags: ["VirtualBox", "Android"]
categories: life
---

## Problem

I listen to a dozen of audiobooks using my `Smart Audiobook Player` (I'll call it `SAP`).

Some of them contain great quotes, which I like to store, for which I use Bookmark feature ( SAP Which allows to navigate through this bookmarks and stores them in .xml format).

Since my phone has limited space - after listening to audiobook I usually copy this quotes folder to PC to a `Copy bookmarks folder` which I later go through.

However I was not able to find any application on PC that would allow me to open this bookmarks (or any media player that would have bookmariking feature, including VLC, aimp, ...)

So last desperate move was to find a way to run Android apps on Windows. And here it is.

## OS installation

First of all you would need Android X86 ISO. Download it from [Android X86 site][download_url].
Also you would need `VirtualBox`.

Installation instructions are perfectly explained [here][boot_install]

## Normal Boot
Remove ISO from virtual drive.

Select second field (with Debug Mode).

We would need to mount grub as writable and update contents of `menu.lst`:

```
sudo mount -o remount,rw /mnt/grub
vi /mnt/grub/menu.lst
```

add this params to the end of `kernel` line:
```
nomodeset xforcevesa
```

save your editor and restart / or boot into OS.

## Copying files between Host and Guest

* So far I was using dumb way - using HFS tool - where I zip some files on my Host PC and download them through the Android OS

* According to [official documentation][virtualbox_info] - there are better ways. Check them.

Ideally I would like to find a way to mount physical drive as SD card, so I can freely copy files over.

[download_url]: https://www.android-x86.org/download.html
[boot_install]: https://techsviewer.com/install-android-in-virtual-machine-vmware-and-virtualbox/
[virtualbox_info]: https://www.android-x86.org/documentation/virtualbox.html

