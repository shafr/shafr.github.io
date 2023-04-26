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

## Run / test playbooks:
```yaml
# remove & create container
ansible-playbook destroy.yml && ansible-playbook -i inventory.yml playbook.yml 
# test playbook
ansible-playbook playbooks/provision-instances.yml --inventory inventories/docker-local-test.yml --limit my-app-01
```