# Home
Home network topology and used technologies described in this section.

## Topology

Parham Edge (75):

| IP Address       | Name                | Comment             |
|:----------------:|:-------------------:|:--------------------|
| 192.168.75.254   | PoP                 | Connected to ZI-TEL |

Parham Master (73):

| IP Address       | Name                | Comment                         |
|:----------------:|:-------------------:|:--------------------------------|
| 192.168.73.1     | Parham Center       | ESXi                            |
| 192.168.73.2     | Parham iMac         | Desktop                         |
| 192.168.73.3     | Parham Compute      | ESXi                            |
| 192.168.73.4     | Parham USVM 1       | Ubuntu Server - SSD             |
| 192.168.73.5     | Parham USVM 2       | Ubuntu Server - CPLEX - SSD     |
| 192.168.73.6     | Parham USVM 3       | Ubuntu Server - Snapp - Non-SSD |
| 192.168.73.7     | Kube                | Ubuntu Server - SSD             |
| 192.168.73.8     | Parham USVM 4       | Ubuntu Server - I1820 - SSD     |
| 192.168.73.9     | vCenter             | -                               |
| 192.168.73.10    | NAS                 | -                               |
| 192.168.73.11    | Parham Mininet      | Ubuntu Server - non SSD         |
| 192.168.73.12    | Parham Op           | ESXi                            |
| 192.168.73.99    | Parham Zipp         | Libratone                       |
| 192.168.73.100   | DNS                 | -                               |
| 192.168.73.101   | DLink Switch        | -                               |
| 192.168.73.102   | Parham Op Mgmt      | iKVM                            |
| 192.168.73.103   | OpenVPN             | Ubuntu Server                   |
| 192.168.73.106   | FreeNAS             | -                               |
| 192.168.73.252   | Macbook Pro 13      | VPN Endpoint                    |
| 192.168.73.253   | Snapp Macbook Pro   | VPN Endpoint                    |
| 192.168.73.254   | Gateway             | -                               |
| DHCP             | Parham SVE14A27CXH  | Ubuntu Desktop                  |


## FreeNAS
I have installed [freenas](https://freenas.org/) on a separate VM and its web management
interface is available on `http://192.168.73.106/` with `root` access.

## vSphere
Each physical server has vSphere 6.7 installed and is connected to vCenter.

### govc

govc is a command-line application for interacting with VMware vSphere APIs (ESXi and/or vCenter).
It can install with the following command:

```sh
go get -u github.com/vmware/govmomi/govc
```

After installation you can use this awesome tool like the following example:

```sh
govc host.info
govc ls '*'
govc vm.info -vm.ip 192.168.73.4
govc vm.info -vm.ipath "/ha-datacenter/vm/Windows 7 x64"
```

you can store the usefule information in `~/.zshrc.local`:

```sh
export GOVC_USERNAME=administrator@parham.home
export GOVC_PASSWORD=secret
export GOVC_URL=192.168.73.9
export GOVC_INSECURE=true
```

## Movie Storages
These disks are available as storage for movies. In each of them, all movies are stored on `Personal Data\My Folders\My Videos\Movie`.

- Parham HDD 1 (1.5T)
- Parham HDD 2 (1T)
- Parham HDD 3 (500G)
- Parham HDD 4 (500G)
- Parham HDD 5 (1T)
