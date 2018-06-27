---
layout: post
title:  "Docker - usefull commands for managing containers"
tags: [docker, bash]
categories: docker
---

### Just a small set of Docker commands that i'm often using for images maintenance:

Override entry point for docker image
```bash
docker run --entrypoint=bash -it <image>
```

Clean unused containers & volumes
```bash
docker container prune --force; docker volume prune --force;
```

Remove All images that does not have tags
```bash
docker rmi $(docker images | grep "^<none>" | awk "{print $3}") -f
```


### Troubleshooting:

* Docker add insecure registry (testing purpose!):

```bash
/usr/lib/systemd/system/docker.service
ExecStart ... --insecure-registry <host>:<port>
sudo systemctl daemon-reload
sudo systemctl restart docker
```

* Docker does not properly run script

```bash
entrypoint.sh: 18: entrypoint.sh: Syntax error: "(" unexpected (expecting "}")
```

Probably, the script was created in windows (in IDEA?) and has newline encoding set as CRLF, which causes linux to go crazy

Change encoding to LF (there is a button on the right bottom size of the page).
