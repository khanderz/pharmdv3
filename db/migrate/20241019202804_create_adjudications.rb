class CreateAdjudications < ActiveRecord::Migration[7.1]
  def change
    create_table :adjudications do |t|
      t.references :adjudicatable, polymorphic: true, null: false
      t.text :error_details
      t.boolean :resolved

      t.timestamps
    end
  end
end
