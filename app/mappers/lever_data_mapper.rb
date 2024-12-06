class LeverDataMapper
    def self.map(job)
      location_info = parse_location(job['categories']&.dig('location') || job['categories']&.dig('allLocations') || '')
  
      {
        job_title: job['text'],
        job_url: job['hostedUrl'],
        job_description: job['descriptionBodyPlain'],
        job_responsibilities: extract_list(job, 'responsibilities:'),
        job_qualifications: extract_list(job, 'requirements:'),
        job_additional: job['additionalPlain'],
        job_posted: parse_datetime(job['createdAt']),
        job_updated: parse_datetime(job['updatedAt']),
        job_internal_id_string: job['id'],
        job_salary_min: job['salaryRange']&.dig('min'),
        job_salary_max: job['salaryRange']&.dig('max'),
        job_applyUrl: job['applyUrl'],
        job_locations: location_info,
        job_commitment_id: find_or_create_job_commitment(job['categories']&.dig('commitment')),
        job_salary_currency_id: find_or_create_salary_currency(job['salaryRange']&.dig('currency'), company),
        job_salary_interval_id: find_or_create_salary_interval(job['salaryRange']&.dig('interval')),
        department_id: Department.find_department(job['categories']['department'], 'JobPost', job['hosted_url']).id,
        team_id: Team.find_team(job['categories']['team'], 'JobPost', job['hosted_url']).id,
        job_role_id: find_or_create_job_role(job['text'], company)
      }
    end
  
    def self.url(company, job)
      job['hostedUrl']
    end
  
    private
  
    def self.extract_list(job, key)
      list = job['lists']&.find { |l| l['text'].to_s.downcase.include?(key) }
      return unless list
  
      list['content'].gsub('</li><li>', "\n").gsub(%r{</?[^>]*>}, '')
    end
  
    def self.parse_datetime(timestamp)
      Time.at(timestamp / 1000).strftime('%Y-%m-%d') if timestamp
    end
  
    def self.parse_location(location)
      is_remote = location.downcase.include?('remote')
      location = location.gsub(/\sor.*/i, '') if location.downcase.include?('or')
  
      {
        countries: [], 
        states: [], 
        cities: [location],
        is_remote: is_remote
      }
    end
  end
  