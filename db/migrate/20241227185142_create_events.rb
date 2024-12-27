class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :event_type
      t.references :user, null: false, foreign_key: true
      t.string :reference_type
      t.bigint :reference_id
      t.json :metadata
      t.datetime :recorded_at

      t.timestamps
    end
    add_index :events, :recorded_at
  end
end
