class CreateJobCommitments < ActiveRecord::Migration[7.1]
  def change
    create_table :job_commitments do |t|
      t.string :commitment

      t.timestamps
    end
    add_index :job_commitments, :commitment, unique: true
  end
end
