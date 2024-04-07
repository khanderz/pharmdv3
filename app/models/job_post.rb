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

    if departments.is_a?(Hash)
      return departments
    else
      return "Error: #{departments['message']}, cannot get Greenhouse departments"
    end
  end

  def self.save_greenhouse_job_urls(company, departments)
    departments.each do |depts, jobs|
      #  jobs looks like :jobs: [{"id"=>4065145004, "name"=>"Client Services", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[{"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5085207004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4647497004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5085207004, "updated_at"=>"2024-04-04T10:29:36-04:00", "requisition_id"=>"182", "title"=>"Client Strategist"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5139200004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4676176004, "location"=>{"name"=>"New York Metro"}, "metadata"=>nil, "id"=>5139200004, "updated_at"=>"2024-03-25T16:44:32-04:00", "requisition_id"=>"187", "title"=>"Platform Delivery Lead (AI / Insurtech)"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5061046004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4578952004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5061046004, "updated_at"=>"2024-03-11T11:17:27-04:00", "requisition_id"=>"136", "title"=>"Senior Technical Engagement Manager (AI / Insurtech)"}]}, {"id"=>4066941004, "name"=>"Engineering", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[{"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5052096004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4613793004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5052096004, "updated_at"=>"2024-03-11T11:12:24-04:00", "requisition_id"=>"167", "title"=>"Engineering Manager (Insurtech / AI space)"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5070461004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4639079004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5070461004, "updated_at"=>"2024-03-19T16:40:38-04:00", "requisition_id"=>"177", "title"=>"Program Manager (AI / Insurtech SaaS)"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5149681004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4681370004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5149681004, "updated_at"=>"2024-04-05T12:30:29-04:00", "requisition_id"=>"190", "title"=>"Senior Machine Learning (ML) Engineer"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5137320004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4675033004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5137320004, "updated_at"=>"2024-03-26T13:20:00-04:00", "requisition_id"=>"186", "title"=>"Senior Manager, Quality Engineering"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5133992004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4639079004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5133992004, "updated_at"=>"2024-03-19T16:40:27-04:00", "requisition_id"=>"177", "title"=>"Senior Program Manager (AI / Insurtech SaaS)"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5044735004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4595900004, "location"=>{"name"=>"New York, NY "}, "metadata"=>nil, "id"=>5044735004, "updated_at"=>"2024-03-11T11:09:24-04:00", "requisition_id"=>"151", "title"=>"Senior Software Engineer, Full Stack (Front End focus)"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5077730004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4571552004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5077730004, "updated_at"=>"2024-03-11T11:25:50-04:00", "requisition_id"=>"133", "title"=>"Senior Software Engineer, Full Stack (Python / AI / Insurtech)"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5077731004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4629363004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5077731004, "updated_at"=>"2024-03-11T11:25:50-04:00", "requisition_id"=>"174", "title"=>"Senior Software Engineer (Python / Insurtech / AI)"}]}, {"id"=>4046067004, "name"=>"Engineering - Application Development", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[]}, {"id"=>4046069004, "name"=>"Engineering - Data Engineering", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[]}, {"id"=>4050992004, "name"=>"Engineering - DevOps", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[]}, {"id"=>4046068004, "name"=>"Engineering - Machine Learning", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[]}, {"id"=>4068706004, "name"=>"Executive", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[]}, {"id"=>4069060004, "name"=>"Finance", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[]}, {"id"=>4049092004, "name"=>"Marketing", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[]}, {"id"=>4057301004, "name"=>"Operations", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[{"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5143442004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "education"=>"education_required", "internal_job_id"=>4678317004, "location"=>{"name"=>"New York, NY HQ"}, "metadata"=>nil, "id"=>5143442004, "updated_at"=>"2024-04-04T17:24:35-04:00", "requisition_id"=>"189", "title"=>"Business (Sales) Operations Manager/Director"}]}, {"id"=>4043561004, "name"=>"People Ops", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[{"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5126914004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4669645004, "location"=>{"name"=>"New York (HQ)"}, "metadata"=>nil, "id"=>5126914004, "updated_at"=>"2024-03-19T16:16:31-04:00", "requisition_id"=>"183", "title"=>"People (HR) Operations Manager"}]}, {"id"=>4043563004, "name"=>"Product", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[{"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5073455004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4641005004, "location"=>{"name"=>"New York, NY "}, "metadata"=>nil, "id"=>5073455004, "updated_at"=>"2024-02-06T15:41:12-05:00", "requisition_id"=>"179", "title"=>"Senior Product Designer"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5130138004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4671226004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5130138004, "updated_at"=>"2024-03-13T18:37:18-04:00", "requisition_id"=>"184", "title"=>"Senior Product Manager "}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5140305004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4676639004, "location"=>{"name"=>"New York, NY"}, "metadata"=>nil, "id"=>5140305004, "updated_at"=>"2024-03-26T13:37:10-04:00", "requisition_id"=>"188", "title"=>"Senior Product Marketing Manager"}]}, {"id"=>4043562004, "name"=>"Sales / Business Development", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[{"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5083713004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4645879004, "location"=>{"name"=>"Canada (Remote)"}, "metadata"=>nil, "id"=>5083713004, "updated_at"=>"2024-03-22T14:57:21-04:00", "requisition_id"=>"181", "title"=>"Sales Director, Canadian Disability & Workers Compensation (AI / Insurtech)"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5082310004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4645879004, "location"=>{"name"=>"Canada (Remote)"}, "metadata"=>nil, "id"=>5082310004, "updated_at"=>"2024-03-22T14:57:07-04:00", "requisition_id"=>"181", "title"=>"Sales Director, Canadian Disability & Workers Compensation (AI / Insurtech)"}, {"absolute_url"=>"https://evolutioniq.com/open-jobs/?gh_jid=5082301004", "data_compliance"=>[{"type"=>"gdpr", "requires_consent"=>false, "requires_processing_consent"=>false, "requires_retention_consent"=>false, "retention_period"=>nil}], "internal_job_id"=>4645879004, "location"=>{"name"=>"Canada (Remote)"}, "metadata"=>nil, "id"=>5082301004, "updated_at"=>"2024-03-22T14:56:31-04:00", "requisition_id"=>"181", "title"=>"Sales Director, Canadian Disability & Workers Compensation (AI / Insurtech)"}]}, {"id"=>0, "name"=>"No Department", "parent_id"=>nil, "child_ids"=>[], "jobs"=>[]}]

      jobs["jobs".to_i].each do |job|
        # job: ["id", 4065145004]
        puts "job: #{job}"
        job_post = JobPost.new(
          company: company,
          job_title: job['title'],
          job_location: job['location']['name'],
          job_url: job['absolute_url'],
          job_dept: depts['name'],
          job_internal_id: job['id'],
          job_updated: job['updated_at'],
        )
  
        if job_post.valid?
          job_post.save
          puts "#{company.company_name} job post added"
        else
          puts "#{company.company_name} job post not saved - validation failed: #{job_post.errors.full_messages.join(', ')}"
        end
      end
    end
  end

  def self.get_greenhouse_jobs(jcompany, job_urls)
    ats_id = company.ats_id
    job_internal_id = job['id']
    puts "job_internal_id: #{job_internal_id},  ats_id: #{ats_id}"
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

