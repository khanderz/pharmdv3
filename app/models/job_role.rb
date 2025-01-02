# frozen_string_literal: true

class JobRole < ApplicationRecord
  has_many :job_roles_departments
  has_many :departments, through: :job_roles_departments

  has_many :job_roles_teams
  has_many :teams, through: :job_roles_teams

  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :role_name, presence: true, uniqueness: true

  KEYWORD_MAPPINGS = {
    'Account Manager' => ['account'],
    'Counsel' => ['legal'],
    'Laboratory Technician' => ['laboratory'],
    'Marketing Specialist' => ['marketing'],
    'Sales Representative' => ['sales'],
    'Scientist' => ['scientist']
  }.freeze

  def self.find_or_create_job_role(job_title)
    titles = Utils::TitleCleaner.clean_title(job_title)
    puts "#{BLUE}original title #{job_title}#{RESET}"
    puts "#{BLUE}titles #{titles}#{RESET}"
    cleaned_title = titles[:cleaned_title].presence || titles[:modified_title]
    modified_title = titles[:modified_title]

    KEYWORD_MAPPINGS.each do |mapped_role, keywords|
      next unless keywords.any? do |keyword|
        cleaned_title.include?(keyword) || modified_title.include?(keyword)
      end

      job_role = find_by(role_name: mapped_role)
      puts "#{ORANGE}Normalized name match to one of #{keywords}, matching job role to #{mapped_role}#{RESET}"
      return job_role if job_role
    end

    job_role = JobRole.find_by('LOWER(role_name) = ?', modified_title.downcase)
    job_role ||= JobRole.find_by('LOWER(role_name) = ?', cleaned_title.downcase)

    if job_role.nil?
      job_role = JobRole.where('LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                               cleaned_title.downcase).first
      job_role ||= JobRole.where('LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                                 modified_title.downcase).first
    end

    if job_role.nil?
      job_role = JobRole.create!(
        role_name: cleaned_title,
        error_details: "Job Role: #{titles} not found in existing records",
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: 'JobRole',
        adjudicatable_id: job_role.id,
        error_details: "Job Role: #{titles} for original role #{job_title} not found in existing records"
      )

    end

    puts "Job Role: #{job_role.role_name} found."
    job_role
  end
end
