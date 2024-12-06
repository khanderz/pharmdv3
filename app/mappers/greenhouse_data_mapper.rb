# app/mappers/greenhouse_data_mapper.rb

class GreenhouseDataMapper
  def self.map(job, company)
    location_input = extract_location(job)
    location_info = LocationMapper.new.match_location(location_input, job, company)

    job_post_data = {
      job_title: job['title'],
      job_url: job['absolute_url'],

      job_description: job['content'],
      job_responsibilities: extract_responsibilities(job),

      job_posted: JobPost.parse_datetime(job['created_at']),
      job_updated: JobPost.parse_datetime(job['updated_at']),

      job_internal_id: job['internal_job_id'],
      job_applyUrl: job['absolute_url'],

      department_id: Department.find_department(job['departments'][0]['name'], 'JobPost', job['absolute_url']).id,
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

    updated_by_ai = update_with_ai(job_post_data, job, location_info)

    unless updated_by_ai
      job_post_data[:job_salary_min] ||= nil
      job_post_data[:job_salary_max] ||= nil
      job_post_data[:job_salary_single] ||= nil
      job_post_data[:job_salary_currency_id] ||= nil
      job_post_data[:job_salary_interval_id] ||= nil
    end

    job_post_data
  end

  private

  def self.update_with_ai(job_post_data, job, location_info)
    ai_salary_data = JobPostService.extract_and_save_job_description_and_salary(job)
    # ai_location_data = JobPostService.extract_and_save_salary(location_info)

    updated = false

    if ai_salary_data
      job_post_data[:job_salary_min] = ai_salary_data[:salary_min]
      job_post_data[:job_salary_max] = ai_salary_data[:salary_max]
      job_post_data[:job_salary_single] = ai_salary_data[:salary_single]
      job_post_data[:job_salary_currency_id] = ai_salary_data[:currency_id]
      job_post_data[:job_salary_interval_id] = ai_salary_data[:interval_id]
      updated = true
    end

    # if ai_location_data
    #   job_post_data[:job_setting] = ai_location_data[:location_type]
    #   updated = true
    # end

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
    match_section(job['content'], 'Responsibilities', 'Qualifications')
  end

  def self.match_section(content, start_keyword, end_keyword)
    return unless content

    content.match(/#{start_keyword}[:\-](.*?)#{end_keyword}[:\-]/m)&.captures&.first&.strip
  end
end
