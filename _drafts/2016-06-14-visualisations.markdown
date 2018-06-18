---
layout: post
title:  "DIY Visualisations with Gnuplot"
tags: [gnuplot, visualisation]
categories: visualisation
---

Way way back when we weren't using APM for performance monitoring, we did not have budget for profilers. (Actually we've bought JProfiler license, but it was able to work only with 1 JVM).

So as everyone else did at the time I wrote my own log collector with JSch & collected all possible logs & started thinking about visualisation.

I was too lazy to learn javascript just for D3 library. I had to do some manager-friendly visualisations.

Not particullary an eyecatcher, but we had what we had.

The goal was to measure the throughput of the system.