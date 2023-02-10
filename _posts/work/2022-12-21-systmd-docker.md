---
layout: post
title:  "Systemd Docker"
tags: ['docker', 'systemd', 'cgroups2']
categories: work
---

## Problem

I was looking for a way how to test ansible scripts inside docker. It works, but there was a problem - the systemd roles, for example:

```yaml
- name: Reload systemd
  ansible.builtin.systemd:
  daemon_reload: yes
```

And other were failing with different errors.




## Solution:

First of all `Dockerfile` that would be used to run the image (taken from a [PR](https://github.com/geerlingguy/docker-centos7-ansible/pull/21)):

```Dockerfile
FROM centos:7
LABEL maintainer="Jeff Geerling"
ENV container=docker

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV pip_packages "ansible==4.10.0"

# Install systemd -- See https://hub.docker.com/_/centos/
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install requirements.
RUN yum makecache fast \
 && yum -y install wget deltarpm epel-release initscripts \
 && wget --no-check-certificate https://copr.fedorainfracloud.org/coprs/jsynacek/systemd-backports-for-centos-7/repo/epel-7/jsynacek-systemd-backports-for-centos-7-epel-7.repo -O /etc/yum.repos.d/jsynacek-systemd-centos-7.repo \
 && yum makecache fast \
 && yum -y update \
 && yum -y install \
      sudo \
      which \
      python3-pip \
 && yum clean all

# Upgrade Pip so cryptography package works.
RUN python3 -m pip install --upgrade pip==21.3.1

# Install Ansible via Pip.
RUN pip3 install $pip_packages

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
```

Secondly - docker should be running with correct arguments (based on [cgroups workaround](https://www.jeffgeerling.com/blog/2022/docker-and-systemd-getting-rid-dreaded-failed-connect-bus-error)):

```yaml
- name: Create our container
  hosts: localhost
  tasks:
    - community.docker.docker_container:
        name: docker-centos
        image: centoscustom
        privileged: false
        command: ["/usr/lib/systemd/systemd"]
        volumes:
        - /sys/fs/cgroup:/sys/fs/cgroup:rw
        - /var/lib/containerd
        tmpfs:
        - /tmp
        - /run
        cgroupns_mode: host

- name: Run init commands
  hosts: docker-centos
  roles:
    - name: "docker-role"
```

So I had to test a lot of code before getting to working version.
The funniest here was if using `privileged: true` caused my working session to log off.
I was not able ot pinpoint the exact issue, it was just frustrating. 
