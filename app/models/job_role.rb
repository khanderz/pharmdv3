# frozen_string_literal: true

class JobRole < ApplicationRecord
  has_and_belongs_to_many :departments, join_table: :job_roles_departments
  has_and_belongs_to_many :teams, join_table: :job_roles_teams

  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :role_name, presence: true, uniqueness: true

  def self.find_or_create_job_role(job_title, job_post_url)
    titles = Utils::TitleCleaner.clean_title(job_title)
    # puts " titles #{titles}"
    cleaned_title = titles[:cleaned_title]
    modified_title = titles[:modified_title]

    job_role = JobRole.find_by('LOWER(role_name) = ?', cleaned_title.downcase)

    job_role = JobRole.find_by('LOWER(role_name) = ?', modified_title.downcase) if job_role.nil?

    if job_role.nil?
      job_role = JobRole.where('LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                               cleaned_title.downcase).first
      job_role ||= JobRole.where('LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                                 modified_title.downcase).first
    end

    if job_role.nil?
      job_role = JobRole.create!(
        role_name: cleaned_title,
        error_details: "Job Role: #{cleaned_title} not found in existing records",
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: 'JobRole',
        adjudicatable_id: job_role.id,
        error_details: "Job Role: #{cleaned_title} for #{job_post_url} not found in existing records"
      )

    end

    puts "Job Role: #{job_role.role_name} found."
    job_role
  end
end
