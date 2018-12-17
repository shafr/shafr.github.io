---
layout: post
title:  "Docker Home-assistant issues after kernel update"
tags: [octoprint]
categories: life
---

So everything started with my TinkerBoard when i executed `apt-update; apt upgrade`. 
Kernel was updated to version `4.4.103+`. 
And docker just died. 

Below are some issues that had occurred.

## Dependency failed for Docker Application Container Engine
That looks very much like error described in this thread:

(Stack Overflow)[https://stackoverflow.com/questions/53233477/updating-the-docker18-09-0-causes-an-error/53235589#53235589]

I've tried checking for modules, and it seems like either they were removed or something strange had happened:

```bash
/sbin/modprobe overlay

modprobe: FATAL: Module overlay not found in directory /lib/modules/4.4.103+
```

Solution is:
```
Open out: /lib/systemd/system/containerd.service 
Update option to look like this: 

...
ExecStartPre=
...
```

## No space left on device

That's the next one after i've restarted containerd and dockerd service.
When pulling 1GB docker image, it is taking around 8 GB of storage. I felt that something was way off, but I thought it's the way docker works.

```
525M    ./baea133a3db44b7e2ce5d44611408e624159cb2de4071d12434ae38b922cabf1
102M    ./8ba8ffd894850edced59927b9d1ae9e71bf44acd7fec485a89922fc9507339b7
23M     ./142784474f1fde02a03aab191130ce287186e0a5d8abd7565ff6db6d2fe556ed
559M    ./29959ae55bbcf94656f0b42273757c702a72a15a298780fac9a88afed1d48377
116M    ./b69fa301d3fd30fe08400509a5d5db8a5e960e2dd2524f39e979da22794aef46
4.4M    ./0839f6ead41d9395b9beb947c2917296259d2de7ce286faa752e7d56c9df6aed
8.0M    ./9cdfa9ddfc3b4be236992e8267b0c17cee284ee14fbe80bc7160dd45aa6e36df
525M    ./239259500c0a797082256d8a9de7c73d7c51234c589499290861b83f6b32e10e
457M    ./b113399d80855f19a28a3956d7fa24b1baa20fdfade2b32525d3dc4697948a68
340M    ./a2f1c426a2a27cd3047346e55378efbcbbae34bbbe3c7bb88d28995f060251dc
459M    ./c2ee11cc34656de6ad1a16fd8e3d3c495053a00f299c23194849ed98df82709d
23M     ./26808909ac890fff5a2b359bdb6b9e7638547e262e4fdef9a0ea77dbfff36dd6
122M    ./8437066755d58f253f49b5d0e4a5608a6c13693c6167072b744c145775be926b
482M    ./fc27245399ae9168941f3e4ea9c3d7a3e44935aa558d802ea6d353c22108a175
4.4M    ./5aad66d81bc9a3515983a71e19285657f4cf769461ea2ccc0a5e0e03ed866a66
114M    ./254ef82eab69018ccf19a870d3a688caaecd381ed9d70d5b8b5826e08991a49d
102M    ./7c3fab92f8163b3c146877c36f35f8ae66e0920b16f83a64ba64ee694dbc5091
525M    ./cbbe3b85d20969911e5dcd5ec2b4937fea8ec4083724ca63b26c2abbc14bad51
23M     ./02720088749ba6eba8a080b474874ae0893de446132e5cbd763bad32b721085e
332M    ./835a4370a97b30e6f3329f545386b02fd456892d391514ce06dbcf830ac479e9
```

Peaking at docker information i've found out that it's using `VFS` storage driver. It's a killer for a space on a drive.


```
root@asus_mini:/etc/docker# docker system info
...
Server Version: 18.09.0
Storage Driver: vfs
Logging Driver: json-file
Cgroup Driver: cgroupfs
...
```

# 'overlay' not found as a supported filesystem on this host. Please ensure kernel is new enough and has overlay support loaded." storage-driver=overlay2

So I've started looking at the options, that would allow to fix this issue. Auxfs and overlay are not found using modprobe. I have no clue how to install them.


Then i found great script to check what is supported on system:
```
https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh
```

Output that i was looking for looks like this:
```
...
- Storage Drivers:
  - "aufs":
    - CONFIG_AUFS_FS: missing
  - "btrfs":
    - CONFIG_BTRFS_FS: missing
    - CONFIG_BTRFS_FS_POSIX_ACL: missing
  - "devicemapper":
    - CONFIG_BLK_DEV_DM: enabled
    - CONFIG_DM_THIN_PROVISIONING: enabled
  - "overlay":
    - CONFIG_OVERLAY_FS: missing
  - "zfs":
    - /dev/zfs: missing
    - zfs command: missing
    - zpool command: missin
...
```


Ok, let's update driver to devicemapper:

```
Update /etc/docker/daemon.json

{
  "storage-driver": "devicemapper"
}
```

# Error starting daemon: error initializing graphdriver: driver not supported


```
Nov 19 17:01:39 asus_mini dockerd[4520]: time="2018-11-19T17:01:39.024183152+01:00" level=error msg="Failed to GetDriver graph" driver=devicemapper error="graphdriver plugins are only supported with experimental mode" home-dir=/var/lib/docker
Nov 19 17:01:39 asus_mini dockerd[4520]: Error starting daemon: error initializing graphdriver: driver not supported
```


At this point I've said - screw you Docker. I'm moving to clean python with venv. At least this way I would not have virtualization issues & I would be able to use normal fail2ban without dirty tricks.
