# frozen_string_literal: true

require 'open3'
require 'json'
require 'base64'

class JobPostServiceWithValidation
  def self.split_descriptions(job_post)
    puts "#{BLUE}Preprocessing job description...#{RESET}"
    # puts "job post: #{job_post}"
    structured_data = preprocess_job_description(job_post['content'])
    puts "structured_data: #{structured_data}"
    unless structured_data
      puts "#{RED}Failed to preprocess job description.#{RESET}"
      return
    end

    data_return = []

    description = structured_data['description']
    summary = structured_data['summary']
    responsibilities = structured_data['responsibilities']
    qualifications = structured_data['qualifications']
    benefits = structured_data['benefits'].empty? ? qualifications : structured_data['benefits']

    data_return << { 'description' => description } if description
    # puts "data return / description: #{data_return}"

    processed_description = extract_descriptions(summary)
    data_return << { 'description' => processed_description } if processed_description

    puts "data return / processed_description: #{data_return}"

    if summary
      description_object = data_return.find { |item| item.key?('description') }
      if description_object && description_object['description'].is_a?(Hash)
        description_object['description'][:job_description] ||= summary
      end
    end

    puts "data return  / summary: #{data_return}"

    processed_responsibilities = extract_responsibilities(responsibilities)
    data_return << { 'responsibilities' => processed_responsibilities || responsibilities }

    puts "data return / responsibilities : #{data_return}"

    processed_qualifications = extract_qualifications(qualifications)
    data_return << { 'qualifications' => processed_qualifications } if processed_qualifications
    # puts "data return / qualifications: #{data_return}"

    processed_benefits = extract_benefits(benefits)
    data_return << { 'benefits' => processed_benefits } if processed_benefits

    # puts "data return /benefits : #{data_return}"
    if processed_benefits[:job_compensation]
      salary_data = extract_salary(processed_benefits[:job_compensation])
      data_return << { 'salary' => salary_data } if salary_data
    end
    # puts "data return / salary / final : #{data_return}"

    data_return
  end

  def self.preprocess_job_description(job_description)
    puts "#{BLUE}Running description splitter...#{RESET}"
    # puts "job_description: #{job_description}"

    python_script_path = 'app/python/ai_processing/utils/description_splitter.py'
    input_json = { text: job_description }.to_json
    encoded_data = Base64.strict_encode64(input_json)
    command = "python3 #{python_script_path} '#{encoded_data}'"

    stdout, stderr, status = Open3.capture3(command)

    if status.success? && !stdout.strip.empty?
      begin
        result = JSON.parse(stdout)
        return result
      rescue JSON::ParserError => e
        puts "#{RED}Error parsing JSON from description splitter: #{e.message}#{RESET}"
      end
    else
      puts "#{RED}Error running description splitter: #{stderr} (Status: #{status.exitstatus})#{RESET}"
    end

    nil
  end

  def self.extract_descriptions(summary)
    puts "#{BLUE}Extracting descriptions...#{RESET}"
    # puts "Summary: #{summary}"
    description_data = call_inspect_predictions(
      attribute_type: 'job_description',
      input_text: summary,
      predict: true
    )
    # puts "description_data: #{description_data}"

    parsed_descriptions = description_data['entities']
    # puts "parsed_descriptions: #{parsed_descriptions}"
    corrected_descriptions = validate_and_update_training_data(summary, parsed_descriptions,
                                                               'job_description')

    if description_data['status'] == 'success' && corrected_descriptions.any?
      job_post_object = {
        job_description: nil,
        job_role: nil,
        job_seniorities: [],
        job_dept: nil,
        job_team: nil,
        job_commitment: nil,
        job_settings: [],
        job_countries: [],
        job_cities: [],
        job_states: []
      }

      corrected_descriptions.each do |entity|
        case entity['label']
        when 'DESCRIPTION'
          job_post_object[:job_description] = entity['token']
        when 'JOB_ROLE'
          job_post_object[:job_role] = entity['token']
        when 'JOB_SENIORITY'
          unless job_post_object[:job_seniorities].include?(entity['token'])
            job_post_object[:job_seniorities] << entity['token']
          end
        when 'JOB_DEPT'
          job_post_object[:job_dept] = entity['token']
        when 'JOB_TEAM'
          job_post_object[:job_team] = entity['token']
        when 'JOB_COMMITMENT'
          job_post_object[:job_commitment] = entity['token']
        when 'JOB_SETTING'
          unless job_post_object[:job_settings].include?(entity['token'])
            job_post_object[:job_settings] << entity['token']
          end
        when 'JOB_COUNTRY'
          unless job_post_object[:job_countries].include?(entity['token'])
            job_post_object[:job_countries] << entity['token']
          end
        when 'JOB_CITY'
          unless job_post_object[:job_cities].include?(entity['token'])
            job_post_object[:job_cities] << entity['token']
          end
        when 'JOB_STATE'
          unless job_post_object[:job_states].include?(entity['token'])
            job_post_object[:job_states] << entity['token']
          end
        else
          puts "#{RED}Unexpected label: #{entity['label']}#{RESET}"
        end
      end
    else
      puts "#{ORANGE}No entities, skipping.#{RESET}"
      job_post_object = nil
    end
    job_post_object
  end

  def self.extract_responsibilities(responsibilities)
    puts "#{BLUE}Extracting responsibilities...#{RESET}"

    responsibilities_data = call_inspect_predictions(
      attribute_type: 'job_responsibilities',
      input_text: responsibilities,
      predict: true
    )

    # puts "responsibilities_data: #{responsibilities_data}"

    parsed_responsibilities = responsibilities_data['entities']

    corrected_responsibilities = validate_and_update_training_data(responsibilities,
                                                                   parsed_responsibilities, 'job_responsibilities')

    if responsibilities_data['status'] == 'success' && corrected_responsibilities.any?
      job_post_object = {
        responsibilities: []
      }

      corrected_responsibilities.each do |entity|
        case entity['label']
        when 'RESPONSIBILITIES'
          job_post_object[:responsibilities] << entity['token']
        else
          puts "#{RED}Unexpected label: #{entity['label']}#{RESET}"
        end
      end
    else
      puts "#{ORANGE}No entities, skipping.#{RESET}"
      job_post_object = nil
    end
    job_post_object
  end

  def self.extract_qualifications(qualifications)
    puts "#{BLUE}Extracting qualifications ...#{RESET}"

    qualification_data = call_inspect_predictions(
      attribute_type: 'job_qualifications',
      input_text: qualifications,
      predict: true
    )

    parsed_qualifications = qualification_data['entities']

    corrected_qualifications = validate_and_update_training_data(qualifications,
                                                                 parsed_qualifications, 'job_qualifications')

    if qualification_data['status'] == 'success' && corrected_qualifications.any?
      job_post_object = {
        qualifications: [],
        credentials: [],
        education: [],
        experience: []
      }

      corrected_qualifications.each do |entity|
        case entity['label']
        when 'QUALIFICATIONS'
          job_post_object[:qualifications] << entity['token']
        when 'CREDENTIALS'
          job_post_object[:credentials] << entity['token']
        when 'EDUCATION'
          job_post_object[:education] << entity['token']
        when 'EXPERIENCE'
          job_post_object[:experience] << entity['token']
        else
          puts "#{RED}Unexpected label: #{entity['label']}#{RESET}"
        end
      end
    else
      puts "#{ORANGE}No entities, skipping.#{RESET}"
      job_post_object = nil
    end
    job_post_object
  end

  def self.extract_benefits(benefits)
    puts 'Starting validation for benefits...'

    benefits_data = call_inspect_predictions(
      attribute_type: 'job_benefits',
      input_text: benefits,
      predict: true
    )

    parsed_benefits = benefits_data['entities']
    corrected_benefits = validate_and_update_training_data(benefits, parsed_benefits,
                                                           'job_benefits')

    if benefits_data['status'] == 'success' && corrected_benefits.any?

      job_post_object = {
        commitment: nil,
        job_settings: [],
        job_countries: [],
        job_cities: [],
        job_states: [],
        job_compensation: nil,
        retirement: nil,
        office_life: nil,
        professional_development: nil,
        wellness: nil,
        parental: nil,
        work_life_balance: nil,
        visa_sponsorship: nil,
        additional_perks: nil,
      }

      corrected_benefits.each do |entity|
        case entity['label']
        when 'COMMITMENT'
          job_post_object[:commitment] = entity['token']
        when 'JOB_SETTING'
          unless job_post_object[:job_settings].include?(entity['token'])
            job_post_object[:job_settings] << entity['token']
          end
        when 'JOB_COUNTRY'
          unless job_post_object[:job_countries].include?(entity['token'])
            job_post_object[:job_countries] << entity['token']
          end
        when 'JOB_CITY'
          unless job_post_object[:job_cities].include?(entity['token'])
            job_post_object[:job_cities] << entity['token']
          end
        when 'JOB_STATE'
          unless job_post_object[:job_states].include?(entity['token'])
            job_post_object[:job_states] << entity['token']
          end
        when 'COMPENSATION'
          job_post_object[:job_compensation] = entity['token']
        when 'RETIREMENT'
          job_post_object[:retirement] = entity['token']
        when 'OFFICE_LIFE'
          job_post_object[:office_life] = entity['token']
        when 'PROFESSIONAL_DEVELOPMENT'
          job_post_object[:professional_development] = entity['token']
        when 'WELLNESS'
          job_post_object[:wellness] = entity['token']
        when 'PARENTAL'
          job_post_object[:parental] = entity['token']
        when 'WORK_LIFE_BALANCE'
          job_post_object[:work_life_balance] = entity['token']
        when 'VISA_SPONSORSHIP'
          job_post_object[:visa_sponsorship] = entity['token']
        when 'ADDITIONAL_PERKS'
          job_post_object[:additional_perks] = entity['token']
        else
          puts "#{RED}Unexpected label: #{entity['label']}#{RESET}"
        end
      end
    else
      puts "#{ORANGE}No entities, skipping.#{RESET}"
      job_post_object = nil
    end
    job_post_object
  end

  def self.extract_salary(salary)
    puts 'Starting validation for benefits...'

    # puts "Salary: #{salary}"
    compensation_data = call_inspect_predictions(
      attribute_type: 'salary',
      input_text: salary,
      predict: true
    )

    corrected_compensation_data = validate_and_update_training_data(salary,
                                                                    compensation_data['entities'], 'salary')

    job_post_object = {
      job_salary_min: nil,
      job_salary_max: nil,
      job_salary_single: nil,
      job_salary_currency: nil,
      job_salary_interval: nil,
      job_commitment: nil,
      job_post_countries: []
    }
    if compensation_data['status'] == 'success' && corrected_compensation_data.any?
      corrected_compensation_data.each do |entity|
        case entity['label']
        when 'SALARY_MIN'
          job_post_object[:job_salary_min] = entity['token'].gsub(',', '').to_i
        when 'SALARY_MAX'
          job_post_object[:job_salary_max] = entity['token'].gsub(',', '').to_i
        when 'SALARY_SINGLE'
          job_post_object[:job_salary_single] = entity['token'].gsub(',', '').to_i
        when 'CURRENCY'
          job_post_object[:job_salary_currency] = entity['token']
        when 'INTERVAL'
          job_post_object[:job_salary_interval] = entity['token']
        when 'COMMITMENT'
          job_post_object[:job_commitment] = entity['token']
        when 'JOB_COUNTRY'
          job_post_object[:job_post_countries] << entity['token'] if entity['token']
        else
          puts "#{RED}Unexpected label: #{entity['label']}#{RESET}"
        end
      end
    else
      puts "#{ORANGE}No entities, skipping.#{RESET}"
      job_post_object = nil
    end
    job_post_object
  end

  TOKEN_COLOR = "\e[32m"
  LABEL_COLOR = "\e[33m"
  RESET = "\e[0m"

  def self.validate_and_update_training_data(input_text, extracted_entities, entity_type)
    puts "#{BLUE}Validating #{entity_type} entities...#{RESET}"

    training_data_path = "app/python/ai_processing/#{entity_type}/data/train_data_spacy.json"
    training_data = []
    training_data = JSON.parse(File.read(training_data_path)) if File.exist?(training_data_path)

    text = clean_text(input_text)
    print_indices(entity_type, text)

    label_list = get_labels_from_python(entity_type)
    if label_list.empty?
      puts "#{RED}Failed to get label for entity type: #{entity_type}#{RESET}"
      return []
    end

    validation_attempts = 0
    max_attempts = 3
    corrections_exist = false

    tokens_is_array = extracted_entities.any? do |_, tokens|
      tokens.is_a?(Array) && tokens.size > 1
    end

    puts "tokens_is_array: #{tokens_is_array}"

    if tokens_is_array
      puts ' --------- 1 tokens are array'
      puts " extracted_entities: #{extracted_entities}"
      puts "extracted_entities length: #{extracted_entities.length}"

      loop do
        corrected_entities = []
        corrections_exist = false

        extracted_entities.each_with_index do |(label, tokens), _index|
          puts "tokens : #{tokens}"
          puts "tokens.length: #{tokens.length}"

          Array(tokens).each do |token|
            puts "token : #{token}"
            label = label.to_s

            puts "Is token #{TOKEN_COLOR}'#{token}'#{RESET} for label #{LABEL_COLOR}'#{label}'#{RESET} correct? (yes/no)"
            token_confirmation = gets.strip.downcase
            if token_confirmation != 'yes' && token_confirmation != 'y'
              puts 'Enter the correct token:'
              token = gets.strip
              corrections_exist = true
            end

            puts "Is the label #{LABEL_COLOR}'#{label}'#{RESET} for token #{TOKEN_COLOR}'#{token}'#{RESET} correct? (yes/no)"
            label_confirmation = gets.strip.downcase
            if label_confirmation != 'yes' && label_confirmation != 'y'
              puts "Select the correct label for this token #{TOKEN_COLOR}'#{token}'#{RESET}:"
              label_list.each_with_index do |lbl, idx|
                puts "#{idx}: #{lbl}"
              end
              label_index = gets.strip.to_i
              label = label_list[label_index] if label_index >= 0 && label_index < label_list.size
              corrections_exist = true
            end

            if corrections_exist
              puts "Enter start index for #{TOKEN_COLOR}'#{token}'#{RESET}:"
              start_value = gets.strip.to_i

              puts "Enter end index for #{TOKEN_COLOR}'#{token}'#{RESET}:"
              end_value = gets.strip.to_i
            end

            corrected_entities << {
              'start' => start_value,
              'end' => end_value,
              'label' => label,
              'token' => token
            }
          end
        end

        loop do
          puts 'Are there any missing entities? (yes/no)'
          missing_entities_confirmation = gets.strip.downcase

          break if missing_entities_confirmation != 'yes' && missing_entities_confirmation != 'y'

          puts 'Enter the token for the missing entity:'
          token = gets.strip

          puts "Select the correct label for this token #{TOKEN_COLOR}'#{token}'#{RESET}:"
          label_list.each_with_index do |lbl, idx|
            puts "#{idx}: #{lbl}"
          end
          label_index = gets.strip.to_i
          label = label_list[label_index] if label_index >= 0 && label_index < label_list.size

          puts "Enter start index for #{TOKEN_COLOR}'#{token}'#{RESET}:"
          start_value = gets.strip.to_i

          puts "Enter end index for #{TOKEN_COLOR}'#{token}'#{RESET}:"
          end_value = gets.strip.to_i

          corrected_entities << {
            'start' => start_value,
            'end' => end_value,
            'label' => label,
            'token' => token
          }

          corrections_exist = true
        end

        new_training_data = {
          'text' => text,
          'entities' => corrected_entities
        }

        if corrections_exist == false
          puts "#{ORANGE}No entities to validate. Skipping validation and proceeding to next step.#{RESET}"
          return corrected_entities
        end

        puts "#{BLUE}Validating entities...#{RESET}"
        validation_result = call_inspect_predictions(
          attribute_type: entity_type,
          input_text: input_text,
          validate: [new_training_data]
        )

        if validation_result && validation_result['status'] == 'success'
          puts "validation result on rb : #{validation_result}"
          message = validation_result['message'].to_s.strip
          puts "#{GREEN}Validation completed successfully: #{message}#{RESET}"

          if message.include?('Validation passed for all entities.')
            training_data << new_training_data
            File.write(training_data_path, JSON.pretty_generate(training_data))
            puts "#{GREEN}Training data validated and saved successfully at #{training_data_path}.#{RESET}"
            return corrected_entities
          else
            puts "#{RED}Validation completed with warnings: #{message}#{RESET}"
          end
        else
          puts "#{RED}Validation failed: #{validation_result&.dig('message') || 'Unknown error'}#{RESET}"
        end

        validation_attempts += 1
        break if validation_attempts >= max_attempts

        puts 'Would you like to redo the corrections? (yes/no)'
        redo_correction = gets.strip.downcase
        break unless %w[yes y].include?(redo_correction)
      end
    else
      puts ' --------- 2 tokens are not array'
      puts " extracted_entities: #{extracted_entities}"
      puts "extracted_entities length: #{extracted_entities.length}"

      loop do
        corrected_entities = []
        corrections_exist = false

        extracted_entities.each_with_index do |(label, tokens), _index|
          label = label.to_s
          token = tokens[0]

          puts "Is token #{TOKEN_COLOR}'#{token}'#{RESET} for label #{LABEL_COLOR}'#{label}'#{RESET} correct? (yes/no)"
          token_confirmation = gets.strip.downcase
          if token_confirmation != 'yes' && token_confirmation != 'y'
            puts 'Enter the correct token:'
            token = gets.strip
            corrections_exist = true
          end

          puts "Is the label #{LABEL_COLOR}'#{label}'#{RESET} for token #{TOKEN_COLOR}'#{token}'#{RESET} correct? (yes/no)"
          label_confirmation = gets.strip.downcase
          if label_confirmation != 'yes' && label_confirmation != 'y'
            puts "Select the correct label for this token #{TOKEN_COLOR}'#{token}'#{RESET}:"
            label_list.each_with_index do |lbl, idx|
              puts "#{idx}: #{lbl}"
            end
            label_index = gets.strip.to_i
            label = label_list[label_index] if label_index >= 0 && label_index < label_list.size
            corrections_exist = true
          end

          if corrections_exist
            puts "Enter start index for #{TOKEN_COLOR}'#{token}'#{RESET}:"
            start_value = gets.strip.to_i

            puts "Enter end index for #{TOKEN_COLOR}'#{token}'#{RESET}:"
            end_value = gets.strip.to_i
          end

          corrected_entities << {
            'start' => start_value,
            'end' => end_value,
            'label' => label,
            'token' => token
          }
        end

        loop do
          puts 'Are there any missing entities? (yes/no)'
          missing_entities_confirmation = gets.strip.downcase

          break if missing_entities_confirmation != 'yes' && missing_entities_confirmation != 'y'

          puts 'Enter the token for the missing entity:'
          token = gets.strip

          puts "Select the correct label for this token #{TOKEN_COLOR}'#{token}'#{RESET}:"
          label_list.each_with_index do |lbl, idx|
            puts "#{idx}: #{lbl}"
          end
          label_index = gets.strip.to_i
          label = label_list[label_index] if label_index >= 0 && label_index < label_list.size

          puts "Enter start index for #{TOKEN_COLOR}'#{token}'#{RESET}:"
          start_value = gets.strip.to_i

          puts "Enter end index for #{TOKEN_COLOR}'#{token}'#{RESET}:"
          end_value = gets.strip.to_i

          corrected_entities << {
            'start' => start_value,
            'end' => end_value,
            'label' => label,
            'token' => token
          }

          corrections_exist = true
        end

        new_training_data = {
          'text' => text,
          'entities' => corrected_entities
        }

        if corrections_exist == false
          puts "#{ORANGE}No entities to validate. Skipping validation and proceeding to next step.#{RESET}"
          return corrected_entities
        end

        puts "#{BLUE}Validating entities...#{RESET}"
        validation_result = call_inspect_predictions(
          attribute_type: entity_type,
          input_text: input_text,
          validate: [new_training_data]
        )

        if validation_result && validation_result['status'] == 'success'
          puts "validation result on rb : #{validation_result}"
          message = validation_result['message'].to_s.strip
          puts "#{GREEN}Validation completed successfully: #{message}#{RESET}"

          if message.include?('Validation passed for all entities.')
            training_data << new_training_data
            File.write(training_data_path, JSON.pretty_generate(training_data))
            puts "#{GREEN}Training data validated and saved successfully at #{training_data_path}.#{RESET}"
            return corrected_entities
          else
            puts "#{RED}Validation completed with warnings: #{message}#{RESET}"
          end
        else
          puts "#{RED}Validation failed: #{validation_result&.dig('message') || 'Unknown error'}#{RESET}"
          return corrected_entities
        end

        validation_attempts += 1
        break if validation_attempts >= max_attempts

        puts 'Would you like to redo the corrections? (yes/no)'
        redo_correction = gets.strip.downcase
        break unless %w[yes y].include?(redo_correction)
      end
      corrected_entities
    end

    puts "#{RED}Validation failed after #{max_attempts} attempts. Exiting...#{RESET}"
    corrected_entities
  end

  def self.call_inspect_predictions(attribute_type:, input_text:, validate: nil, predict: false, train: false, data: nil)
    puts "#{BLUE}Calling inspect predictions for #{attribute_type}...#{RESET}"

    input_json = { text: input_text }.to_json
    input_text = input_text.strip.sub(/^:/, '')
    input_text = input_text.strip.gsub(/^\s*[:\u200B]+/, '')

    other_json = { text: input_text.strip, entities: [] }.to_json
    encoded_data = Base64.strict_encode64(input_json)

    train_flag = train
    predict_flag = predict

    encoded_validation_data = validate ? Base64.strict_encode64(validate.to_json) : 'None'

    input_data = data ? other_json : ''

    # puts "attribute_type: #{attribute_type}"
    # puts "encoded_data: #{encoded_data}"
    # puts "encoded_validation_data: #{encoded_validation_data}"
    # puts "predict_flag: #{predict_flag}"
    # puts "train_flag: #{train_flag}"
    # puts "input_data: #{input_data}"

    command = "python3 app/python/ai_processing/main.py '#{attribute_type}' '#{encoded_data}' #{encoded_validation_data} #{predict_flag} #{train_flag} '#{input_data}' "

    stdout, stderr, status = Open3.capture3(command)
    # puts "stdout: #{stdout}"
    # puts "stderr: #{stderr}"
    # puts "status: #{status}"

    if train_flag
      puts "#{BLUE}Training started in the background. Logs will be saved to 'training.log'.#{RESET}"
      Process.detach(Process.spawn(command))
      return nil
    end

    if status.success? && !stdout.strip.empty?
      begin
        json_output = stdout.split("\n").find { |line| line.strip.start_with?('{') }

        if json_output
          begin
            JSON.parse(json_output)
          rescue JSON::ParserError => e
            puts "#{RED}Failed to parse JSON: #{e.message}#{RESET}"
            puts "#{RED}Raw stdout content: #{stdout}#{RESET}"
            nil
          end
        else
          puts "#{RED}No valid JSON output found in stdout. Full output: #{stdout}#{RESET}"
          nil
        end
      rescue StandardError => e
        puts "#{RED}Unexpected error: #{e.message}#{RESET}"
        puts "#{RED}Full stdout: #{stdout}#{RESET}"
        nil
      end
    else
      puts "#{RED}Error running script for #{attribute_type}: #{stderr}#{RESET}"
      nil
    end
  end

  def self.clean_text(data)
    data.gsub(/\n+/, ' ').strip
  end

  def self.print_indices(entity_type, input_text)
    puts "#{BLUE}Printing indices...#{RESET}"
    call_inspect_predictions(attribute_type: entity_type, input_text: input_text,
                             data: input_text)
  end

  def self.get_labels_from_python(entity_type)
    command = "python3 -c \"from app.python.ai_processing.utils.label_mapping import get_label_list; import json; print(json.dumps(get_label_list('#{entity_type}', is_biluo=False)))\""
    stdout, stderr, status = Open3.capture3(command)
    # puts "stdout: #{stdout}"
    # puts "stderr: #{stderr}"
    # puts "status: #{status}"

    if status.success?
      JSON.parse(stdout)
    else
      puts "#{RED}Error fetching labels: #{stderr}#{RESET}"
      []
    end
  end
end
