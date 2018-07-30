---
layout: post
title:  "While I was away from Docker"
tags: [docker]
categories: work
---

During last year there were few major features that I've  missed and just found out in a hard way.

Here are some of most useful ones:

* [Multi-stage builds (from verison 17.05)][multi-builds] - Here you are basically doing any mayhem during base image creation and then just copying result contents to final image.
* [Persistent volumes][persistent-volumes] - It's not about `-v` command for docker but creating and managing new volumes in virtual fs.
* [--volumes-from tag][volumes-from] - allows to mount volumes from other running container.

[multi-builds]: https://docs.docker.com/v17.09/engine/userguide/eng-image/multistage-build/
[persistent-volumes]: https://docs.docker.com/storage/volumes/#create-and-manage-volumes
[volumes-from]: https://docs.docker.com/storage/volumes/#backup-restore-or-migrate-data-volumes
