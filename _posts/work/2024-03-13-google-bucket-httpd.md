---
layout: post
title:  "HTTPD with google cloud bucket"
tags: ['httpd', 'gcloud']
categories: work
---

So there's nothing too complicated here, just a few things to note:
1) As in normal regex - you'll match query strings with round brackets and the result with dollar signs () -> $1
2) There can be multiple occasions of those.
3) You can use | to match multiple words with OR command.

```bash
ProxyPassMatch ^/(one/|two/|three/four.js$)(.*) https://storage.googleapis.com/bucketId/$1$2
ProxyPassMatch ^/(\d\.[0-9prc]+|resources)(/|$)(.*) https://storage.googleapis.com/bucketId/$1$2$3
```