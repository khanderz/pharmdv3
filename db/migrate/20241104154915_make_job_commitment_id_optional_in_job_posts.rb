class MakeJobCommitmentIdOptionalInJobPosts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :job_posts, :job_commitment_id, true
  end
end
