# frozen_string_literal: true

class JobDataMapper
  def self.map(company, job)
    ats_code = company.ats_type.ats_type_code
    case ats_code
    when 'LEVER'
      LeverDataMapper.map(job, company)
    when 'GREENHOUSE'
      GreenhouseDataMapper.map(job, company)
    end
  end

  def self.url(company, job)
    ats_code = company.ats_type.ats_type_code
    case ats_code
    when 'LEVER'
      job['hostedUrl']
    when 'GREENHOUSE'
      job['absolute_url']
    end
  end

    # Maps basic job post data from the job and company data.
  #
  # @param job [Hash] The raw job data.
  # @param company [Object] The company object associated with the job.
  # @param location_info [Hash] The extracted location information.
  # @return [Hash] A hash containing the mapped job post data.
  def self.map_basic_data(job, _company, location_info, source = 'greenhouse')
    team_var = source == 'lever' ? Team.find_team(job['categories']&.dig('team'), 'JobPost', job['hosted_url'])&.id : nil

    {
      job_title: job['title'] || job['text'],
      job_url: job['absolute_url'] || job['hostedUrl'],
      job_applyUrl: job['absolute_url'] || job['applyUrl'],

      job_description: job['descriptionBodyPlain'] || nil,
      job_responsibilities: ResponsibilitiesExtractor.extract_responsibilities(job, source),
      job_additional: job['additionalPlain'] || nil,

      job_posted: JobPost.parse_datetime(job['created_at'] || job['createdAt']),
      job_updated: JobPost.parse_datetime(job['updated_at'] || job['updatedAt']),

      job_internal_id: job['internal_job_id'] || job['id'],
      job_url_id: job['id'] || nil,

      department_id: Department.find_department(
        job['departments']&.first&.dig('name') || job['categories']['department'], 'JobPost', job['absolute_url'] || job['hostedUrl']
      ).id,
      team_id: team_var,

      job_commitment_id: JobCommitment.find_job_commitment(job['categories']&.dig('commitment')) || nil,
      job_setting: location_info[:location_type] || nil,

      job_salary_min: nil,
      job_salary_max: nil,
      job_salary_single: nil,
      job_salary_currency_id: nil,
      job_salary_interval_id: nil,

      job_role_id: JobRole.find_or_create_job_role(job['title'] || job['text']),
      job_active: true
    }
  end
end

class ResponsibilitiesExtractor
  # Extracts the responsibilities section from the job content.
  #
  # @param job [Hash] The raw job data.
  # @param source [String] The source of the job data (e.g., 'lever', 'greenhouse').
  # @return [String, nil] The extracted responsibilities or nil if not found.
  def self.extract_responsibilities(job, source = 'greenhouse')
    case source.downcase
    when 'lever'
      extract_list(job, 'responsibilities:')
    when 'greenhouse'
      match_section(job['content'], 'Responsibilities')
    else
      nil
    end
  end

  # Matches a section in the job content based on the start and end keywords.
  #
  # @param content [String] The content to search within.
  # @param start_keyword [String] The keyword to mark the beginning of the section.
  # @param end_keyword [String] The keyword to mark the end of the section (default is 'Qualifications').
  # @return [String, nil] The matched section content or nil if not found.
  def self.match_section(content, start_keyword, end_keyword = 'Qualifications')
    return unless content

    content.match(/#{start_keyword}[:-](.*?)#{end_keyword}[:-]/m)&.captures&.first&.strip
  end

  # Extracts a list from the job content based on the specified key.
  #
  # @param job [Hash] The raw job data.
  # @param key [String] The keyword to match the relevant list section.
  # @return [String, nil] The extracted list content or nil if not found.
  def self.extract_list(job, key)
    list = job['lists']&.find { |l| l['text'].to_s.downcase.include?(key) }
    return unless list

    list['content'].gsub('</li><li>', "\n").gsub(%r{</?[^>]*>}, '')
  end
end