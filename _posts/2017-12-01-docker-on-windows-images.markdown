---
layout: post
title:  "Few words about Windows Docker images creation process"
tags: [windows, docker]
categories: docker
---

I had a 'luck' of working with Windows Containers aka native Docker for Windows. 

### Images
`Alpine-ish` image for windows is called `microsoft/nanoserver` and weights around `918 MB`. But it only runs x64 executables, so if you want to virtualize any application server - you need to make sure that all of the components during install process are x64 bit and support quiet or console installation. 

(So it you are trying to install Websphere application and it uses eclipse-like bundler you are out of luck)

The default `base image` that everyone is using is called `microsoft/windowsservercore` and weights `9.56 GB`.

Your artifactory or other image repository should be updated to support Windows images (our did not at the time).

### Process
The process of image building is same as for Linux, instead of using `bash` files `powershell` scripts are used.

### Monitoring
Awesome feature that I found out later is the way that containers are implemented on Windows (& Linux). It is possible run any of `Sysinternal` tools & monitor what's going on inside container from host machine.

So you can run ProcessMonitor, target/filter it to monitor specific process to find out whatever - which files are not being used, which registry branches are being read/write, why app performs so bad, etc...

### P.S.
Back in a day when Windows XP was around there was a group of people in Russian crackers/hackers community that were creaing ligthweight versions of windows - for old PC's, for gaming on PDA's or whatever. I have almost no services (that normal person needs), one language (obviously russian), most of unused drivers are removed. Barebones windows. Microsoft should hire one of those guys for core image creation.