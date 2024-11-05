# frozen_string_literal: true

class CreateJobPostStates < ActiveRecord::Migration[7.1]
  def change
    create_table :job_post_states do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :state, null: false, foreign_key: true

      t.timestamps
    end
  end
end
