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

    updated_by_ai = update_with_ai(job_post_data, job, company)

    unless updated_by_ai
      job_post_data[:job_salary_min] ||= job['salaryRange']&.dig('min')
      job_post_data[:job_salary_max] ||= job['salaryRange']&.dig('max')
      job_post_data[:job_salary_single] ||= nil
      job_post_data[:job_salary_currency_id] ||= nil
      job_post_data[:job_salary_interval_id] ||= nil
    end

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
          puts "Debugging key: #{key}, value: #{value}"
          job_post_data[:job_description] ||= ''
          job_post_data[:job_description] += ' ' unless job_post_data[:job_description].empty?
          job_post_data[:job_description] += value
        else
          puts "#{RED}Unexpected key: #{key}.#{RESET}"
        end
      end
    end

    updated
  end

  def self.extract_list(job, key)
    list = job['lists']&.find { |l| l['text'].to_s.downcase.include?(key) }
    return unless list

    list['content'].gsub('</li><li>', "\n").gsub(%r{</?[^>]*>}, '')
  end
end
