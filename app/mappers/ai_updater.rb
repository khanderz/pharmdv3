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

          description = value[:job_description]
          role = value[:job_role]

          #  need to populate to seniority table not job post table
          if value[:job_seniority]
            seniority_id = JobSeniority.find_by_name(value[:job_seniority]).id
          end
          dept = value[:job_dept]
          if value[:job_team]
            job_post_data[:team_id] =
              Team.find_team(value[:job_team], 'JobPost',
                             job_post_data[:job_url]).id
          end
          commitment = value[:job_commitment]
          setting = value[:job_setting]
          country = value[:job_country]
          city = value[:job_city]
          state = value[:job_state]
        when 'responsibilities'
          if job_post_data[:responsibilities].to_s.empty?
            job_post_data[:responsibilities] = value
          else
            unless job_post_data[:responsibilities].end_with?(' ')
              job_post_data[:responsibilities] += ' '
            end
            job_post_data[:responsibilities] += value
          end
        when 'qualifications'
          job_post_data[:job_qualifications] ||= ''
          credentials = value[:credentials]
          education = value[:education]
          experience = value[:experience]
        when 'benefits'
          commitment = value[:commitment]
          setting = value[:setting]
          country = value[:country]
          city = value[:city]
          state = value[:state]
          compensation = value[:compensation]
          retirement = value[:retirement]
          office_life = value[:office_life]
          professional_development = value[:professional_development]
          wellness = value[:wellness]
          parental = value[:parental]
          work_life_balance = value[:work_life_balance]
          visa_sponsorship = value[:visa_sponsorship]
          additional_perks = value[:additional_perks]
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
