# frozen_string_literal: true

class LeverDataMapper
  def self.map(job, company)
    location_info = LocationMatcher.match_location(
      job['categories']&.dig('location') || job['categories']&.dig('allLocations') || '',
      job,
      company,
      job['country']
    )
    puts "Location info: #{location_info} lever"

    job_post_data = {
      job_title: job['text'],
      job_url: job['hostedUrl'],

      job_description: job['descriptionBodyPlain'],
      job_responsibilities: extract_list(job, 'responsibilities:'),
      job_additional: job['additionalPlain'],

      job_posted: JobPost.parse_datetime(job['createdAt']),
      job_updated: JobPost.parse_datetime(job['updatedAt']),

      job_internal_id_string: job['id'],
      job_applyUrl: job['applyUrl'],

      department_id: Department.find_department(job['categories']['department'], 'JobPost',
                                                job['hosted_url']).id,
      team_id: Team.find_team(job['categories']['team'], 'JobPost', job['hosted_url']).id,

      job_commitment_id: JobCommitment.find_job_commitment(job['categories']&.dig('commitment')),
      job_setting: location_info[:location_type] || nil,

      job_salary_min: nil,
      job_salary_max: nil,
      job_salary_single: nil,
      job_salary_currency_id: nil,
      job_salary_interval_id: nil,

      job_role_id: JobRole.find_or_create_job_role(job['text']),
      job_active: true
    }

    updated_by_ai = update_with_ai(job_post_data, job, location_info)

    unless updated_by_ai
      job_post_data[:job_salary_min] ||= job['salaryRange']&.dig('min')
      job_post_data[:job_salary_max] ||= job['salaryRange']&.dig('max')
      job_post_data[:job_salary_single] ||= nil
      job_post_data[:job_salary_currency_id] ||= nil
      job_post_data[:job_salary_interval_id] ||= nil
    end

    job_post_data
  end

  def self.update_with_ai(job_post_data, job, _location_info)
    ai_salary_data = JobPostService.extract_and_save_salary(job)
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

  def self.extract_list(job, key)
    list = job['lists']&.find { |l| l['text'].to_s.downcase.include?(key) }
    return unless list

    list['content'].gsub('</li><li>', "\n").gsub(%r{</?[^>]*>}, '')
  end
end
