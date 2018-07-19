---
layout: post
title:  "Git merge can be hard"
tags: [github, java]
categories: git
---

So our git repository is implemented in a way that commits are squashed during pull request merge.
So if one is doing two pull requests - second one would include old commits.

## Solution one (correct way of doing things)
Create new branch for new feature. 

## Solution two - ugly but working

* from your branch do 
```bash
git diff upstream/trunk > patch.txt
```

* Create new temp branch & switch to that branch
```bash
git branch megabranch upstream/trunk
git checkout megabranch
```

* Use IntelliJ Idea to import patch: `VCS -> Apply patch`. (somehow command line had lots of issues)

* create your `megabranch` branch remotely and push there 
```bash
git push origin
```

* Profit!


## Also useful commands from git:
* List commit id's if you want to do cherry-pick afterwards
```bash
git log --grep "<something>" --format="%h"
```

* Create patches from previous n commits
```bash
git format-patch -n
```

* List remote branches
```bash
git remote -v
```