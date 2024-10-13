class AddJobRoleToJobPosts < ActiveRecord::Migration[7.1]
  def change
    add_reference :job_posts, :job_role, null: false, foreign_key: true
  end
end
