# frozen_string_literal: true

class CreateMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :metrics do |t|
      t.string :metric_type
      t.string :reference_type
      t.bigint :reference_id
      t.integer :value
      t.datetime :recorded_at

      t.timestamps
    end
    add_index :metrics, :recorded_at
  end
end
