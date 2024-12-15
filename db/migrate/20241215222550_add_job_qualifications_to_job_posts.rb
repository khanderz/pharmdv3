# frozen_string_literal: true

class AddJobQualificationsToJobPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :job_posts, :job_qualifications, :json
  end
end
