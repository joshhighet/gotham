![](https://avatars0.githubusercontent.com/u/2897191?s=70&v=4)    ![](https://avatars2.githubusercontent.com/u/6844498?s=70&v=4)

<!-- core tooling & supporting/foundational functions -->
<!-- josh.highet@theta.co.nz -->
<!-- development/test/production -->

# Core Tooling

A collection of various tools to support operational workflows and aid commonly repeated tasks.

[![CodeQL](https://github.com/thetanz/coretools/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/thetanz/coretools/actions/workflows/codeql-analysis.yml)
[![functions/](https://github.com/thetanz/coretools/actions/workflows/fn-ae-coretools-dev.yml/badge.svg)](https://github.com/thetanz/coretools/actions/workflows/fn-ae-coretools-dev.yml)
[![torproxy/](https://github.com/thetanz/coretools/actions/workflows/release-to-ghcr.yml/badge.svg)](https://github.com/thetanz/coretools/actions/workflows/release-to-ghcr.yml)
---

## functions 🌐

***namegenerator***

> use [python/coolname](https://pypi.org/project/coolname) for random name generation as a REST API. Used to randomise project and incident names and along with create memorable identifiers for cloud resources.

`GET /api/randomname`

```json
{ "name": "marvellous-eagle" }
```

## containers  🐳

***sqlmap***

takes website from `STDIN`

    docker run sqlmap http://localhost

***dirsearch***

takes website from `STDIN`

    docker run dirsearch http://localhost

***torproxy***

A minimal docker image exposing a SOCKS5 proxy for onion routing (tor) over tcp://9050

> Cloudflare have an [onion-routable DNS over HTTPS](https://developers.cloudflare.com/1.1.1.1/fun-stuff/dns-over-tor) endpoint available at `dns4torpnlfs2ifuz2s2yf3fc7rdmsbhm6rw75euj35pac6ap25zgqad.onion`

---

> ***running***

tbd

> ***using within github actions***

_this makes use of [GitHub Actions Service Containers](https://docs.github.com/en/actions/guides/about-service-containers)_

```yaml
jobs:
  torsocks-job:
    runs-on: ubuntu-latest
    services:
      torproxy:
        image: ghcr.io/thetanz/coretools/torproxy:latest
        ports:
        - 9050:9050
    steps:
      - name: checkout the repo
        uses: actions/checkout@v2
      - name: hello-world
        run: curl ipinfo.io --socks5 localhost:9050
```

> ***using with curl***

```shell
curl ipinfo.io --socks5 localhost:9050 #proxy usage
curl facebookwkhpilnemxj7asaniu7vnjjbiltxjqhye3mhbshg7kx5tfyd.onion --socks5-hostname localhost:9050 #onionsite
```

> ***using with python***

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
- 2021 <a href="https://theta.co.nz/cyber" target="_blank">Theta</a>.
