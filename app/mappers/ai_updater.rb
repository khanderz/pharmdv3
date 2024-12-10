# frozen_string_literal: true

# app/mappers/ai_updater.rb

class AiUpdater
  # Updates salary-related fields in the job post data using AI-extracted information.
  #
  # @param job_post_data [Hash] The current job post data.
  # @param job [Hash] The raw job data.
  # @param company [Object] The company object associated with the job.
  # @return [Boolean] True if the job post data was updated, otherwise false.
  def self.update_with_ai(job_post_data, job, company)
    ai_data = JobPostService.split_descriptions(job)
    updated = false

    ai_data.each do |field_data|
      field_data.each do |key, value|
        case key
        when 'description', 'summary'
          job_post_data[:job_description] ||= ''
          job_post_data[:job_description] += ' ' unless job_post_data[:job_description].empty?
          job_post_data[:job_description] += value
        when 'responsibilities'
          if job_post_data[:responsibilities].to_s.empty?
            job_post_data[:responsibilities] = value
          else
            job_post_data[:responsibilities] += " " unless job_post_data[:responsibilities].end_with?(" ")
            job_post_data[:responsibilities] += value
          end
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

