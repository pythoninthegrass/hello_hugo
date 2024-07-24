# hello_hugo

Absolute minimum to scaffold a Hugo static site with a [custom theme](https://gohugo.io/getting-started/quick-start/).

## Minimum Requirements

* macOS or Linux
* [Hugo](https://gohugo.io/getting-started/installing/)
  * Linux: ignore package manager / snap packages, download latest [GitHub release](https://github.com/gohugoio/hugo/releases/)

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

## TODO

* [Issues](https://github.com/pythoninthegrass/hello_hugo/issues)
