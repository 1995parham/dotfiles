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
| 192.168.73.9     | Main Photon         | Photon OS       |
| 192.168.73.10    | NAS                 | -               |
| 192.168.73.11    | vCenter             | -               |
| 192.168.73.12    | Parham Giant        | ESXi            |
| 192.168.73.13    | Renge Extender      | -               |
| 192.168.73.254   | DNS - Gateway       | -               |


## vSphere 6.5
### govc
govc is a command-line application for interacting with VMware vSphere APIs (ESXi and/or vCenter).

```sh
go get -u github.com/vmware/govmomi/govc
```

After installation you can use this awesome tool with

```sh
govc command -u user:pass@host
```

### vCenter
First of all install the vCenter appliance after setup completed and vm started successfully,
go to `:5480` and complete the installation. (Please note that vCenter need a simple DNS).

## Docker Container Management
### Photon, Minimal linux container host
Photon is a awesome thing :yum:

- Enable docker remote API

```sh
systemctl stop docker

cat > /etc/default/docker << "EOF"

DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"
EOF

iptables -A INPUT -p tcp --dport 2375 -j ACCEPT

```

- setup static ip address

```sh
cat > /etc/systemd/network/10-static-en.network << "EOF"

[Match]
Name=eth0

[Network]
Address=198.51.0.2/24
Gateway=198.51.0.1
EOF

chmod 644 10-static-en.network
rm 10-dhcp-en.network

systemctl restart systemd-networkd
```

### Docker in our fatherland

Thanks to [docker.ir](http://www.docker.ir/).

- **ubuntu**: copy following content into `/etc/docker/daemon.json`:

```json
{
  "registry-mirrors": [
    "http://repo.docker.ir:5000"
  ],
  "userland-proxy": false
}
```

- **photon**: first enable docker service with `systemctl enable docker`
and add following content into `/etc/systemd/system/multi-user.target.wants/docker.service`:

```sh
--registry-mirror=http://repo.docker.ir:5000
```

### Docker Monitoring based on [Admiral](https://github.com/vmware/admiral)
Let's run admiral forever

```sh
sudo docker run -t -d -p 8282:8282 --name admiral --restart unless-stopped vmware/admiral
```
