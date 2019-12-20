---
layout: post
title:  "Docker + Fail2ban + Simple Mail Forwarder - you never know what to expect"
tags: ["docker", "fail2ban", "simple mail forwarder"]
categories: life
---

So I found this awesome project [Mail Forwarder][docker_mail_forward]

What it does - is forwards e-mails from any mask to a pre-defined e-mail of your choice.

So it's easy to give your e-mail to someone else and everyone have a unique one.

Hashtag Things could be much easier - there were hints that I did not put attention at the moment:

* Docker logs are stored to a special folder `/var/lib/docker/containers/<container name>/<container name>.json` file. (or syslog). They start from `{"log":"`.  Regex patterns should be updated.
* Docker container timezone and time does not correspond to a system timezone. It can have UTC timezone and host machine can have anything else.
* Docker uses it's own IPTABLE rules. So fail2ban IPTABLE rules does not apply easily with docker. [fail2ban solution][lazydev]
* Sendmail is required by default and banaction would fail if sendmail is not present or is not started, etc. -> Had to remap port for docker application.
* Docker requests are coming from ip `172.17.0.1` - which is not internet IP but rather Docker Gateway. (Which is caused by [IP masquerading][masquerade]) 


[docker_mail_forward]: https://github.com/zixia/docker-simple-mail-forwarder

[masquerade]: https://stackoverflow.com/questions/47537954/how-to-make-docker-container-see-real-user-ip

[lazydev]: https://www.the-lazy-dev.com/en/install-fail2ban-with-docker/

[mail-forwarder]: https://github.com/zixia/docker-simple-mail-forwarder