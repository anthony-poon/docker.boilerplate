#!/usr/bin/env sh
set -e

# Project name = current folder name, sanitize invalid chars to "-"
PROJECT_NAME=$(basename "$PWD" | sed 's/[^a-zA-Z0-9_-]/-/g')

# Parse args
EXTRA_ARGS=""
USE_DEV=false
RUN_REBUILD=FALSE
PROFILES=""

print_help() {
  cat <<EOF
Usage: $(basename "$0") [options]

Options:
  start [dev]         Start services (with dev override if specified).
  --with <profiles>   Comma-separated list of profiles to enable.
                      Example: --with redis,pgadmin
  -h, --help          Show this help message.

Other arguments are forwarded to "docker compose up".

Examples:
  $(basename "$0")
        -> docker compose up with default services.

    $(basename "$0") start dev --with redis -d
        -> docker compose up with redis using development mode, and run detached.

    $(basename "$0") --with redis,pgadmin --build
        -> docker compose up with redis and pgadmin, build images before start.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      print_help
      exit 0
      ;;
    --with)
      shift
      if [ -n "$1" ]; then
        # support comma-separated lists
        for profile in $(echo "$1" | tr ',' ' '); do
          PROFILES="$PROFILES --profile $profile"
        done
        shift
      fi
      ;;
    --rebuild)
      shift
      RUN_REBUILD=true
      ;;
    *)
      if [ "${1:-}" = "dev" ]; then
        USE_DEV=true
      else
        EXTRA_ARGS="$EXTRA_ARGS $1"
      fi
      shift
      ;;
  esac
done


FILES="-f docker-compose.yml"

# Add dev compose file if requested
if [ "$USE_DEV" = true ]; then
  FILES="$FILES -f docker-compose.dev.yml"
fi

# If already running, bring it down
if docker compose -p "$PROJECT_NAME" ps --status running | grep -q 'Up'; then
  echo "[$PROJECT_NAME] already running, stopping..."
  docker compose down $FILES
fi

if [ "$RUN_REBUILD" = true ]; then
  docker compose $FILES build --no-cache
fi
exec docker compose -p $PROJECT_NAME $FILES $PROFILES up --remove-orphans $EXTRA_ARGS