# frozen_string_literal: true

require 'open3'
require 'json'
require 'base64'

# require 'python_script_parser'

# GREEN = "\033[32m"
# BLUE = "\033[34m"
# RESET = "\033[0m"
# ORANGE = "\033[38;2;255;165;0m"
# RED = "\033[31m"

class JobPostService
  # def self.run_with_test_text(test_text)
  #   puts 'Running with test text...'

  #   job_post = { 'content' => test_text }

  #   split_descriptions(job_post, 'salary')
  # end

  def self.split_descriptions(job_post)
    puts "#{BLUE}Preprocessing job description...#{RESET}"
    # puts "job post: #{job_post}"
    structured_data = preprocess_job_description(job_post['content'])
    # puts "structured_data: #{structured_data}"
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
    data_return << { 'summary' => summary } if summary
    data_return << { 'responsibilities' => responsibilities } if responsibilities
    puts "data return : #{data_return}"

    processed_description = extract_descriptions(summary)
    data_return << { 'description' => processed_description } if processed_description
    puts "data return : #{data_return}"

    processed_qualifications = extract_qualifications(qualifications)
    data_return << { 'qualifications' => processed_qualifications } if processed_qualifications
    puts "data return : #{data_return}"

    processed_benefits = extract_benefits(benefits)
    data_return << { 'benefits' => processed_benefits } if processed_benefits

    puts "data return : #{data_return}"
    salary_data = extract_salary(processed_benefits[:job_compensation])
    data_return << { 'salary' => salary_data } if salary_data
    puts "data return : #{data_return}"

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
    # puts "stdout: #{stdout}"
    # puts "stderr: #{stderr}"
    # puts "status: #{status}"

    if status.success? && !stdout.strip.empty?
      begin
        result = JSON.parse(stdout)
        # puts 'Preprocessing successful. Structured data:'
        # result.each { |key, value| puts "#{key.capitalize}: #{value[0..100]}..." if value }
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

    parsed_descriptions = description_data['entities']
    corrected_descriptions = validate_and_update_training_data(summary, parsed_descriptions,
                                                               'job_description')

    if description_data['status'] == 'success' && corrected_descriptions.any?
      job_post_object = {
        job_description: nil,
        job_role: nil,
        job_seniority: nil,
        job_dept: nil,
        job_team: nil,
        job_commitment: nil,
        job_setting: nil,
        job_country: nil,
        job_city: nil,
        job_state: nil
      }

      corrected_descriptions.each do |entity|
        case entity['label']
        when 'DESCRIPTION'
          job_post_object[:job_description] = entity['token']
        when 'JOB_ROLE'
          job_post_object[:job_role] = entity['token']
        when 'JOB_SENIORITY'
          job_post_object[:job_seniority] = entity['token']
        when 'JOB_DEPT'
          job_post_object[:job_dept] = entity['token']
        when 'JOB_TEAM'
          job_post_object[:job_team] = entity['token']
        when 'JOB_COMMITMENT'
          job_post_object[:job_commitment] = entity['token']
        when 'JOB_SETTING'
          job_post_object[:job_setting] = entity['token']
        when 'JOB_COUNTRY'
          job_post_object[:job_country] = entity['token']
        when 'JOB_CITY'
          job_post_object[:job_city] = entity['token']
        when 'JOB_STATE'
          job_post_object[:job_state] = entity['token']
        else
          puts "#{RED}Unexpected label: #{entity['label']}#{RESET}"
        end
      end
    else
      puts "#{RED}Failed to extract description data.#{RESET}"
    end
    job_post_object
  end

  def self.extract_qualifications(qualifications)
    puts "#{BLUE}Extracting qualifications from text: #{qualifications}...#{RESET}"

    qualification_data = call_inspect_predictions(
      attribute_type: 'job_qualifications',
      input_text: qualifications,
      predict: true
    )

    puts "qualification_data: #{qualification_data}"

    parsed_qualifications = qualification_data['entities']
    puts "parsed_qualifications: #{parsed_qualifications}"
    corrected_qualifications = validate_and_update_training_data(qualifications,
                                                                 parsed_qualifications, 'job_qualifications')

    if qualification_data['status'] == 'success' && corrected_qualifications.any?
      job_post_object = {
        qualifications: nil,
        credentials: nil,
        education: nil,
        experience: nil,
      }

      corrected_qualifications.each do |entity|
        case entity['label']
        when 'QUALIFICATIONS'
          job_post_object[:qualifications] = entity['token']
        when 'CREDENTIALS'
          job_post_object[:credentials] = entity['token']
        when 'EDUCATION'
          job_post_object[:education] = entity['token']
        when 'EXPERIENCE'
          job_post_object[:experience] = entity['token']
        else
          puts "#{RED}Unexpected label: #{entity['label']}#{RESET}"
        end
      end
    else
      puts "#{RED}Failed to extract qualifications data.#{RESET}"
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
        job_setting: nil,
        job_country: nil,
        job_city: nil,
        job_state: nil,
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
          job_post_object[:job_setting] = entity['token']
        when 'JOB_COUNTRY'
          job_post_object[:job_country] = entity['token']
        when 'JOB_CITY'
          job_post_object[:job_city] = entity['token']
        when 'JOB_STATE'
          job_post_object[:job_state] = entity['token']
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
      puts "#{RED}Failed to extract benefits data.#{RESET}"
    end
    job_post_object
  end

  def self.extract_salary(salary)
    puts 'Starting validation for benefits...'

    puts "Salary: #{salary}"
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
      puts "#{RED}Failed to extract compensation data.#{RESET}"
    end
    job_post_object
  end

  def self.validate_and_update_training_data(input_text, extracted_entities, entity_type)
    puts "#{BLUE}Validating #{entity_type} entities...#{RESET}"
    # puts "Extracted entities: #{extracted_entities}"

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

    loop do
      corrected_entities = []
      corrections_exist = false
      extracted_entities.each_with_index do |(label, tokens), _index|
        label = label.to_s
        token = tokens[0]

        puts "is token #{token} for label '#{label}' correct (yes/no)"
        token_confirmation = gets.strip.downcase
        if token_confirmation != 'yes' && token_confirmation != 'y'
          puts 'Enter the correct token:'
          token = gets.strip
          corrections_exist = true
        end

        puts "Is the label '#{label}' for token '#{token}' correct? (yes/no)"
        label_confirmation = gets.strip.downcase
        if label_confirmation != 'yes' && label_confirmation != 'y'
          puts "Select the correct label for this token (#{token}):"
          label_list.each_with_index do |lbl, idx|
            puts "#{idx}: #{lbl}"
          end
          label_index = gets.strip.to_i
          label = label_list[label_index] if label_index >= 0 && label_index < label_list.size
          corrections_exist = true
        end

        if corrections_exist
          puts "Enter start index for '#{token}':"
          start_value = gets.strip.to_i
  
          puts "Enter end index for '#{token}':"
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
        corrections_exist = true

        puts "Is the label '#{label}' for token '#{token}' correct? (yes/no)"
        label_confirmation = gets.strip.downcase
        if label_confirmation != 'yes' && label_confirmation != 'y'
          puts "Select the correct label for this token (#{token}):"
          label_list.each_with_index do |lbl, idx|
            puts "#{idx}: #{lbl}"
          end
          label_index = gets.strip.to_i
          label = label_list[label_index] if label_index >= 0 && label_index < label_list.size
          corrections_exist = true
        end

        if corrections_exist
          puts "Enter start index for '#{token}':"
          start_value = gets.strip.to_i
  
          puts "Enter end index for '#{token}':"
          end_value = gets.strip.to_i
        end

        corrected_entities << {
          'start' => start_value,
          'end' => end_value,
          'label' => label,
          'token' => token
        }
      end

      new_training_data = {
        'text' => text,
        'entities' => corrected_entities
      }
      puts "new_training_data: #{new_training_data}"

      if corrections_exist == false
        puts "#{ORANGE}No entities to validate. Skipping validation and proceeding to next step.#{RESET}"
        return corrected_entities
      end

      validation_result = call_inspect_predictions(
        attribute_type: entity_type,
        input_text: input_text,
        validate: [new_training_data]
      )

      if validation_result && validation_result['status'] == 'success'
        # puts "validation result on rb : #{validation_result}"
        message = validation_result['message'].to_s.strip
        puts "#{GREEN}Validation completed successfully: #{message}#{RESET}"

        if message.include?('Validation passed for all entities.')
          training_data << new_training_data
          File.write(training_data_path, JSON.pretty_generate(training_data))
          puts "#{GREEN}Training data validated and saved successfully at #{training_data_path}.#{RESET}"

          puts "#{BLUE} Now training model with new validated entities #{RESET}"
          call_inspect_predictions(attribute_type: entity_type, input_text: input_text, train: true)
          puts "corrected entities after training: #{corrected_entities}"
          return corrected_entities
          # break
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

    puts "#{RED}Validation failed after #{max_attempts} attempts. Exiting...#{RESET}"

    puts "corrected entities after training 2: #{corrected_entities}"
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

