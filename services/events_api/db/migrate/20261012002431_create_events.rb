class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_at
      t.string :status

      t.timestamps
    end
  end
end
