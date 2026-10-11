# EvenFlow contracts

## Events
POST /graphql on port 3001. Bookings calls event(id: ID!).
Response fields: id, status, startsAt. Query events(limit: Int) lists at most 50.
IDs are serialized as GraphQL strings. Missing events return data.event = null.
GraphQL errors can be returned with HTTP 200.

## Bookings
POST /api/bookings on port 3002. Header: Idempotency-Key (1-200 characters).
Body: {"event_id":1,"attendee_email":"ana@example.com","quantity":2}.
quantity is an integer from 1 to 4. The event must be published and in the future.
201: new booking. 200: same key and normalized payload. 409: changed payload.
422: invalid input. 503: Events unavailable or its response invalid.
GET /api/bookings/:id returns a saved booking; unknown IDs return 404.
The POST returns queued after booking and outbox commit, before Kafka delivery.

## booking.created v1
Producer: Bookings outbox publisher. Consumer: Notifications Karafka process.
Topic: booking.created. Message key: booking_id as a string.
JSON: version=1, message_id (UUID), booking_id, event_id, attendee_email,
quantity, correlation_id and occurred_at (ISO 8601).
Delivery is at least once. A replay retains the same message_id.
OutboxEvent.message_id is UUID; Notification deduplicates it with a unique index.

## Notifications
GET /api/notifications?booking_id=1 on port 3003 returns at most 50 records.
The Kafka consumer creates a notification record. No email is sent.
The GET reads that service's database; it does not start the consumer.
