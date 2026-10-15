class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.bigint :event_id
      t.string :attendee_email
      t.integer :quantity
      t.string :idempotency_key
      t.string :status

      t.timestamps
    end
  end
end
