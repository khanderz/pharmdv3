
# frozen_string_literal: true
class JobRole < ApplicationRecord
    has_and_belongs_to_many :departments, join_table: :job_roles_departments
    has_and_belongs_to_many :teams, join_table: :job_roles_teams

    has_many :job_posts
    has_many :adjudications, as: :adjudicatable, dependent: :destroy

    validates :role_name, presence: true, uniqueness: true

    def self.find_or_create_job_role(job_title)
      cleaned_job_title = Utils::TitleCleaner.clean_title(job_title)

      job_role = JobRole.find_by('LOWER(role_name) = ?', cleaned_job_title.downcase)

      # If job role is not found, search by aliases
      if job_role.nil?
        job_role = JobRole.where('LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                                 cleaned_job_title.downcase).first
      end

      if job_role.nil?
        job_role = JobRole.create!(
          role_name: cleaned_job_title,
          error_details: "Job Role: #{cleaned_job_title} not found in existing records",
          resolved: false
        )
        Adjudication.create!(
          adjudicatable_type: 'JobRole',
          adjudicatable_id: job_role.id,
          error_details: "Job Role: #{cleaned_job_title} not found in existing records",
          resolved: false
        )
        puts "Adjudication created for new job role: #{cleaned_job_title}."
      end
    end
  end
  