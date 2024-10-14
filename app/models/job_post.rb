class JobPost < ApplicationRecord
  has_paper_trail  # PaperTrail for tracking changes

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
      # Check if any changes have occurred
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
        puts "#{company.company_name} job post not saved - validation failed: #{new_job_post.errors.full_messages.join(', ')}"
        return nil
      end
    end
  end

  # Lever jobs -----------------------------------------------------------
  def self.fetch_lever_jobs(company)
    jobs = get_lever_jobs(company)
    if jobs.present?
      active_job_ids = save_lever_jobs(company, jobs)
      deactivate_old_jobs(company, active_job_ids)
    end
  end

  def self.clear_lever_data
    Company.where(ats_type: AtsType.find_by(ats_type_code: 'lever')).each do |company|
      JobPost.where(company: company).delete_all
    end
    puts "Lever jobs deleted from the database"
  end

  private

  def self.get_lever_jobs(company)
    company_name = company.company_name.gsub(' ', '').downcase
    url = "https://api.lever.co/v0/postings/#{company_name}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    jobs = JSON.parse(response)
    return jobs if jobs.is_a?(Array)
    puts "Error: #{jobs['message']}, cannot get Lever jobs"
    nil
  end

  def self.save_lever_jobs(company, jobs)
    active_job_ids = []
    job_count = 0  
    build_count = 0

    jobs.each do |job|
      job_role = JobRole.find_or_create_with_department_and_team(job['text'], job['categories']['department'], job['categories']['team'])
      unless job_role.persisted?
        puts "Job Role creation failed for #{job['text']}"
        next
      end

      # Map data values to job post fields
      mapped_data = map_ats_data_return('lever', job)
      job_count += 1
      
      # Prepare new job post data
      job_post_data = build_job_post_data(company, mapped_data, job_role)
      build_count += 1
      
      # Use the helper method to handle checking/updating existing jobs
      active_job_ids << process_existing_or_new_job(company, job['hostedUrl'], job_post_data)
    end

    puts "Mapped #{job_count} jobs from Lever"
    puts "Built #{build_count} job posts"
    active_job_ids
  end

  # Greenhouse jobs -----------------------------------------------------------
  def self.fetch_greenhouse_jobs(company)
    jobs = get_greenhouse_jobs(company)
    if jobs && jobs["jobs"]
      jobs_mapped = jobs["jobs"].map { |job| job }
      active_job_ids = save_greenhouse_jobs(company, jobs_mapped)
      deactivate_old_jobs(company, active_job_ids)
    else
      puts "No jobs found for #{company.company_name}"
    end
  end

  def self.clear_greenhouse_data
    Company.where(ats_type: AtsType.find_by(ats_type_code: 'greenhouse')).each do |company|
      JobPost.where(company: company).delete_all
    end
    puts "Greenhouse jobs deleted from the database"
  end

  private

  def self.get_greenhouse_jobs(company)
    ats_id = company.ats_id
    url = "https://boards-api.greenhouse.io/v1/boards/#{ats_id}/jobs?content=true"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    jobs = JSON.parse(response)
    return jobs if jobs.is_a?(Hash)
    puts "Error: #{jobs['message']}, cannot get Greenhouse jobs"
    nil
  end
  
  def self.save_greenhouse_jobs(company, jobs)
    active_job_ids = []
    job_count = 0  
    build_count = 0

    jobs.each do |job|
      job_role = JobRole.find_or_create_with_department_and_team(job["title"], job["departments"][0]["name"], job['departments'][0]["name"])
      unless job_role.persisted?
        puts "Job Role creation failed for #{job['title']}"
        next
      end
      
      # Map data values to job post fields
      mapped_data = map_ats_data_return('greenhouse', job)
      job_count += 1
      
      # Prepare the new job post data
      job_post_data = build_job_post_data(company, mapped_data, job_role)
      build_count += 1
      
      # Use the helper method to handle checking/updating existing jobs
      active_job_ids << process_existing_or_new_job(company, job["absolute_url"], job_post_data)
    end

    puts "Mapped #{job_count} jobs from Greenhouse"
    puts "Built #{build_count} job posts"
    active_job_ids
  end

  # Map data values to job post fields
  def self.map_ats_data_return(ats, job)
    if ats == 'lever'
      {
        job_title: job['text'],
        job_country_id: find_country_id_by_code(job['country']), 
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
        job_salary_currency_id: find_currency_id_by_code(job['salaryRange']&.dig('currency')), 
        job_salary_interval_id: find_interval_id_by_name(job['salaryRange']&.dig('interval')) 
      }
    elsif ats == 'greenhouse'
      {
        job_title: job["title"],
        # job_location: job["location"]["name"],
        # job_country_id: find_country_id_by_code(job['country']), 
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
        job_salary_currency_id: find_currency_id_by_code(job['salaryRange']&.dig('currency')), # New mapping for salary currency
        job_salary_interval_id: find_interval_id_by_name(job['salaryRange']&.dig('interval')) # New mapping for salary interval
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

# Helper methods to find related ids by name or code
def self.find_country_id_by_code(country_code)
  Country.find_by(country_code: country_code)&.id
end

def self.find_setting_id_by_name(setting_name)
  JobSetting.find_by(setting_name: setting_name)&.id
end

def self.find_commitment_id_by_name(commitment_name)
  JobCommitment.find_by(commitment_name: commitment_name)&.id
end

def self.find_currency_id_by_code(currency_code)
  JobSalaryCurrency.find_by(currency_code: currency_code)&.id
end

def self.find_interval_id_by_name(interval_name)
  JobSalaryInterval.find_by(interval: interval_name)&.id
end

end
