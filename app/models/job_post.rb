class JobPost < ApplicationRecord
  belongs_to :company, foreign_key: :companies_id
  belongs_to :job_role

  # Method to find or create job role
  def self.find_or_create_job_role(job_title)
    job_role = JobRole.find_by('role_name = ? OR ? = ANY (aliases)', job_title, job_title)

    unless job_role
      job_role = JobRole.create(role_name: job_title)
      puts "Created new Job Role: #{job_title}"
    end

    job_role
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
    
    jobs.each do |job|
      date = Time.at(job['createdAt'] / 1000).strftime('%Y-%m-%d')
      job_role = find_or_create_job_role(job['text'])
      unless job_role.persisted?
        puts "Job Role creation failed for #{job['text']}"
        next
      end

      # Prepare the new job post data
      job_post_data = {
        companies_id: company.id,
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
        job_posted: date,
        job_internal_id_string: job['id'],
        job_applyUrl: job['applyUrl'],
        job_role: job_role,
        job_active: true # Set job_active to true for new or updated jobs
      }

      job['lists'].each do |item|
        case item['text']
        when /responsibilities/i
          job_post_data[:job_responsibilities] ||= ''
          job_post_data[:job_responsibilities] += item['content']
        when 'Qualifications:'
          job_post_data[:job_qualifications] = item['content']
        end
      end

      existing_job = JobPost.find_by(job_url: job['hostedUrl'])

      if existing_job
        # Check if any changes have occurred
        if existing_job.attributes.except('id', 'created_at', 'updated_at') == job_post_data
          puts "Job post already exists and is unchanged for URL: #{job['hostedUrl']}"
        else
          existing_job.update(job_post_data)
          puts "Updated job post for URL: #{job['hostedUrl']}"
        end
        active_job_ids << existing_job.id
      else
        # Create new job post
        new_job_post = JobPost.new(job_post_data)
        if new_job_post.save
          puts "#{company.company_name} job post added"
          active_job_ids << new_job_post.id
        else
          puts "#{company.company_name} job post not saved - validation failed: #{new_job_post.errors.full_messages.join(', ')}"
        end
      end
    end

    active_job_ids
  end

  # Deactivate old jobs that are no longer in the API data
  def self.deactivate_old_jobs(company, active_job_ids)
    JobPost.where(company: company).where.not(id: active_job_ids).update_all(job_active: false)
    puts "Deactivated old job posts for #{company.company_name}"
  end

  # Greenhouse jobs -----------------------------------------------------------
  def self.fetch_greenhouse_jobs(company)
    departments = get_greenhouse_departments(company)
    
    if departments && departments["departments"]
      department_jobs = departments["departments"].map { |department| [department["name"], department["jobs"]] }
      active_job_ids = save_greenhouse_jobs(company, department_jobs)
      deactivate_old_jobs(company, active_job_ids)
    else
      puts "No departments found for #{company.company_name}"
    end
  end

  def self.clear_greenhouse_data
    Company.where(company_ats_type: 'GREENHOUSE').each do |company|
      JobPost.where(company: company).delete_all
    end
    puts "Greenhouse jobs deleted from database"
  end

  private

  def self.get_greenhouse_departments(company)
    ats_id = company.ats_id
    url = "https://boards-api.greenhouse.io/v1/boards/#{ats_id}/departments"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    departments = JSON.parse(response)

    return departments if departments.is_a?(Hash)

    puts "Error: #{departments['message']}, cannot get Greenhouse departments"
    nil
  end

  def self.save_greenhouse_jobs(company, department_jobs)
    active_job_ids = []
    
    department_jobs.each do |department_name, jobs|
      if jobs.nil?
        puts "No jobs found for department: #{department_name}"
        next
      end

      jobs.each do |job|
        job_posted = job.is_a?(Hash) && job.key?("created_at") ? job["created_at"] : nil
        job_internal_id_string = job.is_a?(Hash) && job.key?("internal_job_id") ? job["internal_job_id"].to_s : nil
        existing_job = JobPost.find_by(job_url: job["absolute_url"])

        job_role = find_or_create_job_role(job["title"])
        unless job_role.persisted?
          puts "Job Role creation failed for #{job['title']}"
          next
        end

        # Prepare the new job post data
        job_post_data = {
          companies_id: company.id,
          job_title: job["title"],
          job_description: job["content"],
          job_url: job["absolute_url"],
          job_location: job["location"]["name"],
          job_dept: department_name,
          job_posted: job_posted,
          job_updated: job["updated_at"],
          job_active: true, # Set job_active to true for new or updated jobs
          job_internal_id: job['internal_job_id'],
          job_url_id: job["id"],
          job_internal_id_string: job_internal_id_string,
          job_role: job_role
        }

        if existing_job
          # Check if any changes have occurred
          if existing_job.attributes.except('id', 'created_at', 'updated_at') == job_post_data
            puts "Job post already exists and is unchanged for URL: #{job['absolute_url']}"
          else
            existing_job.update(job_post_data)
            puts "Updated job post for URL: #{job['absolute_url']}"
          end
          active_job_ids << existing_job.id
        else
          # Create new job post
          new_job_post = JobPost.new(job_post_data)
          if new_job_post.save
            puts "#{company.company_name} job post added"
            active_job_ids << new_job_post.id
          else
            puts "#{company.company_name} job post not saved - validation failed: #{new_job_post.errors.full_messages.join(', ')}"
          end
        end
      end
    end

    active_job_ids
  end
end
