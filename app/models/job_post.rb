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

  has_many :benefits, through: :job_post_benefits, optional: true
  has_many :cities, through: :job_post_cities, optional: true
  has_many :countries, through: :job_post_countries
  has_many :credentials, through: :job_post_credentials, optional: true
  has_many :educations, through: :job_post_educations, optional: true
  has_many :experiences, through: :job_post_experiences, optional: true
  has_many :seniorities, through: :job_post_seniorities, optional: true
  has_many :skills, through: :job_post_skills, optional: true
  has_many :states, through: :job_post_states, optional: true

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
      puts "#{GREEN}Processing job post for #{company.company_name}#{RESET}"
      # puts "Job URL: #{job_url}"
      # puts "Job Post Data: #{job_post_data}"
      existing_job = find_by(job_url: job_url)

      if existing_job
        puts '-------------existing job post'
        update_existing_job(existing_job, job_post_data, company)
      else
        puts '-------------new job post'

        create_new_job(company, job_post_data, job_url)
      end
    end

    private

    def update_existing_job(existing_job, job_post_data, company)
      existing_job.update!(job_post_data)

      puts "#{ORANGE}Updated job post for URL: #{existing_job.job_url}#{RESET}"
    rescue StandardError => e
      log_job_error(existing_job, company, e.message)
    end

    def create_new_job(company, job_post_data, _job_url)
      puts "job post data at job post model: #{job_post_data}"

      job_post_data_object = job_post_data[:job_post_data]
      benefits = job_post_data[:job_post_benefits]
      cities = job_post_data[:job_post_cities]
      countries = job_post_data[:job_post_countries]
      credentials = job_post_data[:job_post_credentials]
      educations = job_post_data[:job_post_educations]
      experiences = job_post_data[:job_post_experiences]
      seniorities = job_post_data[:job_post_seniorities]
      skills = job_post_data[:job_post_skills]
      states = job_post_data[:job_post_states]

      job_post = JobPost.new(job_post_data_object)

      begin
        if job_post.save
          puts "#{GREEN}#{company.company_name} job post added#{RESET}"

          benefits&.each do |benefit_name|
            benefit = Benefit.find_or_create_benefit(benefit_name, company, job_post)
            JobPostBenefit.create!(job_post_id: job_post.id, benefit_id: benefit.id) if benefit
          end

          cities&.each do |city_name|
            city = City.find_or_create_city(city_name, company, job_post)
            JobPostCity.create!(job_post_id: job_post.id, city_id: city.id) if city
          end

          countries&.each do |country_name|
            country = Country.find_or_adjudicate_country(nil, country_name, company,
                                                         job_post.job_url)
            JobPostCountry.create!(job_post_id: job_post.id, country_id: country.id) if country
          end

          credentials&.each do |credential_name|
            credential = Credential.find_or_create_credential(credential_name, job_post)
            if credential
              JobPostCredential.create!(job_post_id: job_post.id,
                                        credential_id: credential.id)
            end
          end

          educations&.each do |education_name|
            education = Education.find_or_create_education(education_name, job_post)
            if education
              JobPostEducation.create!(job_post_id: job_post.id,
                                       education_id: education.id)
            end
          end

          experiences&.each do |experience_name|
            experience = Experience.find_or_create_experience(experience_name, job_post)
            if experience
              JobPostExperience.create!(job_post_id: job_post.id,
                                        experience_id: experience.id)
            end
          end

          seniorities&.each do |seniority_name|
            seniority = JobSeniority.find_or_create_seniority(seniority_name, job_post)
            if seniority
              JobPostSeniority.create!(job_post_id: job_post.id,
                                       job_seniority_id: seniority.id)
            end
          end

          skills&.each do |skill_name|
            skill = Skill.find_or_create_skill(skill_name, job_post)
            JobPostSkill.create!(job_post_id: job_post.id, skill_id: skill.id) if skill
          end

          states&.each do |state_name|
            state = State.find_or_create_state(state_name, company, job_post)
            JobPostState.create!(job_post_id: job_post.id, state_id: state.id) if state
          end

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
