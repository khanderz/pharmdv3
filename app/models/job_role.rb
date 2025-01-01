# frozen_string_literal: true

class JobRole < ApplicationRecord
  has_many :job_roles_departments
  has_many :departments, through: :job_roles_departments

  has_many :job_roles_teams
  has_many :teams, through: :job_roles_teams

  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :role_name, presence: true, uniqueness: true

  def self.find_or_create_job_role(job_title)
    titles = Utils::TitleCleaner.clean_title(job_title)
    puts "#{BLUE}original title #{job_title}#{RESET}"
    puts "#{BLUE}titles #{titles}#{RESET}"
    cleaned_title = titles[:cleaned_title].presence || titles[:modified_title]
    modified_title = titles[:modified_title]

    if cleaned_title.include?('account') || modified_title.include?('account')
      job_role = JobRole.find_by(role_name: 'Account Manager')
      puts "#{ORANGE}normalized name match to account, matching job role to Account Manager#{RESET}"
      return job_role if job_role
    end

    if cleaned_title.include?('legal') || modified_title.include?('legal')
      job_role = JobRole.find_by(role_name: 'Counsel')
      puts "#{ORANGE}normalized name match to legal, matching job role to Counsel#{RESET}"
      return job_role if job_role
    end

    if cleaned_title.include?('marketing') || modified_title.include?('marketing')
      job_role = JobRole.find_by(role_name: 'Marketing Specialist')
      puts "#{ORANGE}normalized name match to marketing, matching job role to Marketing Specialist#{RESET}"
      return job_role if job_role
    end

    if cleaned_title.include?('sales') || modified_title.include?('sales')
      job_role = JobRole.find_by(role_name: 'Sales Representative')
      puts "#{ORANGE}normalized name match to sales, matching job role to Sales Representative#{RESET}"
      return job_role if job_role
    end

    if cleaned_title.include?('laboratory') || modified_title.include?('laboratory')
      job_role = JobRole.find_by(role_name: 'Laboratory Technician')
      puts "#{ORANGE}normalized name match to laboratory, matching job role to Laboratory Technician#{RESET}"
      return job_role if job_role
    end

    # if cleaned_title.include?('scientist') || modified_title.include?('scientist')
    #   job_role = JobRole.find_by(role_name: 'Scientist')
    #   puts "#{ORANGE}normalized name match to scientist, matching job role to Scientist#{RESET}"
    #   return job_role if job_role
    # end

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
