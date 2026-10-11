# EvenFlow decisions

## Repository
Create all app skeletons in Setup, then implement one service per branch.
One Git history coordinates contract changes. Each app has its own process,
Gemfile.lock and database. --skip-git avoids nested repositories.

## Environment
.ruby-version selects Ruby 4.0.7 through rbenv; ruby-build installs it.
Each Gemfile pins Rails 8.1.4. Gemfile.lock records dependencies and Bundler 4.0.22.
The scripts select Ruby explicitly using rbenv exec.

## Boundaries
Events owns events. Bookings validates them over GraphQL/HTTP.
Cross-service IDs are references, not database foreign keys.
Validation does not reserve seats or prevent overselling.

## Idempotency and outbox
UNIQUE(idempotency_key) protects concurrent POSTs.
The same normalized payload replays the saved booking; changed payloads conflict.
Booking and OutboxEvent commit together. The POST does not wait for Kafka.
The manual publisher marks published_at only after acknowledgement.
If it crashes before marking, it sends the same message_id again: at-least-once.
The row lock is simple but holds a database connection during network I/O.

## Consumer
UNIQUE(message_id) plus create_or_find_by! deduplicates notification records.
Consumer offsets resume the group. earliest applies when no valid offset exists.
Invalid messages currently retry; bounded retry and quarantine are future work.
A deduplicated database row does not guarantee a single external email or payment.

## Tests
RSpec checks domain rules, HTTP contracts, unique indexes and transaction rollback.
WebMock and Kafka stubs keep service suites independent.
The integration exercises use real APIs, PostgreSQL, Kafka and the consumer.
CI checks each app separately. Keep the command output and commit SHA as evidence.
