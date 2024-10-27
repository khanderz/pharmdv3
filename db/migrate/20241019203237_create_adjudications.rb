# frozen_string_literal: true

class CreateAdjudications < ActiveRecord::Migration[7.1]
  def change
    create_table :adjudications do |t|
      t.references :adjudicatable, polymorphic: true, index: true
      t.text :error_details
      t.boolean :resolved, default: false

      t.timestamps
    end
  end
end
