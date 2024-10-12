require 'net/http'
require 'json'

class JobPost < ApplicationRecord
  belongs_to :company, foreign_key: :companies_id
  belongs_to :job_role 

  # Method to find or create job role 
  def self.find_or_create_job_role(job_title) job_role = JobRole.find_by('role_name = ? OR ? = ANY (aliases)', job_title, job_title) unless job_role job_role = JobRole.create!(role_name: job_title) end job_role end




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
job_role = find_or_create_job_role(job['text']) 
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
  if departments && departments["departments"]
    department_jobs = departments["departments"].map { |department| [department["name"], department["jobs"]] }
    save_greenhouse_jobs(company, department_jobs)
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
    #  https://boards-api.greenhouse.io/v1/boards/ambiencehealthcare/departments
    # https://boards-api.greenhouse.io/v1/boards/evolutioniq/departments
    uri = URI(url)
    response = Net::HTTP.get(uri)
    departments = JSON.parse(response) # Parse the response string into a JSON object
    if departments.is_a?(Hash)
      return departments
    else
      return "Error: #{departments['message']}, cannot get Greenhouse departments"
    end
  end
def self.save_greenhouse_jobs(company, department_jobs)
  department_jobs.each do |department_name, jobs|
    if jobs.nil?
      puts "No jobs found for department: #{department_name}"
      next
    end
    jobs.each do |job|
      job_posted = job.is_a?(Hash) && job.key?("created_at") ? job["created_at"] : nil
      job_internal_id_string =  job.is_a?(Hash) && job.key?("internal_job_id") ? job["internal_job_id"].to_s : nil
      job_post = JobPost.new(
        companies_id: company.id, 
        job_title: job["title"],
        job_description: job["content"],
        job_url: job["absolute_url"],
        job_location: job["location"]["name"],
        job_dept: department_name,
        job_posted: job_posted,
        job_updated: job["updated_at"],
        job_active: !!job,
        job_internal_id: job['internal_job_id'],
        job_url_id: job["id"],
        job_internal_id_string: job_internal_id_string,
        # job_salary_min: job["metadata"]["salary_min"],
        # job_salary_max: job["metadata"]["salary_max"],
        # job_salary_range: job["metadata"]["salary_range"],
        # job_country: job["metadata"]["country"],
        # job_setting: job["metadata"]["workplace_type"],
        # job_additional: job["metadata"]["additional"],
        # job_commitment: job["metadata"]["commitment"],
        # job_team: job["metadata"]["team"],
        # job_allLocations: job["metadata"]["all_locations"],
        # job_responsibilities: job["metadata"]["responsibilities"],
        # job_qualifications: job["metadata"]["qualifications"],
        # job_applyUrl: job["metadata"]["apply_url"],
      )
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

