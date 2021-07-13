---
layout: post
title:  "ESP debug goodies"
tags: [esp8266, esp32, debugging]
categories: life
---

Not all hope is lost, I was able to pinpoint issue with `esp-canary`, created an issue and esp8266 guys were able to help.

Here's few things that might help with debugging apps & save time if you have troubles with your app:

## Debug mode in platformio + output
platformio has this great feature of decoding crashdump `on the fly` directly in the console. 
That is great feature - the only thing you'll need is someone who can explain what's going on there. 

```
[platformio]
build_type = debug
monitor_filters = esp8266_exception_decoder
```

Don't forget to compile & upload project before trying to troubleshoot. (apparently it uses generated .elf file for matching, so just plugging faulty device & decoding would not work)

See [Monitor Options] for more details.


## EspStackTraceDecoder
That's cli command that would allow to decode. It requires manual copy-paste from console and running external tool to decode.

You'll need:
* java + [jar from github repo][ESP Decoder]
* platformio compiled elf file  (located in .pio/build/<board>/firmware.elf)
* toolchain-xtensa app          (in ~/.platformio/packages/toolchain-xtensa/bin/)
* stacktrace saved to file

```
    java -jar EspStackTraceDecoder.jar \
    toolchain-xtensa/bin/xtensa-lx106-elf-addr2line \
    firmware.elf \
    stacktrace.txt
```

## Compiler output
That's really hardcore stuff for desperate times. (or handy tool for people who knows where to look for)

[Here's example][C++ compiler output]


[C++ compiler output]: https://godbolt.org/z/KrK4E9665
[Debugging page]: https://docs.platformio.org/en/latest/plus/debugging.html
[Monitor options]: https://docs.platformio.org/en/latest/core/userguide/device/cmd_monitor.html#filters
[ESP Decoder]: https://github.com/littleyoda/EspStackTraceDecoder