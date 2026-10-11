# Architecture decisions
One monorepo, three independently running Rails applications and six local databases
(development and test per service). No foreign keys across services.
Events exposes a typed GraphQL schema. Bookings uses REST and queries Events over HTTP.
Booking and its outbox event commit atomically in the Bookings database.
A publisher sends pending rows to booking.created and marks published_at after acknowledgement.
The Kafka key is booking_id. One partition is enough for this demonstration.
Notifications consumes at least once and uses a UNIQUE message_id to deduplicate DB writes.
Network acknowledgement is not atomic with the outbox update, so redelivery is expected.
The publisher holds a row lock during network I/O: simple for the demo, inefficient at scale.
Notification deduplication does not guarantee exactly-once remote CRM/ERP side effects.
For external integrations, track per-destination delivery and use upstream idempotency keys.
Kafka invalid messages currently retry and can block a partition: implement validation + DLQ next.
GraphQL validates existence, status and date only. Capacity reservations need an atomic owner.
