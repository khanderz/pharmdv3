require 'net/http'
require 'json'

class JobPost < ApplicationRecord
  belongs_to :companies, foreign_key: "companies_id", class_name: 'Company'


  # lever jobs -----------------------------------------------------------
  def self.fetch_lever_jobs(company)
      jobs = get_lever_jobs(company)
      save_lever_jobs(company, jobs) if jobs.present?
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
    jobs = JSON.parse(response) # Parse the response string into a JSON object

    if jobs.is_a?(Array) # Check if the response is an array (indicating successful request)
      return jobs
    else
      return "Error: #{jobs['message']}, cannot get Lever jobs"
    end

  end

  def self.save_lever_jobs(company, jobs)
    jobs.each do |job|
      date = Time.at(job['createdAt'] / 1000).strftime('%Y-%m-%d')
      job_post = JobPost.new(
        companies_id: company.id, 
        job_title: job['text'],
        job_country: job['country'],
        job_setting: job['workplaceType'],
        job_description: job['descriptionBodyPlain'] || job['descriptionPlain'],
        job_url: job['hostedUrl'],
        job_additional: job['additionalPlain'],
        job_commitment: job['categories']['commitment'],
        job_location: job['categories']['location'],
        job_dept: job['categories']['department'],
        job_team: job['categories']['team'],
        job_allLocations: job['categories']['allLocations'],
        job_posted: job['createdAt'],
        job_internal_id_string: job['id'],
        job_applyUrl: job['applyUrl'],
        job_updated: date,
      )

        # Map lists to job attributes
        job['lists'].each do |item|
          case item['text']
          when /responsibilities/i
            job_post.job_responsibilities ||= ''
            job_post.job_responsibilities += item['content']
          when 'Qualifications:'
            job_post.job_qualifications = item['content']
          end
        end


      if job_post.valid?
        job_post.save
        puts "#{company.company_name} job post added"
      else
        puts "#{company.company_name} job post not saved - validation failed: #{job_post.errors.full_messages.join(', ')}"
      end
    end
    puts "Lever jobs added to database for #{company.company_name}"
  end



  # greenhouse jobs -----------------------------------------------------------
  def self.fetch_greenhouse_jobs(company)
    departments = get_greenhouse_departments(company)
    puts "departments: #{departments}"
    job_urls = save_greenhouse_job_urls(company, departments)
    jobs = get_greenhouse_jobs(company, job_urls)
    save_greenhouse_jobs(company, jobs) if jobs.present?
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
    #  https://boards-api.greenhouse.io/v1/boards/ambiencehealthcare/departments
    # https://boards-api.greenhouse.io/v1/boards/evolutioniq/departments
    uri = URI(url)
    response = Net::HTTP.get(uri)
    departments = JSON.parse(response) # Parse the response string into a JSON object
puts "departments: #{departments}"
    if departments.is_a?(Hash)
      return departments
    else
      return "Error: #{departments['message']}, cannot get Greenhouse departments"
    end
  end

  def self.save_greenhouse_job_urls(company, departments)
    departments.each do |depts|
      for jobs in depts['jobs']
        for job in jobs      
          job_post = JobPost.new(
            company: company,
            job_title: job['title'],
            job_location: job['location']['name'],
            job_url: job['absolute_url'],
            job_dept: depts['name'],
            job_internal_id: job['id'],
            job_updated: job['updated_at'],
          )
        end
      end

      return job_post.job_internal_id
    end

  end

  def self.get_greenhouse_jobs(jcompany, job_urls)
    ats_id = company.ats_id
    job_internal_id = job['id']
    url = "https://boards-api.greenhouse.io/v1/boards/#{ats_id}/jobs/#{job_internal_id}"
    # https://boards-api.greenhouse.io/v1/boards/evolutioniq/jobs/5085207004
    # https://boards-api.greenhouse.io/v1/boards/ambiencehealthcare/jobs/4228751005
    uri = URI(url)
    response = Net::HTTP.get(uri)
    job = JSON.parse(response) # Parse the response string into a JSON object

    if jobs.is_a?(Array) # Check if the response is an array (indicating successful request)
      return jobs
    else
      return "Error: #{jobs['message']}, cannot get Greenhouse jobs"
    end
  end

  def self.save_greenhouse_jobs(company, job)
    jobs.each do |job|
      existing_job_post = JobPost.find_by(job_internal_id: job['id'])
  
      if existing_job_post
        existing_job_post.update(
          job_description: job['content'],
          # job_salary_min: job['metadata']['salary_min'],
          # job_salary_max: job['metadata']['salary_max'],
          # job_salary_range: job['metadata']['salary_range']
        )
  
        if existing_job_post.valid?
          existing_job_post.save
          puts "#{company.company_name} job post updated"
        else
          puts "#{company.company_name} job post not updated - validation failed: #{existing_job_post.errors.full_messages.join(', ')}"
        end
      else
        puts "Job post not found for #{company.company_name}"

  
        if job_post.valid?
          job_post.save
          puts "#{company.company_name} job post added"
        else
          puts "#{company.company_name} job post not saved - validation failed: #{job_post.errors.full_messages.join(', ')}"
        end
      end
    end
    puts "Greenhouse jobs added to database for #{company.company_name}"
  end

  # eightfold jobs -----------------------------------------------------------
  # def self.fetch_eightfold_jobs(company)
  #   jobs = get_eightfold_jobs(company)
  #   save_eightfold_jobs(company, jobs) if jobs.present?
  # end

  # def self.clear_eightfold_data
  #   Company.where(company_ats_type: 'EIGHTFOLD').each do |company|


end

