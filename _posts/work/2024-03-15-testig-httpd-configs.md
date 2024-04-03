---
layout: post
title:  "Testing HTTPD configuration"
tags: ['httpd', 'testing']
categories: work
---

I was looking for a way how to test httpd configuration to be 100% sure that our routes are correct. The least painful  way I found was by using docker-compose (together with our containers):

```yaml 
version: '3.9'

services:
  httpd:
    image: httpd:2.4
    ports:
      - "8080:80"
      - "8443:8443"
    networks:
      - alm-local
    volumes:
      - /local/apache2/conf/:/usr/local/apache2/conf/
      - /local/apache2/conf.d/:/usr/local/apache2/conf.d/
      - /local/apache2/testkeys/:/etc/pki/tls/
      - /local/webapp/:/var/www/html/webapp

... other containers
```

This would mount local config files and webapp ( if there are some static files) and would allow you to target localhost:8080 port to test those urls.
