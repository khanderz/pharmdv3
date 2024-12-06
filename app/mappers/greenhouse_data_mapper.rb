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
        department_name: extract_departments(job),
        team_name: extract_departments(job),
        job_commitment: nil, 
        job_responsibilities: extract_responsibilities(job),
        job_qualifications: extract_qualifications(job)
      }
    end
  
    def self.url(company, job)
      job['absolute_url']
    end
  
    private
  
    def self.extract_departments(job)
      job['departments']&.map { |dept| dept['name'] }
    end
  
    def self.extract_responsibilities(job)
      find_content(job, 'responsibilities')
    end
  
    def self.extract_qualifications(job)
      find_content(job, 'qualifications')
    end
  
    def self.find_content(job, key)
      list = job['lists']&.find { |l| l['text'].to_s.downcase.include?(key) }
      return unless list
  
      list['content'].gsub('</li><li>', "\n").gsub(%r{</?[^>]*>}, '')
    end
  
    def self.parse_datetime(datetime)
      Date.parse(datetime).strftime('%Y-%m-%d') if datetime
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
  