---
layout: post
title:  "OrangePi Zero + Octoprint memory issues"
tags: [smart-home, 3d printing, octoprint]
categories: smarthome
---

# Problem
I've been using my `Orange pi Zero 256MB` for octoprint since the very begining. It has 4 cores, that is more then enough to drive Octoprint.

However during re-installation or adding of python packages system goes down with 100% of memory, then swap, then CPU.

I've noticed this behaviour with:
* Pandas (dependency for Bed Visualizer)
* Numpy  (depenency for  Octoprint-Stats)

## Solution
One of the solution is to temporary increase swap size for the installation:

```
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

this would create 1GB temporary swap file that can be used during installation. You can remove it after reboot.

[source-link][swap-solution]



[swap-solution]: https://www.2daygeek.com/add-extend-increase-swap-space-memory-file-partition-linux/