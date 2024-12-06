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
    job_salary_min.nil? && job_salary_max.nil? || job_salary_currency_id.nil? || job_salary_interval_id.nil? || job_salary_single.nil?
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

    private

    def update_existing_job(existing_job, job_post_data, locations, company)
      ai_updated = update_salary_and_location_with_ai(existing_job, job_post_data, locations)

      unless ai_updated
        existing_job.update!(job_post_data)
        update_job_locations(existing_job, locations)
      end

      # existing_job.extract_and_save_salary
      # existing_job.extract_and_save_job_description

      puts "#{ORANGE}Updated job post for URL: #{existing_job.job_url}#{RESET}"
    rescue StandardError => e
      log_job_error(existing_job, company, e.message)
    end

    def create_new_job(company, job_post_data, job_url, locations)
      new_job_post = new(job_post_data)

      if new_job_post.save
        ai_updated = update_salary_and_location_with_ai(new_job_post, job_post_data, locations)
        puts "AI updated: #{ai_updated}"

        unless ai_updated
          update_job_locations(new_job_post, locations)
        end

        # new_job_post.extract_and_save_salary
        # new_job_post.extract_and_save_job_description

        puts "#{GREEN}#{company.company_name} job post added#{RESET}"
      else
        log_job_error(new_job_post, company, new_job_post.errors.full_messages.join(', '))
      end
    end

    def update_salary_and_location_with_ai(job_post, job_post_data, locations)
      ai_salary_updated = JobPostService.extract_and_save_salary(job_post)
      # ai_location_updated = JobPostService.update_location_with_ai(job_post, locations)

      # ai_salary_updated || ai_location_updated
    end

    def update_job_locations(job_post, locations)
      return unless locations

      if locations[:country_name]
        country = Country.find_by(country_name: locations[:country_name]) ||
                  Country.find_by(country_code: locations[:country_code])
        job_post.countries = [country].compact if country
      end

      if locations[:state_name] || locations[:state_code]
        state = State.find_by(state_name: locations[:state_name]) ||
                State.find_by(state_code: locations[:state_code])
        job_post.states = [state].compact if state
      end

      if locations[:city_name]
        city = City.find_by(city_name: locations[:city_name])
        job_post.cities = [city].compact if city
      end
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
