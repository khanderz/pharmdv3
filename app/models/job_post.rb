# frozen_string_literal: true

RED = "\033[31m"
GREEN = "\033[32m"
BLUE = "\033[34m"
RESET = "\033[0m"
ORANGE = "\033[38;2;255;165;0m"

class JobPost < ApplicationRecord
  has_paper_trail

  has_many :adjudications, as: :adjudicatable, dependent: :destroy
  has_many :job_post_benefits, dependent: :destroy
  has_many :job_post_cities, dependent: :destroy
  has_many :job_post_countries, dependent: :destroy
  has_many :job_post_credentials, dependent: :destroy
  has_many :job_post_educations, dependent: :destroy
  has_many :job_post_experiences, dependent: :destroy
  has_many :job_post_seniorities, dependent: :destroy
  has_many :job_post_skills, dependent: :destroy
  has_many :job_post_states, dependent: :destroy

  has_many :benefits, through: :job_post_benefits
  has_many :cities, through: :job_post_cities
  has_many :countries, through: :job_post_countries
  has_many :credentials, through: :job_post_credentials
  has_many :educations, through: :job_post_educations
  has_many :experiences, through: :job_post_experiences
  has_many :seniorities, through: :job_post_seniorities
  has_many :skills, through: :job_post_skills
  has_many :states, through: :job_post_states

  belongs_to :job_commitment, optional: true
  belongs_to :department
  belongs_to :team
  belongs_to :company
  belongs_to :job_role
  belongs_to :job_salary_currency, optional: true
  belongs_to :job_salary_interval, optional: true

  validates :job_title, presence: true
  validates :job_url, uniqueness: true
  validates :job_salary_min, :job_salary_max, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :active, -> { where(job_active: true) }
  scope :inactive, -> { where(job_active: false) }

  # Instance Methods
  def extract_and_save_salary
    JobPostService.extract_and_save_salary(self)
  end

  def extract_and_save_job_description
    JobPostService.extract_and_save_job_description(self)
  end

  def salary_needs_extraction?
    job_salary_min.nil? && job_salary_max.nil?
  end

  # Class Methods
  class << self
    def fetch_and_save_jobs(company)
      jobs = JobFetcher.fetch(company)
      return unless jobs

      active_job_ids = jobs.map do |job|
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
      existing_job = find_by(job_url: job_url)
      locations = job_post_data.delete(:job_locations)

      if existing_job
        update_existing_job(existing_job, job_post_data, locations, company)
      else
        create_new_job(company, job_post_data, job_url, locations)
      end
    end

    def update_job_associations(job_post, associations)
      update_job_locations(job_post, associations[:locations])
      update_job_skills(job_post, associations[:skills])
      update_job_seniorities(job_post, associations[:seniorities])
      update_job_credentials(job_post, associations[:credentials])
      update_job_educations(job_post, associations[:educations])
      update_job_experiences(job_post, associations[:experiences])
    end

    private

    def update_existing_job(existing_job, job_post_data, locations, company)
      if job_data_unchanged?(existing_job, job_post_data)
        puts "#{BLUE}Job post unchanged for URL: #{existing_job.job_url}#{RESET}"
      else
        existing_job.update!(job_post_data)
        update_job_locations(existing_job, locations)
        existing_job.extract_and_save_salary
        existing_job.extract_and_save_job_description
        puts "#{ORANGE}Updated job post for URL: #{existing_job.job_url}#{RESET}"
      end
    rescue StandardError => e
      log_job_error(existing_job, company, e.message)
    end

    def create_new_job(company, job_post_data, job_url, locations)
      new_job_post = new(job_post_data)

      if new_job_post.save
        puts "#{GREEN}#{company.company_name} job post added#{RESET}"
        update_job_locations(new_job_post, locations)
        new_job_post.extract_and_save_salary
        new_job_post.extract_and_save_job_description
      else
        log_job_error(new_job_post, company, new_job_post.errors.full_messages.join(', '))
      end
    end

    def job_data_unchanged?(job, data)
      job.attributes.except('id', 'created_at', 'updated_at') == data
    end


    def update_job_locations(job_post, locations)
      return unless locations

      job_post.countries = Country.where(country_name: locations[:countries]) if locations[:countries]
      job_post.states = State.where(state_name: locations[:states]) if locations[:states]
      job_post.cities = City.where(city_name: locations[:cities]) if locations[:cities]
    end

    def update_job_skills(job_post, skills)
      return unless skills

      skill_records = skills.map do |skill_name|
        Skill.find_or_create_by(skill_name: skill_name)
      end
      job_post.skills = skill_records
    end

    def update_job_seniorities(job_post, seniorities)
      return unless seniorities

      seniority_records = seniorities.map do |seniority_code|
        JobSeniority.find_by(job_seniority_code: seniority_code) ||
          log_and_create_adjudication('JobSeniority', seniority_code, job_post)
      end.compact
      job_post.seniorities = seniority_records
    end

    def update_job_credentials(job_post, credentials)
      return unless credentials

      credential_records = credentials.map do |credential_code|
        Credential.find_by(credential_code: credential_code) ||
          log_and_create_adjudication('Credential', credential_code, job_post)
      end.compact
      job_post.credentials = credential_records
    end

    def update_job_educations(job_post, educations)
      return unless educations

      education_records = educations.map do |education_code|
        Education.find_by(education_code: education_code) ||
          log_and_create_adjudication('Education', education_code, job_post)
      end.compact
      job_post.educations = education_records
    end

    def update_job_experiences(job_post, experiences)
      return unless experiences

      experience_records = experiences.map do |experience_code|
        Experience.find_by(experience_code: experience_code) ||
          log_and_create_adjudication('Experience', experience_code, job_post)
      end.compact
      job_post.experiences = experience_records
    end

    def log_job_error(job_post, company, error_message)
      Adjudication.create!(
        adjudicatable_type: 'JobPost',
        adjudicatable_id: job_post.id,
        error_details: error_message,
        resolved: false
      )
      puts "#{RED}Error for #{company.company_name} job post: #{error_message}#{RESET}"
    end
  end
end
