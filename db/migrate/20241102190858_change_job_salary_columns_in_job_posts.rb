# frozen_string_literal: true

class ChangeJobSalaryColumnsInJobPosts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :job_posts, :job_salary_currency_id, true
    change_column_null :job_posts, :job_salary_interval_id, true
  end
end
