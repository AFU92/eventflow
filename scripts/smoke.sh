#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
command -v rbenv >/dev/null 2>&1 || { printf "rbenv no esta en PATH.\n" >&2; exit 1; }
export RBENV_VERSION=4.0.7
set -a
source .env
set +a

curl -fsS "$EVENTS_URL" -H 'Content-Type: application/json' \
  -d '{"query":"{ event(id:\"1\"){ id status startsAt } }"}'
smoke_key="smoke-$(rbenv exec ruby -rsecurerandom -e 'print SecureRandom.uuid')"
smoke_response=$(curl -fsS http://127.0.0.1:3002/api/bookings \
  -H 'Content-Type: application/json' -H "Idempotency-Key: $smoke_key" \
  -d '{"event_id":1,"quantity":2,"attendee_email":"smoke@example.com"}')
smoke_id=$(printf '%s' "$smoke_response" | rbenv exec ruby -rjson -e 'print JSON.parse(STDIN.read).fetch("id")')
(cd services/bookings_api && rbenv exec bundle _4.0.22_ exec rails outbox:publish)

for attempt in {1..20}; do
  smoke_result=$(curl -fsS "http://127.0.0.1:3003/api/notifications?booking_id=$smoke_id")
  # Exige una sola notificacion para la reserva. exit 0 significa exito.
  if printf '%s' "$smoke_result" | rbenv exec ruby -rjson -e 'exit(JSON.parse(STDIN.read).length == 1 ? 0 : 1)'; then
    printf 'Booking %s has one notification.\n' "$smoke_id"
    exit 0
  fi
  # Pausa corta para permitir que el consumer procese el mensaje.
  sleep 1
done

printf 'Notification not observed for booking %s. Inspect consumer logs.\n' "$smoke_id" >&2
exit 1
