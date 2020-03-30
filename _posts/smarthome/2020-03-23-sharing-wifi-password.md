---
layout: post
title:  "Sharing long wifi password"
tags: [wifi, sharing]
categories: smarthome
---

I have a really long password for wifi. I think it's maximum possible size - something like 64 symbols with all possible variants of characters. 

So it's impossible to type it on any new device - for that i have QR code or microsd card.

But some of devices does not have QR reader (or they are old Ihone 3G) - so here is workaround.

This is what i upload to my ESP8266 device, fire it up and share my new devices:

```
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

const char *ssid = "ESP";
const char *password = "12345678";

ESP8266WebServer server(80);

// Go to http://192.168.4.1 in a web browser connected to this access point to see it.
void handleRoot() {
  server.send(200, "text/html", "<h1>ACTUAL WIFI PASSWORD HERE</h1>");
}

void setup() {
  WiFi.softAP(ssid, password);
  server.on("/", handleRoot);
  server.begin();
}

void loop() {
  server.handleClient();
}
```



[Source][https://github.com/esp8266/Arduino/blob/master/libraries/ESP8266WiFi/examples/WiFiAccessPoint/WiFiAccessPoint.ino]