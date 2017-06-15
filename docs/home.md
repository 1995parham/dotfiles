---
title: Home Sweet Home
layout: page
theme: red
---

## Topology

Parham Edge (1):

{:.table .table-striped}
| IP Address       | Name                | Comment         |
|:----------------:|:-------------------:|:----------------|
| 192.168.1.1      | Provider Access Dev | TCI ADSL        |

Parham Master (73):

{:.table .table-striped}
| IP Address       | Name                | Comment         |
|:----------------:|:-------------------:|:----------------|
| 192.168.73.1     | Parham MacBookPro   | ESXi            |
| 192.168.73.2     | Parham MacBookPro15 | Desktop         |
| 192.168.73.3     | Parham Main         | ESXi            |
| 192.168.73.4     | Parham USVM 1       | Ubuntu Server   |
| 192.168.73.5     | Parham USVM 2       | Ubuntu Server   |
| 192.168.73.6     | Parham USVM 3       | Ubuntu Server   |
| 192.168.73.7     | Parham SVE14A27CXH  | TV              |
| 192.168.73.8     | Parham USVM 4       | Ubuntu Server   |
| 192.168.73.10    | NAS                 | -               |
| 192.168.73.13    | Renge Extender      | -               |
| 192.168.73.254   | DNS - Gateway       | -               |


## ESXi 6.5
### govc
govc is a command-line application for interacting with VMware vSphere APIs (ESXi and/or vCenter).

```sh
go get -u github.com/vmware/govmomi/govc
```

After installation you can use this awesome tool with

```sh
govc command -u user:pass@host
```

## Docker Container Management
### Photon, Minimal linux container host
### Docker in our fatherland

Thanks to [docker.ir](http://www.docker.ir/). Copy following content `/etc/docker/daemon.json`:

```json
{
  "registry-mirrors": [
    "http://repo.docker.ir:5000"
  ],
  "userland-proxy": false
}
```

### Docker Monitoring based on []

Portainer is a simple management solution for docker.
it consists of a webUI that allows you to easily manage your docker containers, images, networks and volumes.

> remote docker engine

```sh
docker run -d -p 9000:9000 portainer/portainer -H tcp://<REMOTE_HOST>:<REMOTE_PORT>
```

> local docker engine

```sh
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock --name portainer portainer/portainer
```
