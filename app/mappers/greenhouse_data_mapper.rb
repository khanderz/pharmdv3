class GreenhouseDataMapper
  def self.map(job)
    location_info = parse_location(job.dig('location', 'name'))

    {
      job_title: job['title'],
      job_url: job['absolute_url'],
      job_description: job['content'],
      job_posted: JobPost.parse_datetime(job['created_at']),
      job_updated: JobPost.parse_datetime(job['updated_at']),
      job_internal_id: job['internal_job_id'],
      job_applyUrl: job['absolute_url'],
      job_locations: location_info,
      job_responsibilities: extract_responsibilities(job),
      department_id: Department.find_department(job['departments'][0]['name'], 'JobPost',
      job['absolute_url']).id,
      team_id: nil,
      job_commitment_id: nil, 
      job_salary_min: nil, 
      job_salary_max: nil, 
      job_salary_currency_id: nil, 
      job_salary_interval_id: nil, 
      job_role_id: find_role_id(job['title']),
      job_active: true 
    }
  end
  
  private

  def self.extract_responsibilities(job)
    match_section(job['content'], 'Responsibilities', 'Qualifications')
  end

  def self.match_section(content, start_keyword, end_keyword)
    return unless content

    content.match(/#{start_keyword}[:\-](.*?)#{end_keyword}[:\-]/m)&.captures&.first&.strip
  end

  def self.parse_location(location)
    is_remote = location.to_s.downcase.include?('remote')
    {
      cities: [location],
      is_remote: is_remote
    }
  end

  def self.find_role_id(title)
    return unless title

    JobRole.find_or_create_by(role_name: title)&.id
  end
end
