# frozen_string_literal: true

require 'open3'
require 'json'
require 'base64'

# require 'python_script_parser'

GREEN = "\033[32m"
BLUE = "\033[34m"
RESET = "\033[0m"
ORANGE = "\033[38;2;255;165;0m"
RED = "\033[31m"

class JobPostService
  def self.run_with_test_text(test_text)
    puts 'Running with test text...'

    job_post = { 'content' => test_text }

    split_descriptions(job_post)
  end

  def self.split_descriptions(job_post)
    puts 'Preprocessing job description...'
    # puts "job post: #{job_post}"
    structured_data = preprocess_job_description(job_post['content'])

    unless structured_data
      puts "#{RED}Failed to preprocess job description.#{RESET}"
      return
    end

    description = structured_data['description']
    summary = structured_data['summary']
    responsibilities = structured_data['responsibilities']
    qualifications = structured_data['qualifications']
    benefits = structured_data['benefits'] || qualifications

    # processed_descriptions = extract_and_save_descriptions(job_post, summary)
    # processed_qualifications = extract_and_save_job_qualifications(job_post, qualifications)
    # processed_responsibilities = extract_and_save_responsibilities(job_post, responsibilities)
    processed_benefits = extract_and_save_benefits(job_post, benefits)

    # puts "description: #{description}"
    # puts "*" * 50
    # puts "summary: #{summary}"
    # puts "*" * 50
    # puts "responsibilities: #{responsibilities}"
    # puts "*" * 50
    # puts "qualifications: #{qualifications}"
    # puts "*" * 50
    # puts "benefits: #{benefits}"
  end

  def self.preprocess_job_description(job_description)
    puts 'Running description splitter...'
    # puts "job_description: #{job_description}"

    python_script_path = 'app/python/ai_processing/utils/description_splitter.py'
    input_json = { text: job_description }.to_json
    encoded_data = Base64.strict_encode64(input_json)
    command = "python3 #{python_script_path} '#{encoded_data}'"

    stdout, stderr, status = Open3.capture3(command)

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

  def self.extract_and_save_descriptions(job_post, descriptions)
    descriptions_data = call_inspect_predictions(
      script_path: 'app/python/ai_processing/job_description_extraction/train_job_description_extraction.py',
      input_text: descriptions
    )

    puts "descriptions_data: #{descriptions_data}"
  end 

  def self.extract_and_save_responsibilities(job_post, responsibilities)
    responsibilities_data = call_inspect_predictions(
      script_path: 'app/python/ai_processing/job_responsibilities/train_responsibilities.py',
      input_text: responsibilities
    )

    puts "responsibilities_data: #{responsibilities_data}"
  end

  def self.extract_and_save_job_qualifications(job_post, qualifications_text)
    # puts "Extracting qualifications from text: #{qualifications_text}..."
    
    qualification_data = call_inspect_predictions(
      script_path: 'app/python/ai_processing/job_qualifications/train_qualifications.py',
      input_text: qualifications_text
    )
    
    # puts "qualification_data: #{qualification_data}"
    # if qualification_data && qualification_data['status'] == 'success'
    #   update_qualifications(job_post, qualification_data['entities'])
    # else
    #   puts "#{RED}Failed to extract qualifications.#{RESET}"
    # end
  end

  def self.print_indices(script_path, input_text)
    call_inspect_predictions(script_path: script_path , input_text: input_text, validate: false, data: input_text)
  end

  def self.validate_and_update_training_data(input_text, extracted_entities, entity_type)
    puts "Validating #{entity_type} entities..."
    # puts "Extracted entities: #{extracted_entities}"
  
    training_data_path = 'app/python/ai_processing/job_benefits/data/train_data_spacy.json'
    training_data = []
    training_data = JSON.parse(File.read(training_data_path)) if File.exist?(training_data_path)
    script_path = 'app/python/ai_processing/job_benefits/train_benefits.py'

    print_indices(script_path, input_text)
    corrected_entities = []
  
    extracted_entities.each do |entity|
      token = entity[1][0] 

      puts "Is the label '#{entity_type}' correct for this token? (yes/no)"
      label_confirmation = gets.strip.downcase
      if label_confirmation != "yes"
        puts "Enter the correct label (e.g., 'COMPENSATION'):"
        entity_type = gets.strip
      end
  
      puts "\nText: '#{input_text}'"
      puts "Extracted token: '#{token}'"
      puts "Enter start index for '#{token}':"
      start_value = gets.strip.to_i
  
      puts "Enter end index for '#{token}':"
      end_value = gets.strip.to_i
  
      corrected_entities << {
        "start" => start_value,
        "end" => end_value,
        "label" => entity_type,
        "token" => token
      }
    end
  
    new_training_data = {
      "text" => input_text,
      "entities" => corrected_entities
    }
  
    validation_result = call_inspect_predictions(
      script_path: script_path,
      input_text: input_text,
      validate: true,
      data: nil
    )
  
    if validation_result && validation_result['status'] == 'success'
      message = validation_result['message'].to_s.strip
    
      if message.include?('Validation passed')
        training_data << new_training_data

        File.write(training_data_path, JSON.pretty_generate(training_data))
        puts "#{GREEN}Training data validated and saved successfully at #{training_data_path}.#{RESET}"
      else
        puts "#{RED}Validation completed with errors: #{message}#{RESET}"
        training_data << new_training_data
        File.write(training_data_path, JSON.pretty_generate(training_data))
        puts "#{GREEN}Training data saved despite validation errors at #{training_data_path}.#{RESET}"
      end
    else
      puts "#{RED}Validation script failed to execute successfully. Training data was not saved.#{RESET}"
    end
    corrected_entities
  end
  
  
  def self.extract_and_save_benefits(job_post, benefits)

    puts "Starting validation for benefits..."
    benefits_data = call_inspect_predictions(
      script_path: 'app/python/ai_processing/job_benefits/train_benefits.py',
      input_text: benefits,
      validate: false,
      data: nil
    )

    parsed_benefits = benefits_data['entities']
    corrected_benefits = validate_and_update_training_data(benefits, parsed_benefits, 'benefits')


    # compensation_data = call_inspect_predictions(
    #   script_path: 'app/python/ai_processing//salary_extraction/train_salary_extraction.py',
    #   input_text: parsed_benefits['PROFESSIONAL_DEVELOPMENT'][0]
    # )
    # puts "benefits: #{benefits}"
    # puts "parsed benefits: #{parsed_benefits}"
    # puts "#{parsed_benefits['PROFESSIONAL_DEVELOPMENT']}"
    # puts "benefits_data: #{parsed_benefits}"
    # puts "compensation_data: #{compensation_data}"

    # if compensation_data['status'] == 'success' && compensation_data['entities']
    #   entities = compensation_data['entities']
    #   # puts "Entities: #{entities}"

    #   job_post.job_salary_min = entities['SALARY_SINGLE']&.first&.gsub(',', '').to_i if entities['SALARY_SINGLE']
    #   job_post.job_salary_max = entities['SALARY_MAX']&.first&.gsub(',', '').to_i if entities['SALARY_MAX']
    #   job_post.job_salary_single = entities['SALARY_MIN']&.first&.gsub(',', '').to_i if entities['SALARY_MIN']
  
    #   if entities['CURRENCY']&.first
    #     currency = JobSalaryCurrency.find_by(currency_code: entities['CURRENCY'].first) ||
    #                JobSalaryCurrency.adjudicate_currency(entities['CURRENCY'].first, job_post.company_id, job_post.job_url)
    #     job_post.job_salary_currency_id = currency.id if currency
    #   end
  
    #   if entities['INTERVAL']&.first
    #     interval = JobSalaryInterval.find_by(interval: entities['INTERVAL'].first)
    #     job_post.job_salary_interval_id = interval.id if interval
    #   end
  
    #   if entities['COMMITMENT']&.first
    #     commitment = JobCommitment.find_by(name: entities['COMMITMENT'].first)
    #     job_post.job_commitment_id = commitment.id if commitment
    #   end

    #   if entities['JOB_COUNTRY']&.any?
    #     job_post.job_post_countries.destroy_all
  
    #     entities['JOB_COUNTRY'].each do |country_name|
    #       country = JobCountry.find_or_create_by(name: country_name)
  
    #       JobPostCountry.find_or_create_by(job_post: job_post, country: country)
    #     end
    #   end
    # end

    # if job_post.changed?
    #   job_post.save!
    #   puts "Job post updated with salary and benefits data."
    # else
    #   puts "No changes made to the job post."
    # end
  end

  def self.call_inspect_predictions(script_path:, input_text:, validate: false, data: nil)
    input_json = { text: input_text }.to_json
    input_text = input_text.strip.sub(/^:/, '') 
    input_text = input_text.strip.gsub(/^\s*[:\u200B]+/, '')
    other_json = { text: input_text.strip, entities: [] }.to_json
    encoded_data = Base64.strict_encode64(input_json)
    validate_flag = validate
    input_data = data ? other_json : ""

    command = "python3 #{script_path} '#{encoded_data}' #{validate_flag} '#{input_data}'"

    stdout, stderr, status = Open3.capture3(command)
    # puts "stdout: #{stdout}"
    # puts "stderr: #{stderr}"
    # puts "status: #{status}"

    if status.success? && !stdout.strip.empty?
      begin
        json_output = stdout.split("\n").find { |line| line.strip.start_with?("{") }
  
        if json_output
          JSON.parse(json_output)
        else
          puts "#{RED}No valid JSON output found in stdout. Full output: #{stdout}#{RESET}"
          nil
        end
      rescue JSON::ParserError => e
        puts "#{RED}Error parsing JSON: #{e.message}#{RESET}"
        puts "#{RED}Full stdout: #{stdout}#{RESET}"
        nil
      end
    else
      puts "#{RED}Error running script #{script_path}: #{stderr}#{RESET}"
      nil
    end
  end

  # def self.update_qualifications(job_post, qualifications_entities)
  #   qualifications_entities.each do |entity_type, values|
  #     puts "Updating qualifications for #{entity_type}: #{values.join(', ')}"
  #     job_post.qualifications ||= []
  #     job_post.qualifications.concat(values)
  #     job_post.save
  #   end
  # end
  
end

test_text = <<-TEXT
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

JobPostService.run_with_test_text(test_text)