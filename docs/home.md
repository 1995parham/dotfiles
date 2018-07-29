## Topology

Parham Edge (75):

| IP Address       | Name                | Comment         |
|:----------------:|:-------------------:|:----------------|
| 192.168.75.254   | Provider Access Dev | TCI             |

Parham Master (73):

| IP Address       | Name                | Comment         |
|:----------------:|:-------------------:|:----------------|
| 192.168.73.1     | Parham MacBookPro   | ESXi            |
| 192.168.73.2     | Parham iMac         | Desktop         |
| 192.168.73.3     | Parham Main         | ESXi            |
| 192.168.73.4     | Parham USVM 1       | Ubuntu Server   |
| 192.168.73.5     | Parham USVM 2       | Ubuntu Server   |
| 192.168.73.6     | Parham USVM 3       | Ubuntu Server   |
| 192.168.73.7     | Parham USVM 4       | Ubuntu Server   |
| 192.168.73.10    | NAS                 | -               |
| 192.168.73.11    | vCenter             | -               |
| 192.168.73.12    | Parham Giant        | ESXi            |
| 192.168.73.13    | Renge Extender      | -               |
| 192.168.73.13    | Parham NUC          | ?               |
| 192.168.73.100   | DNS                 | -               |
| 192.168.73.101   | DLink Switch        | -               |
| 192.168.73.102   | Parham Giant Mgmt   | iKVM            |
| 192.168.73.103   | OpenFiler           | -               |
| 192.168.73.254   | Gateway             | -               |


## Openfiler
Login into web management interface on `https://192.168.73.103:446/`
with `openfiler:password`.

## vSphere 6.5
### govc
govc is a command-line application for interacting with VMware vSphere APIs (ESXi and/or vCenter).

```sh
go get -u github.com/vmware/govmomi/govc
```

After installation you can use this awesome tool with

```sh
govc host.info -u user:pass@host
govc vm.info -vm.ip 192.168.73.4 -u user:pass@host
govc vm.info -vm.ipath "/ha-datacenter/vm/Windows 7 x64" -u user:pass@host
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

### Docker Monitoring based on [Admiral](https://github.com/vmware/admiral)

### Docker Management based on [Portainer](https://github.com/portainer)
