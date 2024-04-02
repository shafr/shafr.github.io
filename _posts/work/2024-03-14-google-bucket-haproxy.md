---
layout: post
title:  "HaProxy with google cloud bucket"
tags: ['haproxy', 'gcloud']
categories: work
---

```bash
use_backend gcp_bucket_backend if { url_reg ^/link/(one/|two/|three/$) } url

backend gcp_bucket_backend
  option forwardfor
  http-request set-header Host storage.googleapis.com
  http-request replace-path /root(/|$)(.*) /bucket-path/latest/\2
  server my_backend storage.googleapis.com:443 slowstart 1m check check-ssl ssl verify required ca-file /etc/ssl/certs/ca-bundle.crt inter 60s
```