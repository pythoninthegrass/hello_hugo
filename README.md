# hello_hugo

Absolute minimum to scaffold a Hugo static site with a [custom theme](https://gohugo.io/getting-started/quick-start/).

(With some dev tooling added after the fact 😈)

## Minimum Requirements

* macOS or Linux
* [Hugo](https://gohugo.io/getting-started/installing/)
  * Linux: ignore package manager / snap packages, download latest [GitHub release](https://github.com/gohugoio/hugo/releases/)
  * Make sure to get the extended version (e.g., `hugo_extended_0.129.0_linux-amd64.tar.gz`)

## Recommended Requirements

* [taskfile](https://taskfile.dev/#/installation)
* [devbox](https://www.jetify.com/devbox/docs/quickstart/)

## Quickstart

```bash
# clone repo
git clone https://github.com/pythoninthegrass/hello_hugo.git
cd hello_hugo

# clone theme submodule
[ $(uname -s) == "Darwin" ] && procs=$(sysctl -n hw.ncpu) || procs=$(nproc)
git submodule update --init --recursive && git pull --recurse-submodules -j"${procs}"

# add a new post
hugo new posts/test-post.md

# start hugo server (with hot reloading)
hugo server

# open browser to http://localhost:1313

# stop hugo server
# CTRL+C
```

## Customize

### Fill out `.env` file

Programmatically generate the [hugo.toml](hugo.toml) via `python` and `devbox`.

Minimum values in `.env`:

| Key        | Default Value   |
| ---------- | --------------- |
| `BASE_URL` | `example.com`   |
| `LANGUAGE` | `en-us`         |
| `TITLE`    | `Hello, World!` |
| `THEME`    | `ananke`        |

### Generate `hugo.toml`

```bash
devbox install
cp .env.example .env
# edit .env
devbox run gen-config
```

### Build

```bash
hugo
```

## Nginx + Docker

If deploying to `nginx`, add the following to `.env`:

| Key         | Default Value     |
| ----------- | ----------------- |
| `NGINX_DIR` | `</var/www/html>` |

where `</var/www/html>` is the path to the `nginx` root directory.

### HTTP (Port 80)

Comment out the line in [docker-compose.yml](docker-compose.yml) that mounts the `nginx` [certs](nginx/certs) directory.

```yaml
volumes:
  - ./public:/var/www/public
  # - ./nginx/certs:/etc/acme/certs/live/${BASE_URL}
```

### HTTPS (Port 443)

Generate certificates with either [acme.sh](https://github.com/acmesh-official/acme.sh) or [certbot](https://certbot.eff.org/).

Copy the following files to the `nginx` [certs](nginx/certs) directory:

* `fullchain.pem`
* `privkey.pem`
* `ssl-dhparams.pem`

If developing locally, add the following to `/etc/hosts`:

```bash
127.0.0.1 example.com
# 127.0.0.1 localhost
```

Where `example.com` is the value of `BASE_URL` in `.env`.

Remember to revert / comment out the `127.0.0.1 example.com` line and reinstate `127.0.0.1 localhost` when done.

### Both HTTP and HTTPS

Build and start the `nginx` container:

```bash
docker compose up -d --build
```

Navigate to the `BASE_URL` in a browser:

* `http://example.com`
* `https://example.com`

## TODO

* [Issues](https://github.com/pythoninthegrass/hello_hugo/issues)
