# frozen_string_literal: true

# app/mappers/ai_updater.rb

class AiUpdater
  # Updates salary-related fields in the job post data using AI-extracted information.
  #
  # @param job_post_data [Hash] The current job post data.
  # @param job [Hash] The raw job data.
  # @param company [Object] The company object associated with the job.
  # @param location_info [Array<Hash>] Location data extracted from AI.
  # @return [Hash] The updated job post data and related entities.
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

  def self.process_location(name_or_locations, location_type, company, parent = nil, job_post_url = nil)
    return [] if name_or_locations.blank?

    Array(name_or_locations).each_with_object([]) do |name, ids|
      next if name.blank?

      location = Location.find_or_create_by_name_and_type(name, company, location_type, parent,
                                                          job_post_url)
      ids << location.id if location
    end
  end

  def self.update_with_ai(job_post_data, job, company, location_info)
    use_validation = false
    ai_data = use_validation ? JobPostServiceWithValidation.split_descriptions(job) : JobPostService.split_descriptions(job)
    updated = false

    # print_job_post_data(job)
    puts "data from AI: #{ai_data}"

    job_post_benefits = []
    job_post_credentials = []
    job_post_educations = []
    job_post_experiences = []
    job_post_seniorities = []
    job_post_skills = []
    job_post_locations = []
    job_post_data[:job_setting] = Array(job_post_data[:job_setting])

    puts "location info is #{location_info}"

    if location_info.is_a?(Array)
      location_info.each do |location|
        country_ids = process_location(location[:country_name], 'Country', company, nil,
                                       job[:job_url])
        state_ids = if location[:state_name]
                      process_location(location[:state_name], 'State', company,
                                       Location.find(country_ids.first), job[:job_url])
                    else
                      []
                    end
        city_ids = if location[:city_name]
                     process_location(location[:city_name], 'City', company, Location.find(state_ids.first),
                                      job[:job_url])
                   else
                     []
                   end
        puts "country_ids: #{country_ids}"
        puts "state_ids: #{state_ids}"
        puts "city_ids: #{city_ids}"
        location_ids = (country_ids + state_ids + city_ids).uniq
        location_ids.each do |location_id|
          job_post_locations << location_id unless job_post_locations.include?(location_id)
        end
      end
    end

    ai_data.each do |field_data|
      field_data.each do |key, value|
        case key
        when 'description'
          # puts "key is #{key}"
          # puts "value is #{value}"

          if value.is_a?(Hash)
            description = value[:job_description]
            job_role = value[:job_role]
            job_seniorities = value[:job_seniorities]
            job_dept = value[:job_dept]
            job_team = value[:job_team]
            commitment = value[:job_commitment]
            settings = value[:job_settings]

            job_post_data[:job_description] = description if description

            if job_post_data[:job_role_id].nil? && job_role
              job_post_data[:job_role_id] =
                JobRole.find_or_create_job_role(job_role)&.id

              updated = true
            end

            if job_post_data[:team_id].nil? && job_team
              job_post_data[:team_id] =
                Team.find_team(job_team, 'JobPost', job_post_data[:job_url])&.id
              updated = true
            end

            if job_post_data[:department_id].nil? && job_dept
              job_post_data[:department_id] =
                Department.find_department(job_dept, job_post_data[:job_url])&.id
              updated = true
            end

            if job_seniorities
              job_seniorities.each do |job_seniority|
                seniority_id = JobSeniority.find_or_create_seniority(job_seniority,
                                                                     job_post_data).id
                unless job_post_seniorities.include?(seniority_id)
                  job_post_seniorities << seniority_id
                  updated = true
                end
              end
            end

            if job_post_data[:job_commitment_id].nil? && commitment
              commitment_id = JobCommitment.find_job_commitment(commitment).id
              job_post_data[:job_commitment_id] = commitment_id
              updated = true
            end

            settings.each do |setting|
              normalized_setting = setting.downcase

              unless job_post_data[:job_setting].map(&:downcase).include?(normalized_setting)
                job_post_data[:job_setting] << setting
                updated = true
              end
            end

            countries = process_location(value[:job_countries], 'Country', company, nil,
                                         job_post_data[:job_url])
            states = process_location(value[:job_states], 'State', company, countries.first,
                                      job_post_data[:job_url])
            cities = process_location(value[:job_cities], 'City', company, states.first,
                                      job_post_data[:job_url])

            puts "countries: #{countries}"
            puts "states: #{states}"
            puts "cities: #{cities}"
            job_post_locations.concat(countries + states + cities).uniq!
          end
          # puts "description / job post data is #{job_post_data}"

        when 'responsibilities'
          # puts "key is #{key}"
          # puts "value is #{value}"

          if value
            if value.is_a?(Hash) && value[:responsibilities].is_a?(Array)
              job_post_data[:job_responsibilities] = value[:responsibilities]
            elsif value.is_a?(Array) && value.all? { |item| item.is_a?(String) }
              job_post_data[:job_responsibilities] = value
            elsif value.is_a?(String)
              job_post_data[:job_responsibilities] = [value]
            else
              puts "#{RED}Unexpected format for responsibilities value: #{value.inspect}#{RESET}"
            end
            updated = true
          end

          # puts "responsibilities / job post data is #{job_post_data}"

        when 'qualifications'
          # puts "key is #{key}"
          # puts "value is #{value}"

          if value.is_a?(Hash)
            qualifications = value[:qualifications]
            credentials = value[:credentials]
            education = value[:education]
            experience = value[:experience]

            if qualifications
              if qualifications.is_a?(Array) && qualifications.all? { |item| item.is_a?(String) }
                job_post_data[:job_qualifications] ||= []
                job_post_data[:job_qualifications].concat(qualifications)
                updated = true
              else
                puts "#{RED}Unexpected format for qualifications: #{qualifications.inspect}#{RESET}"
              end
            end

            if credentials
              credentials.each do |credential|
                credential_id = Credential.find_or_create_credential(credential,
                                                                     job_post_data)&.id
                job_post_credentials << credential_id if credential_id
                updated = true
              end
            end

            if education
              education.each do |edu|
                education_id = Education.find_or_create_education(edu,
                                                                  job_post_data)&.id
                job_post_educations << education_id if education_id
                updated = true
              end
            end

            if experience
              experience.each do |exp|
                experience_id = Experience.find_or_create_experience(exp,
                                                                     job_post_data)&.id
                job_post_experiences << experience_id if experience_id
                updated = true
              end
            end
          end
          # puts "qualifications / job post data is #{job_post_data}"

        when 'benefits'
          # puts "key is #{key}"
          # puts "value is #{value}"

          settings = value[:job_settings]
          commitment = value[:commitment]

          benefits = [
            value[:compensation],
            value[:retirement],
            value[:office_life],
            value[:professional_development],
            value[:wellness],
            value[:parental],
            value[:work_life_balance],
            value[:visa_sponsorship],
            value[:additional_perks]
          ].compact # remove nil values

          # job_post_benefits.concat(benefits)

          settings.each do |setting|
            normalized_setting = setting.downcase

            unless job_post_data[:job_setting].map(&:downcase).include?(normalized_setting)
              job_post_data[:job_setting] << setting
              updated = true
            end
          end

          countries = process_location(value[:job_countries], 'Country', company, nil,
                                       job_post_data[:job_url])
          states = process_location(value[:job_states], 'State', company, countries.first,
                                    job_post_data[:job_url])
          cities = process_location(value[:job_cities], 'City', company, states.first,
                                    job_post_data[:job_url])

          puts "countries: #{countries}"
          puts "states: #{states}"
          puts "cities: #{cities}"
          job_post_locations.concat(countries + states + cities).uniq!

          if commitment
            commitment_id = JobCommitment.find_job_commitment(commitment).id
            unless job_post_data[:job_commitment_id] == commitment_id
              job_post_data[:job_commitment_id] = commitment_id
              updated = true
            end
          end

          benefits&.each do |benefit_name|
            benefit = Benefit.find_or_create_benefit(benefit_name, company)&.id
            job_post_benefits << benefit if benefit
            updated = true
          end

          # puts "benefits / job post data is #{job_post_data}"

        when 'salary'
          # puts "key is #{key}"
          # puts "value is #{value}"

          salary_min = value[:job_salary_min]
          salary_max = value[:job_salary_max]
          salary_single = value[:job_salary_single]
          currency = value[:job_salary_currency]
          interval = value[:job_salary_interval]
          commitment = value[:job_commitment]

          if salary_min
            job_post_data[:job_salary_min] = salary_min
            updated = true
          end

          if salary_max
            job_post_data[:job_salary_max] = salary_max
            updated = true
          end

          if salary_single
            job_post_data[:job_salary_single] = salary_single
            updated = true
          end

          if currency
            currency_id = JobSalaryCurrency.find_or_adjudicate_currency(
              currency, company.id, job_post_data[:job_url]
            )
            unless job_post_data[:job_salary_currency_id] == currency_id
              job_post_data[:job_salary_currency_id] = currency_id
              updated = true
            end
          end

          if interval
            interval_id = JobSalaryInterval.find_by(interval: interval)
            unless job_post_data[:job_salary_interval_id] == interval_id
              job_post_data[:job_salary_interval_id] = interval_id
              updated = true
            end
          end

          if commitment
            commitment_id = JobCommitment.find_job_commitment(commitment)&.id
            unless job_post_data[:job_commitment_id] == commitment_id
              job_post_data[:job_commitment_id] = commitment_id
              updated = true
            end
          end

          countries = process_location(value[:job_post_countries], 'Country', company, nil,
                                       job_post_data[:job_url])
          job_post_locations.concat(countries).uniq!

          # puts "salary / job post data is #{job_post_data}"

        else
          puts "#{RED}Unexpected key: #{key}.#{RESET}"
        end
      end
    end

    {
      job_post_data: job_post_data,
      job_post_benefits: job_post_benefits,
      job_post_credentials: job_post_credentials,
      job_post_educations: job_post_educations,
      job_post_experiences: job_post_experiences,
      job_post_seniorities: job_post_seniorities,
      job_post_skills: job_post_skills,
      job_post_locations: job_post_locations
    }
  end
end
