class JobPost < ApplicationRecord
  has_paper_trail  
  has_many :adjudications, as: :adjudicatable, dependent: :destroy 

  belongs_to :job_commitment, optional: true
  belongs_to :job_setting
  belongs_to :country, optional: true
  belongs_to :department
  belongs_to :team
  belongs_to :company
  belongs_to :job_role
  belongs_to :job_salary_currency, optional: true
  belongs_to :job_salary_interval, optional: true

  validates :job_title, presence: true
  validates :job_url, uniqueness: true
  validates :job_salary_min, :job_salary_max, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Shared methods -----------------------------------------------------------
  # Deactivate old jobs that are no longer in the API data
  def self.deactivate_old_jobs(company, active_job_ids)
    deactivated_count = JobPost.where(company: company).where.not(id: active_job_ids).update_all(job_active: false)
    puts "Deactivated #{deactivated_count} old job posts for #{company.company_name}"
  end

  # Helper to handle creating or updating a job post
  def self.process_existing_or_new_job(company, job_url, job_post_data)
    existing_job = JobPost.find_by(job_url: job_url)

    if existing_job
      if existing_job.attributes.except('id', 'created_at', 'updated_at') == job_post_data
        puts "Job post already exists and is unchanged for URL: #{job_url}"
      else
        existing_job.update(job_post_data)
        puts "Updated job post for URL: #{job_url}"
      end
      return existing_job.id
    else
      # Create new job post
      new_job_post = JobPost.new(job_post_data)
      if new_job_post.save
        puts "#{company.company_name} job post added"
        return new_job_post.id
      else
        # Log errors to Adjudications table for manual review
        Adjudication.create!(
          adjudicatable_type: new_job_post,
          error_details: new_job_post.errors.full_messages.join(', '),
          resolved: false
        )
        puts "Error saving job post for #{company.company_name} - #{new_job_post.errors.full_messages.join(', ')}"
        return nil
      end
    end
  end

  # get job url
  def self.get_job_url(ats_code, job)
    case ats_code
    when 'LEVER'
      job['hostedUrl']
    when 'GREENHOUSE'
      job['absolute_url']
    end
  end

  private

