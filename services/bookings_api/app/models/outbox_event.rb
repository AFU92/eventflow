class OutboxEvent < ApplicationRecord
  scope :pending, -> { where(published_at: nil) }
  validates :message_id, :topic, :payload, presence: true
end
