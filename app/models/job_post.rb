class JobPost < ApplicationRecord
  belongs_to :company, foreign_key: :companies_id
  belongs_to :job_role

  # Shared methods -----------------------------------------------------------
  # Deactivate old jobs that are no longer in the API data
  def self.deactivate_old_jobs(company, active_job_ids)
    JobPost.where(company: company).where.not(id: active_job_ids).update_all(job_active: false)
    puts "Deactivated old job posts for #{company.company_name}"
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
    Company.where(company_ats_type: 'LEVER').each do |company|
      JobPost.where(company: company).delete_all
    end
    puts "Lever jobs deleted from database"
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
    job_count = 0  # Initialize job count for mapped data
    build_count = 0 # Initialize job count for built data

    jobs.each do |job|
      job_role = JobRole.find_or_create_with_department(job['text'], job['categories']['department'])

      unless job_role.persisted?
        puts "Job Role creation failed for #{job['text']}"
        next
      end

      # Map data values to job post fields
      mapped_data = map_ats_data_return('lever', job)
      job_count += 1  # Increment mapped data counter

      # Prepare new job post data
      job_post_data = build_job_post_data(company, mapped_data, job_role)
      build_count += 1  # Increment built job counter

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
    Company.where(company_ats_type: 'GREENHOUSE').each do |company|
      JobPost.where(company: company).delete_all
    end
    puts "Greenhouse jobs deleted from database"
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
    job_count = 0  # Initialize job count for mapped data
    build_count = 0 # Initialize job count for built data

    jobs.each do |job|
      job_role = JobRole.find_or_create_with_department(job["title"], job["departments"][0]["name"])

      unless job_role.persisted?
        puts "Job Role creation failed for #{job['title']}"
        next
      end

      # Map data values to job post fields
      mapped_data = map_ats_data_return('greenhouse', job)
      job_count += 1  # Increment mapped data counter

      # Prepare the new job post data
      job_post_data = build_job_post_data(company, mapped_data, job_role)
      build_count += 1  # Increment built job counter

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
        job_country: job['country'],
        job_setting: job['workplaceType'],
        job_description: job['descriptionBodyPlain'],
        job_url: job['hostedUrl'],
        job_additional: job['additionalPlain'],
        job_commitment: job['categories']['commitment'],
        job_location: job['categories']['location'],
        job_dept: job['categories']['department'],
        job_team: job['categories']['team'],
        job_allLocations: job['categories']['allLocations'],
        job_posted: Time.at(job['createdAt'] / 1000).strftime('%Y-%m-%d'),
        job_internal_id_string: job['id'],
        job_applyUrl: job['applyUrl'],
        job_salary_max: job['salaryRange'] ?  job['salaryRange']['max'] : nil,
        job_salary_min: job['salaryRange'] ? job['salaryRange']['min'] : nil,
        # job_salary_currency: job['salaryRange'] ? job['salaryRange']['currency'] : nil,
        # job_salary_interval: job['salaryRange'] ? job['salaryRange']['interval'] : nil,
      }
    elsif ats == 'greenhouse'
      {
        job_title: job["title"],
        job_description: job["content"],
        job_url: job["absolute_url"],
        job_applyUrl: job["absolute_url"],
        job_location: job["location"]["name"],
        job_allLocations: job['offices'].map { |office| office["name"] }.join(', '),
        job_setting: job['offices'].map { |office| office["name"] }.join(', '),
        job_dept: job["departments"].map { |dept| dept["name"] }.join(', '),
        job_team: job["departments"].map { |dept| dept["name"] }.join(', '),
        job_posted: job.is_a?(Hash) && job.key?("created_at") ? job["created_at"] : nil,
        job_updated: Time.parse(job["updated_at"]).strftime('%Y-%m-%d %H:%M:%S'),
        job_internal_id: job['internal_job_id'],
        job_url_id: job["id"],
        job_internal_id_string: job.is_a?(Hash) && job.key?("internal_job_id") ? job["internal_job_id"].to_s : nil,
      }
    end
  end 

  # Helper to build job post data
  def self.build_job_post_data(company, data, job_role)
    data.merge({
      companies_id: company.id,
      job_active: true,
      job_role: job_role
    })
  end
end
