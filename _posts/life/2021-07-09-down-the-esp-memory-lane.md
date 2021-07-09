---
layout: post
title:  "Down the ESP memory lane"
tags: [esp8266, esp32, flash, ram]
categories: life
---


While I've lost any hope of figuring out why my `esp-canary` project is failing I was looking for something else to distract myself.

I've been trying to figure out, maybe I had some issues with allocating memory in my project or using some wrong compile flags, or were using excessive `F()` for strings.

Here's what I had found out:

# TLDR
* ESP8266 max Sketch memory size is 1MB. See [FAQ][FAQ]. 
* If you board has 4MB, space can be used for FS storage. The bigger FS - more time it would take to upload data. See [ESP8266][MEM_ESP8266] [ESP32][MEM_ESP32] layouts
* There are different commands to determine memory usage from platformio: `pio run` & `pio run -t size`
* There's bunch of C++ flags for memory optimization, mostly you'll use platformio `mode=release` though


## TOOLS to help figure out mem usage:

### Platformio

```
~/.platformio/penv/bin/platformio run -t size
   text    data     bss     dec     hex filename
 833484   14084   33264  880832   d70c0 .pio/build/nodemcuv2/firmware.elf
```

### Xtensa elf-size

That usually comes shipped with platformio:

```
xtensa-lx106-elf-size firmware.elf 
   text    data     bss     dec     hex filename
 833484   14084   33264  880832   d70c0 firmware.elf
```


Some cli for memory scan
```
xtensa-lx106-elf-gdb` firmware.elf
```





[MEM_ESP8266]: https://github.com/esp8266/Arduino/tree/master/tools/sdk/ld
[MEM_ESP32]: https://github.com/espressif/arduino-esp32/tree/master/tools/sdk/esp32/ld
[FAQ]: https://arduino-esp8266.readthedocs.io/en/latest/faq/readme.html#in-the-ide-for-esp-12e-that-has-4m-flash-i-can-choose-4m-1m-spiffs-or-4m-3m-spiffs-no-matter-what-i-select-the-ide-tells-me-the-maximum-code-space-is-about-1m-where-does-my-flash-go