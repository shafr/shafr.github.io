---
layout: post
title:  "Few words about Windows Docker images creation process"
tags: [windows, docker]
categories: docker
---

`Alpine-ish` image for windows is called `microsoft/nanoserver` and weights around `918 MB`. But it only runs x64 executables.
The default `base image` that everyone is using is called `microsoft/windowsservercore` and weights `9.56 GB`.

And don't forget that windows multiline commands can be separated by `\` symbol in dockerfile and `^` in powershell/cmd file.

P.S. Back in a day when Windows XP was around there was a group of people in Russian crackers/hackers community that were creaing ligthweight versions of windows - for old PC's, for gaming on PDA's or whatever. I have almost no services (that normal person needs), one language (obviously russian), most of unused drivers are removed. Barebones windows. Microsoft should hire one of those guys for core image creation.