# Docker Boilerplate

A base boilerplate setup to start containerized PHP + proxy + optional services quickly.

By default, the application source code is **copied into the image** during build.  
This means the code inside running containers will not change unless you rebuild the image.  
This approach is stable and predictable, which is preferred for production deployments.

For development, you should use `./start.sh dev`

## Static Assets

Static files (e.g. CSS, JavaScript, images) are copied into the **proxy container** and served directly by Nginx.

This design is intentional:

- **php-fpm** is optimized for executing PHP code, not for serving static files.
- Letting the proxy (Nginx) handle static assets reduces latency and improves performance, since Nginx is far more efficient at serving files.
- PHP-FPM only processes other requests

---

## Contents

```text
├── docker              # Docker service definitions / configs
├── src                 # Your PHP application source code
├── .env.dist           # Sample environment file
├── docker-compose.yml  # Base Compose file
├── docker-compose.dev.yml   # Overrides for dev environment
├── start.sh            # Helper to start / restart with optional profiles
```

---

## Requirements

- Docker  
- Docker Compose CLI  
- POSIX shell (script is sh-compatible)

---

## Setup

1. Copy `.env.dist` to `.env` and adjust values if needed.  
2. Run `chmod u+x ./start.sh` 
3. Run `./start.sh` to spin up the default services.

---

## Usage

The `start.sh` script wraps `docker compose` and adds convenience flags.

### Options

- `start`  
  Explicit start command (optional).
- `start dev`  
  Include `docker-compose.dev.yml` for development overrides.
- `--with <profiles>`  
  Enable one or more extra services (comma-separated). Example: `--with redis,pgadmin`
- `-h`, `--help`  
  Show usage help.
- Other args (e.g. `-d`, `--build`)  
  Passed through to `docker compose up`.

---

## Examples

```bash
# Start base services (app + proxy)
./start.sh

# Start base services with dev overrides
./start.sh dev

# Start with redis extra service in detached mode
./start.sh --with redis -d

# Start with multiple extras and build images
./start.sh dev --with redis,pgadmin --build
```