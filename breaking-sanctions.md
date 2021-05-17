## V2ray

Our country is under many **unfair** sanctions so you can use [v2ray](https://www.v2ray.com/en/) on Linux to remove these sanctions.
Use the following commands to install it.

```sh
curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
chmod +x install-release.sh
sudo ./install-release.sh
sudo systemctl enable v2ray
```

You can configure it in many ways with `/usr/local/etc/v2ray/config.json` but here is my sample for connecting via shadowsocks into a remote server and exposing the HTTP and socks interfaces.

```json
{
  "inbounds": [
    { "port": 1080, "protocol": "http" },
    { "port": 1086, "protocol": "socks", "udp": true, "auth": "noauth" }
  ],

  "outbounds": [
    {
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "an-awesome-server",
            "method": "aes-256-gcm",
            "ota": false,
            "password": "secret",
            "ivCheck": true,
            "port": 1378
          }
        ]
      }
    }
  ]
}
```

Then after starting v2ray service `sudo systemctl start v2ray`, you are good to go

## HTTP/Socks Proxy

you can use the following commands in your shell to enable/disable http(s) proxy.

```sh
proxy_start   # enable http(s) proxy
proxy_stop    # disable http(s) proxy
```

or use the following **general** commands:

```sh
export {http,https,ftp}_proxy="http://127.0.0.1:1080" # enable http(s) proxy
unset {http,https,ftp}_proxy                          # disable http(s) proxy
```

To have environment variables with `sudo` you have to run it with `-E`.
Some apt repositories need proxy so you can configure them in `/etc/apt/apt.conf.d/99proxy`:

```
Acquire::http::Proxy::download.docker.com "http://127.0.0.1:1080";
```

For having proxy on docker use the following procedure:

```sh
sudo mkdir -p /etc/systemd/system/docker.service.d
```

Then update `/etc/systemd/system/docker.service.d/http-proxy.conf` with:

```
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:1080/"
```

And reload the docker daemon:

```sh
sudo systemctl daemon-reload
sudo systemctl restart docker
```
