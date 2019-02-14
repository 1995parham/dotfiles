Home network topology and used technologies described in this section.

## Topology

Parham Edge (75):

| IP Address       | Name                | Comment         |
|:----------------:|:-------------------:|:----------------|
| 192.168.75.254   | PoP                 | ?               |

Parham Master (73):

| IP Address       | Name                | Comment                         |
|:----------------:|:-------------------:|:--------------------------------|
| 192.168.73.1     | | |
| 192.168.73.2     | Parham iMac         | Desktop                         |
| 192.168.73.3     | Parham Main         | ESXi                            |
| 192.168.73.4     | Parham USVM 1       | Ubuntu Server - I1820 - SSD     |
| 192.168.73.5     | Parham USVM 2       | Ubuntu Server - I1820 - SSD     |
| 192.168.73.6     | Parham USVM 3       | Ubuntu Server - Snapp - Non-SSD |
| 192.168.73.7     | | |
| 192.168.73.8     | Parham NUC          | Ubuntu Desktop                  |
| 192.168.73.10    | NAS                 | -                               |
| 192.168.73.11    | | |
| 192.168.73.12    | Parham Giant        | ESXi                            |
| 192.168.73.13    | Renge Extender      | -                               |
| 192.168.73.99    | Parham Zipp         | -                               |
| 192.168.73.100   | DNS                 | -                               |
| 192.168.73.101   | DLink Switch        | -                               |
| 192.168.73.102   | Parham Giant Mgmt   | iKVM                            |
| 192.168.73.103   | OpenFiler           | -                               |
| 192.168.73.254   | Gateway             | -                               |


## Openfiler

Web management interface is on `https://192.168.73.103:446/`
with `openfiler:password` as login information.

## vSphere 6.5
### govc

govc is a command-line application for interacting with VMware vSphere APIs (ESXi and/or vCenter).
It can install with the following command:

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

First of all, install the vCenter appliance after setup completed and VM started successfully,
go to `:5480` and complete the installation. (Please note that vCenter need a simple DNS).


## Docker Monitoring based on [Admiral](https://github.com/vmware/admiral)

## Docker Management based on [Portainer](https://github.com/portainer)
