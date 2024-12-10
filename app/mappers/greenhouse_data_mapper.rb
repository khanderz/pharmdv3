# frozen_string_literal: true

# app/mappers/greenhouse_data_mapper.rb

class GreenhouseDataMapper
  def self.map(job, company)
    location_input = extract_location(job)
    location_info = LocationMapper.new.match_location(location_input, job, company)
    # puts "processing job: #{job['title']} for company #{company.company_name}"

    job_post_data = {
      job_title: job['title'],
      job_url: job['absolute_url'],

      job_description: nil,
      job_responsibilities: extract_responsibilities(job),

      job_posted: JobPost.parse_datetime(job['created_at']),
      job_updated: JobPost.parse_datetime(job['updated_at']),

      job_internal_id: job['internal_job_id'],
      job_applyUrl: job['absolute_url'],

      department_id: Department.find_department(job['departments'][0]['name'], 'JobPost',
                                                job['absolute_url']).id,
      team_id: nil,

      job_commitment_id: nil,
      job_setting: location_info[:location_type] || nil,

      job_salary_min: nil,
      job_salary_max: nil,
      job_salary_single: nil,
      job_salary_currency_id: nil,
      job_salary_interval_id: nil,

      job_role_id: JobRole.find_or_create_job_role(job['title']),
      job_active: true
    }

    updated_by_ai = update_with_ai(job_post_data, job, company)

    # unless updated_by_ai
    #   job_post_data[:job_salary_min] ||= nil
    #   job_post_data[:job_salary_max] ||= nil
    #   job_post_data[:job_salary_single] ||= nil
    #   job_post_data[:job_salary_currency_id] ||= nil
    #   job_post_data[:job_salary_interval_id] ||= nil
    # end

    job_post_data
  end

  def self.update_with_ai(job_post_data, job, company)

    ai_salary_data = JobPostService.split_descriptions(job, entity_type = 'salary')

    puts "AI Salary Data: #{ai_salary_data}"
    updated = false

    ai_salary_data.each do |field_data|
      field_data.each do |key, value|
        case key
        when 'salary'
          job_post_data[:job_salary_min] = value[:job_salary_min] if value[:job_salary_min]
          job_post_data[:job_salary_max] = value[:job_salary_max] if value[:job_salary_max]
          job_post_data[:job_salary_single] = value[:job_salary_single] if value[:job_salary_single]
          
          currency_id = value[:job_salary_currency] ? JobSalaryCurrency.find_or_adjudicate_currency(value[:job_salary_currency], company.id, job_post_data[:job_url]) : nil
          interval_id = value[:job_salary_interval] ? JobSalaryInterval.find_by(interval: value[:job_salary_interval]) : nil
  
          job_post_data[:job_salary_currency_id] = currency_id
          job_post_data[:job_salary_interval_id] = interval_id
          updated = true
        when 'description', 'summary'
           puts "Debugging key: #{key}, value: #{value}"
          job_post_data[:job_description] ||= ""
          job_post_data[:job_description] += " " unless job_post_data[:job_description].empty?
          job_post_data[:job_description] += value
        else
          puts "#{RED}Unexpected key: #{key}.#{RESET}"
        end
      end
    end

    updated
  end

  def self.extract_location(job)
    if job['offices'].is_a?(Array) && job['offices'].any?
      job['offices'].first['location']
    else
      job.dig('location', 'name')
    end
  end

  def self.extract_responsibilities(job)
    match_section(job['content'], 'Responsibilities')
  end

  def self.match_section(content, start_keyword, end_keyword)
    return unless content

    content.match(/#{start_keyword}[:-](.*?)#{end_keyword}[:-]/m)&.captures&.first&.strip
  end
end
