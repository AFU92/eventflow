require "uri"
class Booking < ApplicationRecord
  validates :event_id, :idempotency_key, presence: true
  validates :quantity, inclusion: { in: 1..4 }
  validates :attendee_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :status, inclusion: { in: %w[queued] }
end
