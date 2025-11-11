# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hugo static site using the Ananke theme (via git submodule). The project uses mise for runtime management, Taskfile for build automation, and Caddy for containerized deployment.

## Architecture

### Runtime Management

- **mise** manages Hugo Extended and Go versions via `.tool-versions`
- Hugo Extended is required (not standard Hugo) for SASS/SCSS processing
- All Hugo commands MUST be run via `mise exec -- hugo` to use the correct version

### Configuration Generation

- `hugo.toml` is generated from `.env` variables via `task gen-config`
- Template interpolation happens in taskfile.yml using Taskfile's `{{.VAR}}` syntax
- `hugo.toml` should NOT be edited directly - edit `.env` and regenerate

### Theme Management

- Ananke theme is a git submodule in `themes/ananke`
- Update theme with `task pull` which runs recursive submodule updates
- Theme is on the `main` branch (not a tagged release)

### Deployment Architecture

- **Development**: Hugo built-in server with hot reload
- **Production**: Static files served by Caddy in Docker
- Caddy provides automatic HTTPS via Let's Encrypt (no manual cert management)
- The `nginx/` directory exists but is legacy - project now uses Caddy

## Essential Commands

### Development Workflow

```bash
# Initial setup
task install                    # Install mise dependencies
task pull                       # Update git submodules (theme)
cp .env.example .env            # Configure site variables
task gen-config                  # Generate hugo.toml from .env

# Development server
task run                        # Start Hugo dev server (default port 1313)
PORT=8080 task run              # Start on custom port

# Build
task build                      # Build site to public/ directory
```

### Content Management

```bash
# Create new content (via mise)
mise exec -- hugo new posts/my-post.md

# Content is in content/posts/
# Static assets go in static/
```

### Docker Deployment

```bash
# Docker Compose (recommended)
task docker:up                # Build and start in background
task docker:logs              # Follow logs
task docker:exec              # Shell into container
task docker:down              # Stop and remove volumes

# Docker Buildx (multi-platform builds)
task docker:buildx            # Build for current platform and load to Docker
task docker:buildx -- amd64   # Build for AMD64 and load to Docker
task docker:buildx -- arm64   # Build for ARM64 and load to Docker
task docker:buildx -- multi-platform  # Build both platforms (cached only)

# Docker Run (direct container execution)
# Basic HTTP (port 80 only)
docker run -d \
  --name hello-hugo \
  -p 80:80 \
  -v $(pwd)/public:/var/www/public:ro \
  ghcr.io/pythoninthegrass/hello-hugo:latest

# Full setup with HTTPS support
docker run -d \
  --name hello-hugo \
  -p 80:80 \
  -p 443:443 \
  -e BASE_URL=example.com \
  -v $(pwd)/public:/var/www/public:ro \
  -v caddy_data:/data \
  -v caddy_config:/config \
  ghcr.io/pythoninthegrass/hello-hugo:latest

# Host networking (same as docker-compose setup)
docker run -d \
  --name hello-hugo \
  --network host \
  -e BASE_URL=example.com \
  -v $(pwd)/public:/var/www/public:ro \
  -v caddy_data:/data \
  -v caddy_config:/config \
  ghcr.io/pythoninthegrass/hello-hugo:latest

# Manual deployment to external Caddy
task deploy                   # Requires CADDY_DIR in .env
```

### Debugging

```bash
task printenv                 # Print taskfile variables
task --list                   # Show all available tasks
mise exec -- hugo version     # Verify Hugo Extended is active
```

## Environment Variables

Required in `.env`:

- `BASE_URL` - Domain name (e.g., example.com)
- `LANGUAGE` - Language code (e.g., en-us)
- `TITLE` - Site title
- `THEME` - Theme name (currently "ananke")

Optional:

- `PORT` - Dev server port (default: 1313)
- `CADDY_DIR` - External Caddy deployment path

## Project Structure

```text
.
├── caddy/                   # Caddy web server config
│   └── Caddyfile             # HTTP/HTTPS configuration
├── content/                 # Hugo content
│   └── posts/               # Blog posts
├── themes/                  # Theme submodules
│   └── ananke/              # Ananke theme (git submodule)
├── taskfiles/                # Taskfile includes
│   └── docker.yml           # Docker-specific tasks
├── public/                  # Generated static site (gitignored)
├── hugo.toml                # Hugo config (generated, don't edit)
├── .tool-versions           # mise runtime versions
├── .env                     # Site configuration (gitignored)
└── taskfile.yml              # Build automation
```

## Important Notes

### Hugo Extended Requirement

This project requires Hugo Extended for SASS processing. The `.tool-versions` file specifies `hugo-extended`, not `hugo`.

### Configuration Workflow

1. Never edit `hugo.toml` directly
2. Always edit `.env` and run `task gen-config`
3. The gen-config task uses Taskfile variable interpolation, not jinja2

### HTTPS in Production

Edit `caddy/Caddyfile` to enable HTTPS:

- Comment out the `:80` HTTP block
- Uncomment the `{$BASE_URL}` HTTPS block
- Caddy will automatically obtain Let's Encrypt certificates

### Docker Deployment Prerequisites

Before running Docker containers:

1. Build the site first: `task build` (generates `public/` directory)
2. The `public/` directory must exist and contain the built site
3. For custom images, use `task docker:buildx` to build locally
4. For published images, pull from `ghcr.io/pythoninthegrass/hello-hugo:latest`
