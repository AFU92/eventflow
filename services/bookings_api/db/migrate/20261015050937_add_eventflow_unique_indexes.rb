class AddEventflowUniqueIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :bookings, :idempotency_key, unique: true
    add_index :outbox_events, :message_id, unique: true
    add_index :outbox_events, :published_at
  end
end
