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

Programmatically generate the [hugo.toml](hugo.toml) via `task gen-config`.

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

## Caddy + Docker

If deploying to `caddy`, add the following to `.env`:

| Key         | Default Value     |
| ----------- | ----------------- |
| `CADDY_DIR` | `</var/www/html>` |

where `</var/www/html>` is the path to the `caddy` root directory.

### HTTP (Port 80)

By default, the [Caddyfile](caddy/Caddyfile) is configured for HTTP on port 80 for local development.

### HTTPS (Port 443)

To enable HTTPS with automatic Let's Encrypt certificates:

1. Edit [caddy/Caddyfile](caddy/Caddyfile)
2. Comment out the `:80` HTTP block
3. Uncomment the `{$BASE_URL}` HTTPS block

Caddy will automatically obtain and renew SSL certificates from Let's Encrypt. No manual certificate management required.

If developing locally with HTTPS, add the following to `/etc/hosts`:

```bash
127.0.0.1 example.com
# 127.0.0.1 localhost
```

Where `example.com` is the value of `BASE_URL` in `.env`.

Remember to revert / comment out the `127.0.0.1 example.com` line and reinstate `127.0.0.1 localhost` when done.

### Starting Caddy

Build and start the `caddy` container:

```bash
docker compose up -d --build
```

Navigate to the `BASE_URL` in a browser:

* `http://example.com`
* `https://example.com`

## TODO

* [Issues](https://github.com/pythoninthegrass/hello_hugo/issues)
