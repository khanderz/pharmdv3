# frozen_string_literal: true

GREEN = "\033[32m"
BLUE = "\033[34m"
RESET = "\033[0m"
ORANGE = "\033[38;2;255;165;0m"
RED = "\033[31m"

class JobPost < ApplicationRecord
  has_paper_trail

  has_many :adjudications, as: :adjudicatable, dependent: :destroy
  has_many :job_post_benefits, dependent: :destroy
  has_many :job_post_locations, dependent: :destroy
  has_many :job_post_credentials, dependent: :destroy
  has_many :job_post_educations, dependent: :destroy
  has_many :job_post_experiences, dependent: :destroy
  has_many :job_post_seniorities, dependent: :destroy
  has_many :job_post_skills, dependent: :destroy

  has_many :benefits, through: :job_post_benefits
  has_many :locations, through: :job_post_locations
  has_many :credentials, through: :job_post_credentials
  has_many :educations, through: :job_post_educations
  has_many :experiences, through: :job_post_experiences
  has_many :seniorities, through: :job_post_seniorities
  has_many :skills, through: :job_post_skills

  belongs_to :job_commitment, optional: true
  belongs_to :department
  belongs_to :team, optional: true
  belongs_to :company
  belongs_to :job_role
  belongs_to :job_salary_currency, optional: true
  belongs_to :job_salary_interval, optional: true

  validates :job_title, presence: true
  validates :job_url, uniqueness: true
  validates :job_salary_min, :job_salary_max, numericality: { greater_than_or_equal_to: 0 },
                                              allow_nil: true

  scope :active, -> { where(job_active: true) }
  scope :inactive, -> { where(job_active: false) }
  scope :by_location, lambda { |location_id|
    joins(:job_post_locations).where(job_post_locations: { location_id: location_id })
  }

  #  Instance Methods
  def jobs_by_location
    locations.pluck(:location_name).join(', ')
  end

  def self.parse_datetime(datetime)
    DateTime.parse(datetime).strftime('%Y-%m-%d') if datetime
  end

  # Class Methods
  class << self
    def fetch_and_save_jobs(company)
      jobs = JobFetcher.fetch(company)
      return unless jobs

      active_job_ids = jobs.map do |job|
        title = job['title'] || job['text']

        job_title = title&.strip&.downcase

        puts "job title: #{job_title}"

        skip_phrases = ['future opportunity', 'general application', 'general interest',
                        'General Interest: Join Our Talent Community', 'submit your resume', "Don't see a", 'that interests you', 'apply here']

        if skip_phrases.any? { |phrase| job_title.include?(phrase.downcase) }
          puts "#{ORANGE}Skipping job post with title: '#{job_title}' for #{company}#{RESET}"
          return
        end

        process_job(
          company,
          JobDataMapper.url(company, job),
          JobDataMapper.map(company, job)
        )
      end.compact

      deactivate_old_jobs(company, active_job_ids)
    end

    def deactivate_old_jobs(company, active_job_ids)
      deactivated_count = where(company: company).where.not(id: active_job_ids).update_all(job_active: false)
      puts "#{BLUE}Deactivated #{deactivated_count} old job posts for #{company.company_name}#{RESET}"
    end

    def process_job(company, job_url, job_post_data)
      puts "#{GREEN}Processing job post for #{company.company_name}#{RESET}"
      existing_job = find_by(job_url: job_url)

      if existing_job
        puts '-------------existing job post'
        update_existing_job(existing_job, job_post_data, company)
      else
        puts '-------------new job post'
        create_new_job(company, job_post_data)
      end
    end

    private

    def update_existing_job(existing_job, job_post_data, company)
      job_post_data_object = job_post_data[:job_post_data]
      benefits = job_post_data[:job_post_benefits]
      locations = job_post_data[:job_post_locations]
      credentials = job_post_data[:job_post_credentials]
      educations = job_post_data[:job_post_educations]
      experiences = job_post_data[:job_post_experiences]
      seniorities = job_post_data[:job_post_seniorities]
      skills = job_post_data[:job_post_skills]

      puts "job post data at job post model: #{job_post_data}"
      existing_job.update!(job_post_data_object)

      begin
        update_join_table(existing_job, benefits, :job_post_benefits, :benefit_id, 'Benefits')
        update_join_table(existing_job, locations, :job_post_locations, :location_id, 'Locations')
        update_join_table(existing_job, credentials, :job_post_credentials, :credential_id,
                          'Credentials')
        update_join_table(existing_job, educations, :job_post_educations, :education_id,
                          'Educations')
        update_join_table(existing_job, experiences, :job_post_experiences, :experience_id,
                          'Experiences')
        update_join_table(existing_job, seniorities, :job_post_seniorities, :job_seniority_id,
                          'Seniorities')
        update_join_table(existing_job, skills, :job_post_skills, :skill_id, 'Skills')

        puts "#{ORANGE}Updated job post for URL: #{existing_job.job_url}#{RESET}"
      rescue StandardError => e
        log_job_error(existing_job, company, e.message)
      end
    end

    def update_join_table(job_post, new_values, join_table_name, foreign_key, label)
      existing_records = job_post.send(join_table_name).pluck(foreign_key)

      new_values ||= []
      new_values_to_add = new_values - existing_records
      stale_values_to_remove = existing_records - new_values

      new_values_to_add.each do |value|
        job_post.send(join_table_name).create!(foreign_key => value)
      end

      stale_values_to_remove.each do |value|
        job_post.send(join_table_name).find_by(foreign_key => value).destroy
      end

      unless new_values_to_add.empty?
        puts "#{GREEN}Added #{label}: #{new_values_to_add.join(', ')}#{RESET}"
      end

      return if stale_values_to_remove.empty?

      puts "#{RED}Removed #{label}: #{stale_values_to_remove.join(', ')}#{RESET}"
    end

    def create_new_job(company, job_post_data)
      puts "job post data at job post model: #{job_post_data}"

      job_post_data_object = job_post_data[:job_post_data]
      benefits = job_post_data[:job_post_benefits]
      locations = job_post_data[:job_post_locations]
      credentials = job_post_data[:job_post_credentials]
      educations = job_post_data[:job_post_educations]
      experiences = job_post_data[:job_post_experiences]
      seniorities = job_post_data[:job_post_seniorities]
      skills = job_post_data[:job_post_skills]

      job_post = JobPost.new(job_post_data_object)

      begin
        if job_post.save
          puts "#{GREEN}#{company.company_name} job post added#{RESET}"

          benefits&.each do |benefit_id|
            JobPostBenefit.create!(job_post_id: job_post.id, benefit_id: benefit_id) if benefit_id
          end

          locations&.each do |location_id|
            if location_id
              JobPostLocation.create!(job_post_id: job_post.id,
                                      location_id: location_id)
            end
          end

          credentials&.each do |credential_id|
            if credential_id
              JobPostCredential.create!(job_post_id: job_post.id,
                                        credential_id: credential_id)
            end
          end

          educations&.each do |education_id|
            if education_id
              JobPostEducation.create!(job_post_id: job_post.id,
                                       education_id: education_id)
            end
          end

          experiences&.each do |experience_id|
            if experience_id
              JobPostExperience.create!(job_post_id: job_post.id,
                                        experience_id: experience_id)
            end
          end

          seniorities&.each do |seniority_id|
            if seniority_id
              JobPostSeniority.create!(job_post_id: job_post.id,
                                       job_seniority_id: seniority_id)
            end
          end

          # skills&.each do |skill_name|
          #   skill = Skill.find_or_create_skill(skill_name, job_post)
          #   JobPostSkill.create!(job_post_id: job_post.id, skill_id: skill.id) if skill
          # end

        else
          log_job_error(job_post, company, job_post.errors.full_messages.join(', '), job_post)
        end
      rescue ActiveRecord::RecordInvalid => e
        puts "#{RED}Error saving new job post: #{e.message}#{RESET}"
        puts e.backtrace
        log_job_error(job_post, company, "Validation failed: #{e.message}", job_post)
      rescue StandardError => e
        puts "#{RED}Unexpected error: #{e.message}#{RESET}"
        puts e.backtrace
        log_job_error(job_post, company, "Unexpected error: #{e.message}", job_post)
      end
    end

    def log_job_error(job_post, company, error_message, job_post_instance = nil)
      if job_post_instance.nil?
        Adjudication.log_error(
          adjudicatable_type: 'JobPost',
          adjudicatable_id: job_post.id,
          error_details: error_message
        )
      else
        job_post_instance = JobPost.create!(job_post.attributes)

        puts "#{GREEN}New job post created for #{company.company_name}.#{RESET}"

        Adjudication.log_error(
          adjudicatable_type: 'JobPost',
          adjudicatable_id: job_post_instance.id,
          error_details: error_message
        )
      end
    end
  end
end
