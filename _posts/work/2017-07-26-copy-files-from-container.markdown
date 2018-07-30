---
layout: post
title:  "Downloading / Uploading files to Docker and Openshift containers"
tags: [docker, openshift, bash]
categories: work
---

Oftentimes there is need to copy files from Openshift / Docker machine. 

This tip is useful when SCP is not available, you are not owner of host machine.


## Droopy
[Droopy][Droopy-website] is python-based HTTP server. 

On the Container side:
```bash
wget https://raw.githubusercontent.com/stackp/Droopy/master/droopy
python droopy --dl 8090
```

On the host machine side (for Openshift):
```bash
oc login ...
oc port-forward <pod> 8090:8090
```

Login to web-browser on localhost:8090 and download/upload files.

## transfer.sh

I recommend checking [transfer.sh][transfersh-website] site for more info on arguments (such as encryption).


* Login to your pod machine, and zip files for easier transfer:
```bash
zip -9 -e -r <archive name> <file or folder to zip>
```
* Provide password for archive (you can never be too paranoid)
* Upload files using transfer.sh and create any meaningful:
```bash
curl --upload-file <file> https://transfer.sh/<alias url>
```
* Download file from other machine using your URL generated.

[transfersh-website]: https://transfer.sh/
[Droopy-website]: https://github.com/stackp/Droopy