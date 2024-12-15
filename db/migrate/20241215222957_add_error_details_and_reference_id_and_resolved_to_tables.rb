# frozen_string_literal: true

class AddErrorDetailsAndReferenceIdAndResolvedToTables < ActiveRecord::Migration[7.1]
  def change
    %i[
      job_seniorities
      benefits
      skills
      credentials
      educations
      experiences
    ].each do |table|
      add_column table, :error_details, :text
      add_column table, :reference_id, :bigint
      add_column table, :resolved, :boolean, default: false
    end
  end
end
