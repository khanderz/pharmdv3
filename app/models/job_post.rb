require 'net/http'
require 'json'

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
    jobs = JSON.parse(response)

    return jobs if jobs.is_a?(Array)

    puts "Error: #{jobs['message']}, cannot get Lever jobs"
    nil
  end

  def self.save_lever_jobs(company, jobs)
    jobs.each do |job|
      date = Time.at(job['createdAt'] / 1000).strftime('%Y-%m-%d')

      # Ensure the job_role is created or found before creating the job_post
      job_role = find_or_create_job_role(job['text'])
      unless job_role.persisted?
        puts "Job Role creation failed for #{job['text']}"
        next
      end

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
        job_role: job_role # Ensure this is set
      )

      # Handle responsibilities and qualifications
      job['lists'].each do |item|
        case item['text']
        when /responsibilities/i
          job_post.job_responsibilities ||= ''
          job_post.job_responsibilities += item['content']
        when 'Qualifications:'
          job_post.job_qualifications = item['content']
        end
      end

      if job_post.save
        puts "#{company.company_name} job post added"
      else
        puts "#{company.company_name} job post not saved - validation failed: #{job_post.errors.full_messages.join(', ')}"
      end
    end
    puts "Lever jobs added to database for #{company.company_name}"
  end
end
