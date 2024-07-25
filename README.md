# hello_hugo

Absolute minimum to scaffold a Hugo static site with a [custom theme](https://gohugo.io/getting-started/quick-start/).

## Minimum Requirements

* macOS or Linux
* [Hugo](https://gohugo.io/getting-started/installing/)
  * Linux: ignore package manager / snap packages, download latest [GitHub release](https://github.com/gohugoio/hugo/releases/)

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

Programmatically generate the [hugo.toml](hugo.toml) via `python` and `devbox`.

Minimum values in `.env`:

| Key        | Default Value   |
| ---------- | --------------- |
| `BASE_URL` | `example.com`   |
| `LANGUAGE` | `en-us`         |
| `TITLE`    | `Hello, World!` |
| `THEME`    | `ananke`        |

If deploying to `nginx`, add the following to `.env`:

| Key          | Default Value     |
| ------------ | ----------------- |
| `NGINX_DIR`  | `</var/www/html>` |

where `</var/www/html>` is the path to the `nginx` root directory.

```bash
devbox install
cp .env.example .env
# edit .env
devbox run gen-config
hugo
```

## TODO

* [Issues](https://github.com/pythoninthegrass/hello_hugo/issues)
