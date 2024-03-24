require 'net/http'
require 'json'

class JobPost < ApplicationRecord
  belongs_to :companies, foreign_key: "companies_id" 

  def self.fetch_lever_jobs
    Company.where(company_ats_type: 'LEVER').each do |company|
      jobs = get_lever_jobs(company)
      save_lever_jobs(company, jobs) if jobs.present?
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
        companies_id: company.id 
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

  # def seed_lever_jobs
  #   Company.where(company_ats_type: 'LEVER').each do |company|
  #     get_lever_jobs.each do |job|
  #       date = Time.at(job['createdAt'] / 1000).strftime('%Y-%m-%d')
  #       job_post = JobPost.new(
  #         job_title: job['text'],
  #         job_url: job['hostedUrl'],
  #         job_location: job['categories']['location'],
  #         job_dept: job['categories']['department'],
  #         job_updated: date,
  #         job_internal_id_string: job['id'],
  #         company: company
  #       )
  
  #       if job_post.valid?
  #         job_post.save
  #         puts "#{company.company_name} job post added"
  #       else
  #         puts "#{company.company_name} job post not saved - validation failed: #{job_post.errors.full_messages.join(', ')}"
  #       end
  #     end
  
  #     # Update company description based on additionalPlain key in API response
  #     response = get_lever_jobs
  #     if response.is_a?(Array)
  #       company_description = response.first['additionalPlain']
  #       company.update(company_description: company_description) if company_description.present?
  #     end
  
  #     puts "Lever jobs added to database for #{company.company_name}"
  #   end
end
