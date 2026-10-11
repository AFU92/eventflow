#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
command -v rbenv >/dev/null 2>&1 || { printf 'rbenv missing from PATH.\n' >&2; exit 1; }
export RBENV_VERSION=4.0.7
set -a
source .env
set +a

# Cada subshell ejecuta una app sin cambiar la carpeta de las demas.
for service in events_api bookings_api notifications_api; do
  (
    cd "services/$service"
    rbenv exec bundle _4.0.22_ check
    rbenv exec bundle _4.0.22_ exec ruby ../../scripts/versions.rb
    RAILS_ENV=test rbenv exec bundle _4.0.22_ exec rails db:prepare
    rbenv exec bundle _4.0.22_ exec rails zeitwerk:check
    rbenv exec bundle _4.0.22_ exec rspec --format documentation
  )
done