#  fetch jobs from ATS APIs
  def self.fetch_jobs(company)
    jobs = get_jobs(company)
    ats_code = company.ats_type.ats_type_code

    if ats_code == 'LEVER'
      if jobs.present?
        active_job_ids = save_jobs(ats_code,company, jobs)
        deactivate_old_jobs(company, active_job_ids)
      end
    elsif ats_code == 'GREENHOUSE'
      if jobs && jobs["jobs"]
        jobs_mapped = jobs["jobs"].map { |job| job }
        active_job_ids = save_jobs(ats_code, company, jobs_mapped)
        deactivate_old_jobs(company, active_job_ids)
      else
        puts "No jobs found for #{company.company_name}"
      end
    else
      puts "ATS type #{ats_code} not supported for company: #{company.company_name}"
    end
  end

  # Get jobs from ATS APIs
  def self.get_jobs(company)
    if company.ats_type.ats_type_code == 'LEVER'
      company_name = company.company_name.gsub(' ', '').downcase
    url = "https://api.lever.co/v0/postings/#{company_name}"
    uri = URI(url)
  
    begin
      response = Net::HTTP.get(uri)
      jobs = JSON.parse(response)
  
      if jobs.is_a?(Array)
        return jobs
      else
        company.error_details = "failed to fetch Lever jobs"
        company.resolved = false
        company.save!
        
        Adjudication.create!(
          adjudicatable_type: 'Company',
          adjudicatable_id: company.id,
          error_details: "failed to fetch Lever jobs for #{company.company_name}",
          resolved: false
        )
        puts "Error: #{jobs['message']}, cannot get Lever jobs. Logged to adjudications."
        
        nil
      end
    rescue StandardError => e
      # Log the exception and create an adjudication for the failure
      error_message = "Exception occurred while fetching Lever jobs for #{company.company_name}: #{e.message}"
      puts error_message
  
      # Create an adjudication record
      Adjudication.create!(
        adjudicatable_type: 'Company',
        adjudicatable_id: company.id,
        error_details: error_message,
        resolved: false
      )
  
      nil
    end
    elsif company.ats_type.ats_type_code == 'GREENHOUSE'
      ats_id = company.ats_id
      url = "https://boards-api.greenhouse.io/v1/boards/#{ats_id}/jobs?content=true"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      jobs = JSON.parse(response)
  
      if jobs.is_a?(Hash)
        return jobs
      else
        company.error_details = "failed to fetch Greenhouse jobs"
        company.resolved = false
        company.save!
  
        Adjudication.create!(
          adjudicatable_type: 'Company',
          adjudicatable_id: company.id,
          error_details: "failed to fetch Greenhouse jobs for #{company.company_name}",
          resolved: false
        )
        puts "Error: #{jobs['message']}, cannot get Greenhouse jobs. Logged to adjudications."
  
        nil
      end
      nil
    else
      puts "ATS type #{company.ats_type.ats_type_code} not supported for company: #{company.company_name}"
    end
  end

  # get job role params
  def self.get_job_role_params(ats_code, job)
    case ats_code
    when 'LEVER'
      [job['text'], job['categories']['department'], job['categories']['team']]
    when 'GREENHOUSE'
      [job["title"], job["departments"][0]["name"], job['departments'][0]["name"]]
    else
      puts "ATS type #{ats_code} not supported"
    end
  end

  # safe jobs from ATS APIs
  def self.save_jobs(ats_code, company, jobs)
    active_job_ids = []
    job_count = 0  
    build_count = 0

    jobs.each do |job|
      job_role_params = get_job_role_params(ats_code, job)
      role_name, department_name, team_name = job_role_params

      job_role = JobRole.find_or_create_with_department_and_team(role_name, department_name, team_name)
      job_url = get_job_url(ats_code, job)

      # Map data values to job post fields
      mapped_data = map_ats_data_return(ats_code, job, company)
      job_count += 1

      # Prepare new job post data
      job_post_data = build_job_post_data(company, mapped_data, job_role)
      build_count += 1

      # Use the helper method to handle checking/updating existing jobs
      active_job_ids << process_existing_or_new_job(company, job_url, job_post_data)
    end

    puts "Mapped #{job_count} jobs from #{ats_code}"
    puts "Built #{build_count} job posts"
    active_job_ids
  end 

  # Map data values to job post fields
  def self.map_ats_data_return(ats, job, company)
    puts "json: #{job['categories']['allLocations']} "

    if ats == 'LEVER'
      {
        job_title: job['text'],
        job_country_id: handle_country_record(job['country'], job['country'], company.id, job['hostedUrl']), 
        job_setting_id: find_setting_id_by_name(job['workplaceType']), 
        job_description: job['descriptionBodyPlain'],
        job_url: job['hostedUrl'],
        job_additional: job['additionalPlain'],
        job_commitment_id: find_commitment_id_by_name(job['categories']['commitment']), 
        job_locations:  job['categories']['allLocations'], # need to update to jsobn
        job_posted: Time.at(job['createdAt'] / 1000).strftime('%Y-%m-%d'),
        job_internal_id_string: job['id'],
        job_applyUrl: job['applyUrl'],
        job_salary_max: job['salaryRange'] ? job['salaryRange']['max'] : nil,
        job_salary_min: job['salaryRange'] ? job['salaryRange']['min'] : nil,
        job_salary_currency_id: handle_currency_record(job['salaryRange']&.dig('currency'), company.id, job['hostedUrl']), 
        job_salary_interval_id: find_interval_id_by_name(job['salaryRange']&.dig('interval')) 
      }
    elsif ats == 'GREENHOUSE'
      {
        job_title: job["title"],
        # job_country_id: handle_country_record(job['country'], job['country'], company.id, job['absolute_url']), 
        # job_setting_id: find_setting_id_by_name(job['offices'].first['name']), 
        job_description: job["content"],
        job_url: job["absolute_url"],
        job_applyUrl: job["absolute_url"],
        job_locations: job['offices'].map { |office| office["name"] },  # neeed to update to json
        job_posted: job.is_a?(Hash) && job.key?("created_at") ? job["created_at"] : nil,
        job_updated: Time.parse(job["updated_at"]).strftime('%Y-%m-%d %H:%M:%S'),
        job_internal_id: job['internal_job_id'],
        job_url_id: job["id"],
        job_internal_id_string: job.is_a?(Hash) && job.key?("internal_job_id") ? job["internal_job_id"].to_s : nil,
        job_salary_max: job['salaryRange'] ? job['salaryRange']['max'] : nil,
        job_salary_min: job['salaryRange'] ? job['salaryRange']['min'] : nil,
        job_salary_currency_id: handle_currency_record(job['salaryRange']&.dig('currency'), company.id, job['absolute_url'] ), 
        job_salary_interval_id: find_interval_id_by_name(job['salaryRange']&.dig('interval'))  
      }
    end
  end 

# Helper to build job post data
def self.build_job_post_data(company, data, job_role)
  data.merge({
    company_id: company.id,
    job_active: true,
    job_role: job_role
  })
end

# Helper methods
def self.handle_country_record(country_code, country_name, company_id, job_url)
  Country.find_or_adjudicate_country(country_code, country_name, company_id, job_url)
end

def self.find_setting_id_by_name(setting_name)
  JobSetting.find_by(setting_name: setting_name)&.id
end

def self.find_commitment_id_by_name(commitment_name)
  JobCommitment.find_by(commitment_name: commitment_name)&.id
end

def self.handle_currency_record(currency_code, company_id, job_url)
  JobSalaryCurrency.find_or_adjudicate_currency(currency_code, company_id, job_url)&.id
end

def self.find_interval_id_by_name(interval_name)
  JobSalaryInterval.find_by(interval: interval_name)&.id
end
end
