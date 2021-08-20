![](https://avatars0.githubusercontent.com/u/2897191?s=70&v=4)

# gotham

various tools to support the ✨ cyber

[![CodeQL](https://github.com/thetanz/gotham/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/thetanz/gotham/actions/workflows/codeql-analysis.yml)
[![functions/](https://github.com/thetanz/gotham/actions/workflows/fn-ae-coretools-dev.yml/badge.svg)](https://github.com/thetanz/gotham/actions/workflows/fn-ae-coretools-dev.yml)
[![torproxy/](https://github.com/thetanz/gotham/actions/workflows/release-to-ghcr.yml/badge.svg)](https://github.com/thetanz/gotham/actions/workflows/release-to-ghcr.yml) [![dirsearch/](https://github.com/thetanz/gotham/actions/workflows/dirsearch-ghcr.yml/badge.svg)](https://github.com/thetanz/gotham/actions/workflows/dirsearch-ghcr.yml) [![sqlmap/](https://github.com/thetanz/gotham/actions/workflows/sqlmap-ghcr.yml/badge.svg)](https://github.com/thetanz/gotham/actions/workflows/sqlmap-ghcr.yml)

---

## functions 🌐

***namegenerator***

> uses [python/coolname](https://pypi.org/project/coolname) for random name generation

`GET /api/randomname`

```json
{ "name": "marvellous-eagle" }
```

## containers  🐳

### sqlmap

takes website from `STDIN`

    docker run ghcr.io/thetanz/gotham/sqlmap https://localhost

### dirsearch

takes website from `STDIN`

    docker run ghcr.io/thetanz/gotham/dirsearch https://localhost

### dumpsterdive

credential scanner to traverse a local directory (recursively) for high entropy keys or password strings
run in docker for safe execution - read-only and no networking

    docker run --rm --network none -v "${PWD}:/dd/files:ro" ghcr.io/thetanz/gotham/dumpsterdive:latest 

### torproxy

A minimal docker image exposing a SOCKS5 proxy for onion routing (tor) over tcp://9050

    docker run -p9050:9050 ghcr.io/thetanz/gotham/torproxy:latest

> Cloudflare have an [onion-routable DNS over HTTPS](https://developers.cloudflare.com/1.1.1.1/fun-stuff/dns-over-tor) endpoint available at `dns4torpnlfs2ifuz2s2yf3fc7rdmsbhm6rw75euj35pac6ap25zgqad.onion`

#### using within github actions

_this makes use of [GitHub Actions Service Containers](https://docs.github.com/en/actions/guides/about-service-containers)_

```yaml
jobs:
  torsocks-job:
    runs-on: ubuntu-latest
    services:
      torproxy:
        image: ghcr.io/thetanz/gotham/torproxy:latest
        ports:
        - 9050:9050
    steps:
      - name: checkout the repo
        uses: actions/checkout@v2
      - name: hello-world
        run: curl ipinfo.io --socks5 localhost:9050
```

#### using with curl

```shell
# proxy usage
curl --socks5 localhost:9050 ipinfo.io 
# onionsite usage
curl --socks5-hostname localhost:9050 facebookwkhpilnemxj7asaniu7vnjjbiltxjqhye3mhbshg7kx5tfyd.onion
```

#### using with python

```python
import json, requests

def get_tor_session():
    session = requests.session()
    # we use socks5h to route dns through the socks proxy
    # this reduces the risk of dns leaks and allows hidden service resolutions
    session.proxies = {'http':  'socks5h://127.0.0.1:9050',
                       'https': 'socks5h://127.0.0.1:9050'}
    return session

# make a request through the established tor circuit
session = get_tor_session()
response = session.get("https://facebookwkhpilnemxj7asaniu7vnjjbiltxjqhye3mhbshg7kx5tfyd.onion")
print(json.dumps(dict(response.headers)))
```

---

[Theta](https://theta.co.nz)
