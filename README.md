# EvenFlow
Three Rails APIs for event bookings and asynchronous notifications.

## Services
- Events: GraphQL on port 3001. Owns event data.
- Bookings: REST on port 3002. Validates Events over HTTP and saves a booking plus an outbox record.
- Notifications: REST on port 3003. A separate Karafka process consumes booking.created.

## Development
Ruby 4.0.7 with rbenv, Rails 8.1.4 and Bundler 4.0.22.
One Git repository, three apps and a Gemfile.lock per app.
Follow the workbook: Prepasos, Setup, Events, Bookings, Notifications, Integracion.
Setup creates all three app skeletons and prepares PostgreSQL and Kafka.

Each service is implemented and tested separately, then integrated.

From the repository root, copy .env.example to .env and start infrastructure:

```sh
docker compose up --wait --wait-timeout 180
docker compose exec kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic booking.created --partitions 1 --replication-factor 1
```

In each new terminal, from the root:

```sh
set -a
source .env
set +a
```

Inside each app: bundle _4.0.22_ install and bin/rails db:prepare.
Inside Events only: bin/rails db:seed.
Start each API from its folder with bin/rails server -p 3001, 3002 or 3003.
Inside Notifications, in another terminal: bundle _4.0.22_ exec karafka server.
The publisher is manual: run bin/rails outbox:publish inside Bookings.

## Tests
From the root: ./scripts/test.sh runs the three isolated RSpec suites.
With all APIs and the consumer running: ./scripts/smoke.sh checks real HTTP and Kafka.

CI runs one PostgreSQL-backed RSpec job per service. It does not run the Kafka smoke test.

## Contracts
See docs/contracts.md for inputs, outputs and the booking.created v1 message.
A new booking returns 201 queued. Replays return 200; changed payloads return 409.
Booking and outbox are stored in one transaction. Delivery is at least once.
Notifications deduplicates message_id. The notification is a database record, not a sent email.

## Scope
Local development. No authentication, payment or seat-capacity reservation.
CRM/ERP adapters are an optional exercise with simulated endpoints.
See docs/architecture.md and docs/decisions.md for guarantees and limits.
