# frozen_string_literal: true

# app/mappers/mapper_utils.rb

class LocationHelper
  # Extracts the location information from a job post.
  #
  # @param job [Hash] The job data containing location details.
  # @param source [String] The source of the job data (e.g., 'lever', 'greenhouse').
  # @return [String, nil] The extracted location or nil if not found.
  def self.extract_location(job, source = 'greenhouse')
    case source.downcase
    when 'lever'
      location_input = job['categories']&.dig('location') || job['categories']&.dig('allLocations') || ''
      location_input.empty? ? nil : location_input
    when 'greenhouse'
      if job['offices'].is_a?(Array) && job['offices'].any?
        job['offices'].first['location']
      else
        job.dig('location', 'name')
      end
    else
      nil
    end
  end
end


class AiSalaryUpdater
  # Updates salary-related fields in the job post data using AI-extracted information.
  #
  # @param job_post_data [Hash] The current job post data.
  # @param job [Hash] The raw job data.
  # @param company [Object] The company object associated with the job.
  # @return [Boolean] True if the job post data was updated, otherwise false.
  def self.update_with_ai(job_post_data, job, company)
    ai_salary_data = JobPostService.split_descriptions(job, entity_type = 'salary')
    updated = false

    ai_salary_data.each do |field_data|
      field_data.each do |key, value|
        case key
        when 'salary'
          job_post_data[:job_salary_min] = value[:job_salary_min] if value[:job_salary_min]
          job_post_data[:job_salary_max] = value[:job_salary_max] if value[:job_salary_max]
          job_post_data[:job_salary_single] = value[:job_salary_single] if value[:job_salary_single]

          currency_id = if value[:job_salary_currency]
                          JobSalaryCurrency.find_or_adjudicate_currency(
                            value[:job_salary_currency], company.id, job_post_data[:job_url]
                          )
                        end
          interval_id = value[:job_salary_interval] ? JobSalaryInterval.find_by(interval: value[:job_salary_interval]) : nil

          job_post_data[:job_salary_currency_id] = currency_id
          job_post_data[:job_salary_interval_id] = interval_id
          updated = true
        when 'description', 'summary'
          job_post_data[:job_description] ||= ''
          job_post_data[:job_description] += ' ' unless job_post_data[:job_description].empty?
          job_post_data[:job_description] += value
        else
          puts "#{RED}Unexpected key: #{key}.#{RESET}"
        end
      end

    # unless updated_by_ai
    #   job_post_data[:job_salary_min] ||= nil
    #   job_post_data[:job_salary_max] ||= nil
    #   job_post_data[:job_salary_single] ||= nil
    #   job_post_data[:job_salary_currency_id] ||= nil
    #   job_post_data[:job_salary_interval_id] ||= nil
    # end
    end

    updated
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


class JobPostDataMapper
  # Maps basic job post data from the job and company data.
  #
  # @param job [Hash] The raw job data.
  # @param company [Object] The company object associated with the job.
  # @param location_info [Hash] The extracted location information.
  # @return [Hash] A hash containing the mapped job post data.
  def self.map_basic_data(job, _company, location_info, source = 'greenhouse')
    {
      job_title: job['title'] || job['text'],
      job_url: job['absolute_url'] || job['hostedUrl'],

      job_description: job['descriptionBodyPlain'] || nil,
      job_responsibilities: ResponsibilitiesExtractor.extract_responsibilities(job, source),
      job_additional: job['additionalPlain'] || nil,

      job_posted: JobPost.parse_datetime(job['created_at'] || job['createdAt']),
      job_updated: JobPost.parse_datetime(job['updated_at'] || job['updatedAt']),

      job_internal_id: job['internal_job_id'] || job['id'],
      job_applyUrl: job['absolute_url'] || job['applyUrl'],

      department_id: Department.find_department(
        job['departments']&.first&.dig('name') || job['categories']['department'], 'JobPost', job['absolute_url'] || job['hostedUrl']
      ).id,
      team_id: Team.find_team(job['categories']['team'], 'JobPost', job['hosted_url']).id || nil,

      job_commitment_id: JobCommitment.find_job_commitment(job['categories']&.dig('commitment')) || nil,
      job_setting: location_info[:location_type] || nil,

      job_salary_min: nil,
      job_salary_max: nil,
      job_salary_single: nil,
      job_salary_currency_id: nil,
      job_salary_interval_id: nil,

      job_role_id: JobRole.find_or_create_job_role(job['title']),
      job_active: true
    }
  end
end
