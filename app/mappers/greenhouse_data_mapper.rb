class GreenhouseDataMapper
  def self.map(job)
    location_info = parse_location(job.dig('location', 'name'))

    {
      job_title: job['title'],
      job_url: job['absolute_url'],
      job_description: job['content'],
      job_posted: parse_datetime(job['created_at']),
      job_updated: parse_datetime(job['updated_at']),
      job_internal_id: job['internal_job_id'],
      job_applyUrl: job['absolute_url'],
      job_locations: location_info,
      job_responsibilities: extract_responsibilities(job),
      job_qualifications: extract_qualifications(job),
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

  def self.url(company, job)
    job['absolute_url']
  end

  private

  def self.extract_responsibilities(job)
    match_section(job['content'], 'Responsibilities', 'Qualifications')
  end

  def self.extract_qualifications(job)
    match_section(job['content'], 'Qualifications', 'Work-life, Culture & Perks')
  end

  def self.match_section(content, start_keyword, end_keyword)
    return unless content

    content.match(/#{start_keyword}[:\-](.*?)#{end_keyword}[:\-]/m)&.captures&.first&.strip
  end

  def self.parse_datetime(datetime)
    DateTime.parse(datetime).strftime('%Y-%m-%d') if datetime
  end

  def self.parse_location(location)
    is_remote = location.to_s.downcase.include?('remote')
    {
      cities: [location],
      is_remote: is_remote
    }
  end

  def self.find_team_id(departments)
    return unless departments

    Team.find_or_create_by(team_name: departments.first['name'])&.id
  end

  def self.find_role_id(title)
    return unless title

    JobRole.find_or_create_by(role_name: title)&.id
  end
end