test_text = <<~TEXT
  &lt;div class=&quot;content-intro&quot;&gt;&lt;p&gt;&lt;strong&gt;&lt;em&gt;Attention recruitment agencies:&lt;/em&gt;&lt;/strong&gt;&lt;em&gt; 4DMT is a clinical-stage biotherapeutics company harnessing the power of directed evolution for targeted genetic medicines. We seek to unlock the full potential of gene therapy using our platform, Therapeutic Vector Evolution (TVE), which combines the power of directed evolution with our approximately one billion synthetic AAV capsid-derived sequences to invent evolved vectors for use in our products. We believe key features of our targeted and evolved vectors will help us create targeted product candidates with improved therapeutic profiles. These profiles will allow us to treat a broad range of large market diseases, unlike most current genetic medicines that generally focus on rare or small market diseases. &amp;nbsp;&lt;/p&gt;
  &lt;p&gt;Company Differentiators:&amp;nbsp;&lt;/p&gt;
  &lt;p&gt;• &amp;nbsp; &amp;nbsp;Fully integrated clinical-phase company with internal manufacturing&lt;br&gt;• &amp;nbsp; &amp;nbsp;Demonstrated ability to move rapidly from idea to IND&lt;br&gt;• &amp;nbsp; &amp;nbsp;Five candidate products in the clinic and two declared pre-clinical programs&lt;br&gt;• &amp;nbsp; &amp;nbsp;Robust technology and IP foundation, including our TVE and manufacturing platforms&lt;br&gt;• &amp;nbsp; &amp;nbsp;Initial product safety and efficacy data substantiates the value of our platforms&lt;br&gt;• &amp;nbsp; &amp;nbsp;Opportunities to expand to other indications and modalities within genetic medicine&lt;/p&gt;&lt;/div&gt;
  &lt;p&gt;&lt;strong&gt;Position Summary:&amp;nbsp;&lt;/strong&gt;&amp;nbsp;&lt;/p&gt;
  &lt;p&gt;The Associate Director of Clinical Quality Assurance (CQA) will be responsible for supporting Quality Assurance oversight of 4DMT sponsored clinical studies, ensuring studies are executed in compliance with all applicable international regulatory requirements for Good Clinical Practice (GCP).&amp;nbsp;&amp;nbsp;This position reports to the Senior Director, GCP Compliance and Quality Systems and contributes to the development, implementation, and successful execution of the CQA mission, objectives, and strategic plan.&lt;/p&gt;
  &lt;p&gt;&lt;strong&gt;Responsibilities:&lt;/strong&gt;&amp;nbsp;&lt;/p&gt;
  &lt;ul&gt;
  &lt;li&gt;Partner with Clinical stakeholder to support timely identification, escalation, investigation, documentation, and resolution of GCP-related quality events, acting at all times with an appropriate sense of urgency.&lt;/li&gt;
  &lt;li&gt;Provide GCP guidance to clinical study teams, including via attendance at Study team meetings, with support from Sr. Director GCP Compliance.&lt;/li&gt;
  &lt;li&gt;Ensure principles of Risk Management are applied to Clinical Studies per ICH E6&lt;/li&gt;
  &lt;li&gt;Coordinate GCP Compliance audits of high-risk clinical vendors/sites, including clinical investigator sites.&lt;/li&gt;
  &lt;li&gt;Ensure audit findings are communicated to audit stakeholders and collaborate with auditees and vendors to track, review, approve, and assess the adequacy of&lt;/li&gt;
  &lt;li&gt;Perform Clinical Document reviews, ensuring the quality, accuracy and completeness of various documents, including as applicable Clinical Protocols, IBs, DSURs, Module 2.6 Tabulated and Written Summaries, and Integrated&lt;/li&gt;
  &lt;/ul&gt;
  &lt;p&gt;&lt;strong&gt;Support investigation and management of specific Clinical Study Quality Events as assigned:&lt;/strong&gt;&lt;/p&gt;
  &lt;ul&gt;
  &lt;li&gt;Monitor, track, and facilitate the completion of formal corrective and preventive actions (CAPAs) to address identified&amp;nbsp;Clinical Study Quality Events, including potential serious breaches of GCP.&amp;nbsp;&lt;/li&gt;
  &lt;/ul&gt;
  &lt;p&gt;&lt;strong&gt;Support a quality-focused work environment in Clinical that fosters learning, respect, open communication, collaboration, integration, and teamwork:&lt;/strong&gt;&lt;/p&gt;
  &lt;ul&gt;
  &lt;li&gt;Drive the development and continuous improvement of the Clinical Quality Management System through the development / refinement of Clinical QA processes / initiatives as assigned&lt;/li&gt;
  &lt;/ul&gt;
  &lt;p&gt;&lt;strong&gt;Partner with GMP Quality and Clinical Operations teams to facilitate the investigation of clinical supply quality issues such as temperature excursions, product complaints and deviations reported from clinical sites.&lt;/strong&gt;&lt;/p&gt;
  &lt;p&gt;&lt;strong&gt;&amp;nbsp;&lt;/strong&gt;&lt;/p&gt;
  &lt;p&gt;&lt;strong&gt;&lt;u&gt;QUALIFICATIONS:&amp;nbsp;&lt;/u&gt;&lt;/strong&gt;&lt;/p&gt;
  &lt;ul&gt;
  &lt;li&gt;B.S./B.A. in a science or related life science field or equivalent; advanced scientific degree preferred.&lt;/li&gt;
  &lt;li&gt;8+ years working within a regulated environment such as Regulatory, Quality, Pharmacovigilance or Clinical Development / Operations within the Biotech or similar industry&lt;/li&gt;
  &lt;li&gt;Proven experience with GCP Quality Management Systems, audit support, and quality oversight of global clinical studies, including knowledge of quality investigation / root cause analysis techniques&lt;/li&gt;
  &lt;li&gt;Minimum of 4 years of experience in a role including responsibility for providing GCP oversight of clinical study activities, preferably at a clinical study sponsor&lt;/li&gt;
  &lt;li&gt;In-depth understanding of GCP requirements for investigational products&lt;/li&gt;
  &lt;li&gt;Extensive practical experience and understanding of clinical quality assurance as applied throughout the clinical development life-cycle&lt;/li&gt;
  &lt;li&gt;Excellent communication skills, both oral and written&lt;/li&gt;
  &lt;li&gt;Excellent interpersonal skills, collaborative approach essential&lt;/li&gt;
  &lt;li&gt;Comfortable in a fast-paced small company environment with minimal direction and able to adjust workload based upon changing priorities&lt;/li&gt;
  &lt;/ul&gt;
  &lt;p&gt;Base salary compensation range: $152,000 - $199,000&lt;/p&gt;
TEXT

# JobPostService.run_with_test_text(test_text)
