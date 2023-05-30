---
layout: post
title:  "Running ansible INSIDE Docker"
tags: ['docker', 'ansible']
categories: work
---

I was looking for a way how I can test my ansible code inside docker. 


## Preparation part:

0. **centos-custom Dockerfile is in nearby post about systemd**

1. `inventory.yml` contents:
```yaml
        app_server:
          hosts:
            my-app-01:
              ansible_connection: docker
              ansible_python_interpreter: python
```

2. Docker start playbook - executed to create docker host with correct permissions:

```yaml
- name: Create ALM application container
  hosts: localhost
  tasks:
    - community.docker.docker_container:
        name: my-app-01
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
```

3. Also centoscustom image:

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

RUN echo '\[\033[38;5;22m\]\A\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;1m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;178m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;62m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]'  >> ~/.bashrc

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
```

## Run / test playbooks:
```yaml
# remove & create container
ansible-playbook destroy.yml && ansible-playbook -i inventory.yml playbook.yml 
# test playbook
ansible-playbook playbooks/provision-instances.yml --inventory inventories/docker-local-test.yml --limit my-app-01
```