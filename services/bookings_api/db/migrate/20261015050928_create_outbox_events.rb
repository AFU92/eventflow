class CreateOutboxEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :outbox_events do |t|
      t.string :message_id
      t.string :topic
      t.jsonb :payload
      t.datetime :published_at

      t.timestamps
    end
  end
end
