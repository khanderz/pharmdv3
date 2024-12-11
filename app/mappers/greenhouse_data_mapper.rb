# frozen_string_literal: true

# app/mappers/greenhouse_data_mapper.rb

class GreenhouseDataMapper
  def self.map(job, company)
    location_input = LocationMapper.extract_location(job, 'greenhouse')
    location_info = LocationMapper.new.match_location(location_input, job, company)

    job_post_data = JobDataMapper.map_basic_data(job, company, location_info, 'greenhouse')
    print_job_post_data(job_post_data)

    updated_by_ai = AiUpdater.update_with_ai(job_post_data, job, company)

    job_post_data
  end

  def self.print_job_post_data(job_post_data)
    puts "\n--- Job Post Data ---"
    puts "Company ID: #{job_post_data[:company_id]}"
    puts "Job Title: #{job_post_data[:job_title]}"
    puts "Job URL: #{job_post_data[:job_url]}"
    puts "Apply URL: #{job_post_data[:job_applyUrl]}"
    puts "Job Description: #{job_post_data[:job_description] || 'N/A'}"
    puts "Job Responsibilities: #{job_post_data[:job_responsibilities]}"
    puts "Job Qualifications: #{job_post_data[:job_qualifications] || 'N/A'}"
    puts "Job Posted Date: #{job_post_data[:job_posted] || 'N/A'}"
    puts "Job Updated Date: #{job_post_data[:job_updated]}"
    puts "Job Internal ID: #{job_post_data[:job_internal_id]}"
    puts "Job URL ID: #{job_post_data[:job_url_id]}"
    puts "Department ID: #{job_post_data[:department_id]}"
    puts "Team ID: #{job_post_data[:team_id] || 'N/A'}"
    puts "Job Setting: #{job_post_data[:job_setting]}"
    puts "Job Salary Min: #{job_post_data[:job_salary_min] || 'N/A'}"
    puts "Job Salary Max: #{job_post_data[:job_salary_max] || 'N/A'}"
    puts "Job Salary Currency ID: #{job_post_data[:job_salary_currency_id] || 'N/A'}"
    puts "Job Salary Interval ID: #{job_post_data[:job_salary_interval_id] || 'N/A'}"
    puts "Job Role ID: #{job_post_data[:job_role_id].id}"
    puts "Job Active: #{job_post_data[:job_active] ? 'Yes' : 'No'}"
    puts '--- End of Job Post Data ---'
  end
end
