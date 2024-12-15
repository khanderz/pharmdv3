# frozen_string_literal: true

# app/mappers/ai_updater.rb

class AiUpdater
  # Updates salary-related fields in the job post data using AI-extracted information.
  #
  # @param job_post_data [Hash] The current job post data.
  # @param job [Hash] The raw job data.
  # @param company [Object] The company object associated with the job.
  # @return [Boolean] True if the job post data was updated, otherwise false.
  def self.print_job_post_data(job_post_data)
    puts "\n--- Job Post Data in ai updater class ---"
    puts "Company ID: #{job_post_data[:company_id]}"
    puts "Job Title: #{job_post_data[:job_title]}"
    puts "Job URL: #{job_post_data[:job_url]}"
    puts "Apply URL: #{job_post_data[:job_applyUrl]}"
    puts "Job Description: #{job_post_data[:job_description] || 'N/A'}"
    puts "Job Responsibilities: #{job_post_data[:job_responsibilities]}"
    puts " job_additional: #{job_post_data[:job_additional] || 'N/A'}"
    puts "Job Posted Date: #{job_post_data[:job_posted] || 'N/A'}"
    puts "Job Updated Date: #{job_post_data[:job_updated]}"
    puts "Job Internal ID: #{job_post_data[:job_internal_id]}"
    puts "Job URL ID: #{job_post_data[:job_url_id]}"
    puts "Department ID: #{job_post_data[:department_id]}"
    puts "Team ID: #{job_post_data[:team_id] || 'N/A'}"
    puts "Job Setting: #{job_post_data[:job_setting]}"
    puts "Job Salary Min: #{job_post_data[:job_salary_min] || 'N/A'}"
    puts "Job Salary Max: #{job_post_data[:job_salary_max] || 'N/A'}"
    puts "Job Salary Currency ID: #{job_post_data[:job_salary_currency_id] || 'N/A'}"
    puts "Job Salary Interval ID: #{job_post_data[:job_salary_interval_id] || 'N/A'}"
    puts "Job Role ID: #{job_post_data[:job_role_id]}"
    puts "Job Active: #{job_post_data[:job_active] ? 'Yes' : 'No'}"
    puts "job salary single: #{job_post_data[:job_salary_single]}"
    puts "job commitment id #{job_post_data[:job_commitment_id]}"
    puts '--- End of Job Post Data ---'
  end

  def self.update_with_ai(job_post_data, job, company)
    ai_data = JobPostService.split_descriptions(job)
    updated = false

    print_job_post_data(job_post_data)
    puts "data from AI: #{ai_data}"

    job_post_benefits = []
    job_post_cities = []
    job_post_countries = []
    job_post_credentials = []
    job_post_educations = []
    job_post_experiences = []
    job_post_seniorities = []
    job_post_skills = []
    job_post_states = []

    ai_data.each do |field_data|
      field_data.each do |key, value|
        case key
        when 'description'
          puts "key is #{key}"
          puts "value is #{value}"

          if value.is_a?(Hash)
            description = value[:job_description]
            job_role = value[:job_role]
            job_seniority = value[:job_seniority]
            job_dept = value[:job_dept]
            job_team = value[:job_team]
            commitment = value[:job_commitment]
            setting = value[:job_setting]
            country = value[:job_country]
            city = value[:job_city]
            state = value[:job_state]

            job_post_data[:job_description] = description if description

            if job_post_data[:job_role_id].nil? && job_role
              job_post_data[:job_role_id] =
                JobRole.find_or_create_job_role(job_role, job_post_data[:job_url])&.id
            end

            if job_post_data[:team_id].nil? && job_team
              job_post_data[:team_id] =
                Team.find_team(job_team, 'JobPost', job_post_data[:job_url])&.id
            end

            if job_post_data[:department_id].nil? && job_dept
              job_post_data[:department_id] =
                Department.find_department(job_dept, 'JobPost', job_post_data[:job_url])&.id
            end

            if job_seniority
              seniority_id = JobSeniority.find_by_name(job_seniority).id
              job_post_seniorities << seniority if seniority
            end

            if job_post_data[:job_commitment_id].nil? && commitment
              commitment_id = JobCommitment.find_job_commitment(commitment).id
              job_post_data[:job_commitment_id] = commitment_id
            end

            job_post_data[:job_settings].push(setting).uniq! if setting

            if country
              country_id = Country.find_or_adjudicate_country(
                country_code: nil, country_name: country, company_id: company.id, job_url: job_post_data[:job_url]
              ).id
              job_post_countries << country if country
            end

            if city
              city_id = City.find_city(city, job_post_data[:job_url], company).id
              job_post_cities << city if city
            end

            if state
              state_id = State.find_state(state, job_post_data[:job_url], company).id
              job_post_states << state if state
            end
          end
          puts "description / job post data is #{job_post_data}"

        when 'responsibilities'
          puts "key is #{key}"
          puts "value is #{value}"

          responsibilities = value[:responsibilities]
          job_post_data[:job_responsibilities] = responsibilities

          puts "responsibilities / job post data is #{job_post_data}"

        when 'qualifications'
          #           JOB_QUALIFICATION_ENTITY_LABELS = [
          #     "QUALIFICATIONS",
          #     "CREDENTIALS",
          #     "EDUCATION",
          #     "EXPERIENCE",
          # ]
          puts "key is #{key}"
          puts "value is #{value}"

          if value.is_a?(Hash)
            qualifications = value[:qualifications]
            credentials = value[:credentials]
            education = value[:education]
            experience = value[:experience]

            job_post_data[:job_qualifications] = qualifications if qualifications

            if credentials
              credentials.each do |credential|
                credential_id = Credential.find_or_create_credential(credential,
                                                                     job_post_data[:job_url])&.id
                job_post_credentials << credential_id if credential_id
              end
            end

            if education
              education.each do |edu|
                education_id = Education.find_or_create_education(edu,
                                                                  job_post_data[:job_url])&.id
                job_post_educations << education_id if education_id
              end
            end

            if experience
              experience.each do |exp|
                experience_id = Experience.find_or_create_experience(exp,
                                                                     job_post_data[:job_url])&.id
                job_post_experiences << experience_id if experience_id
              end
            end
          end
          puts "qualifications / job post data is #{job_post_data}"

        when 'benefits'
          #           JOB_BENEFIT_ENTITY_LABELS = [
          #     "COMMITMENT",
          #     "JOB_SETTING",
          #     "JOB_COUNTRY",
          #     "JOB_CITY",
          #     "JOB_STATE",
          #     "COMPENSATION",
          #     "RETIREMENT",
          #     "OFFICE_LIFE",
          #     "PROFESSIONAL_DEVELOPMENT",
          #     "WELLNESS",
          #     "PARENTAL",
          #     "WORK_LIFE_BALANCE",
          #     "VISA_SPONSORSHIP",
          #     "ADDITIONAL_PERKS",
          # ]
          puts "key is #{key}"
          puts "value is #{value}"
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
          puts "benefits / job post data is #{job_post_data}"

        when 'salary'
          #           SALARY_ENTITY_LABELS = [
          #     "SALARY_MIN",
          #     "SALARY_MAX",
          #     "SALARY_SINGLE",
          #     "CURRENCY",
          #     "INTERVAL",
          #     "COMMITMENT",
          #     "JOB_COUNTRY",
          # ]
          puts "key is #{key}"
          puts "value is #{value}"
          if value[:job_salary_min]
            job_post_data[:job_salary_min] =
              value[:job_salary_min]
          end
          if value[:job_salary_max]
            job_post_data[:job_salary_max] =
              value[:job_salary_max]
          end
          if value[:job_salary_single]
            job_post_data[:job_salary_single] =
              value[:job_salary_single]
          end

          currency_id = if value[:job_salary_currency]
                          JobSalaryCurrency.find_or_adjudicate_currency(
                            value[:job_salary_currency], company.id, job_post_data[:job_url]
                          )
                        end
          interval_id = value[:job_salary_interval] ? JobSalaryInterval.find_by(interval: value[:job_salary_interval]) : nil

          job_post_data[:job_salary_currency_id] = currency_id
          job_post_data[:job_salary_interval_id] = interval_id
          updated = true
          puts "salary / job post data is #{job_post_data}"

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

    puts "job post data is #{job_post_data}"
    puts "job post benefits is #{job_post_benefits}"
    puts "job post cities is #{job_post_cities}"
    puts "job post countries is #{job_post_countries}"
    puts "job post credentials is #{job_post_credentials}"
    puts "job post educations is #{job_post_educations}"
    puts "job post experiences is #{job_post_experiences}"
    puts "job post seniorities is #{job_post_seniorities}"
    puts "job post skills is #{job_post_skills}"
    puts "job post states is #{job_post_states}"

    {
      job_post_data: job_post_data,
      job_post_benefits: job_post_benefits,
      job_post_cities: job_post_cities,
      job_post_countries: job_post_countries,
      job_post_credentials: job_post_credentials,
      job_post_educations: job_post_educations,
      job_post_experiences: job_post_experiences,
      job_post_seniorities: job_post_seniorities,
      job_post_skills: job_post_skills,
      job_post_states: job_post_states
    }
  end
end
