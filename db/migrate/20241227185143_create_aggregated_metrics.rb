class CreateAggregatedMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :aggregated_metrics do |t|
      t.string :metric_type
      t.string :reference_type
      t.bigint :reference_id
      t.integer :value
      t.datetime :last_updated

      t.timestamps
    end
  end
end
