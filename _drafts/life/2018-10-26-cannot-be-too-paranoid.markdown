---
layout: post
title:  "Cannot be too paranoid"
tags: [bash, linux, security]
categories: work
---

1) Create new user with bash pointing somewhere
```bash

```

2) Check that only correct users can connect via ssh
/etc/ssh/sshd_config
```bash
AllowUsers <users>
```

3) Change ownership to this user for mounts


add group?
```bash
www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/docker inspect *
```


Move home to config folder:
usermod -m -d /newhome/username username


