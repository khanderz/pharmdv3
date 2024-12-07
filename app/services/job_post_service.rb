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

    extract_and_save_job_description_and_salary(job_post)
  end

  def self.print_entities(response)
    puts 'Extracted Entities and Values:'
    response['entities'].each do |entity_type, values|
      puts "#{entity_type}:"
      values.each { |value| puts "  - #{value}" }
    end
  end

  def self.extract_and_save_job_description_and_salary(job_post)
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
    benefits = structured_data['benefits']

    puts "description: #{description}"
    puts "*" * 50
    puts "summary: #{summary}"
    puts "*" * 50
    puts "responsibilities: #{responsibilities}"
    puts "*" * 50
    puts "qualifications: #{qualifications}"
    puts "*" * 50
    puts "benefits: #{benefits}"

    # puts 'Extracting job description entities...'
    # job_description_data = call_inspect_job_description_predictions(
    #   script_path: 'app/python/ai_processing/job_description_extraction/train_job_description_extraction.py',
    #   input_text: responsibilities || job_post['content']
    # )

    # return unless job_description_data && job_description_data['status'] == 'success'

    # compensation_texts = job_description_data.dig('entities', 'COMPENSATION')
    # if compensation_texts.nil? || compensation_texts.empty?
    #   puts "No compensation data found for job post ID #{job_post.id}."
    #   return
    # end

    # compensation_texts.each do |compensation_text|
    #   extract_and_save_salary(job_post, compensation_text)
    # end
  end

  def self.preprocess_job_description(job_description)
    puts 'Running description splitter...'
    # puts "job_description: #{job_description}"

    python_script_path = 'app/python/ai_processing/utils/description_splitter.py'
    input_json = { text: job_description }.to_json
    encoded_data = Base64.strict_encode64(input_json)
    command = "python3 #{python_script_path} '#{encoded_data}'"

    stdout, stderr, status = Open3.capture3(command)
    puts "stdout: #{stdout}"
    puts "stderr: #{stderr}" unless stderr.strip.empty?

    if status.success? && !stdout.strip.empty?
      begin
        result = JSON.parse(stdout)
        puts 'Preprocessing successful. Structured data:'
        result.each { |key, value| puts "#{key.capitalize}: #{value[0..100]}..." if value } 
        return result
      rescue JSON::ParserError => e
        puts "#{RED}Error parsing JSON from description splitter: #{e.message}#{RESET}"
      end
    else
      puts "#{RED}Error running description splitter: #{stderr} (Status: #{status.exitstatus})#{RESET}"
    end

    nil
  end

  def self.extract_and_save_salary(job_post, compensation_text)
    puts "Extracting salary from compensation text: #{compensation_text}..."
    salary_data = call_inspect_salary_predictions(
      script_path: 'app/python/ai_processing/salary_extraction/train_salary_extraction.py',
      input_text: compensation_text
    )

    return unless salary_data && salary_data['status'] == 'success'

    update_data = prepare_salary_update_data(salary_data['predictions'], job_post)
    job_post.update(update_data) unless update_data.empty?
  end

  def self.call_inspect_job_description_predictions(script_path:, input_text:)
    input_json = { text: input_text }.to_json
    encoded_data = Base64.strict_encode64(input_json)
    command = "python3 #{script_path} '#{encoded_data}'"

    stdout, stderr, status = Open3.capture3(command)
    # puts "Job description extraction command executed with status: #{status.exitstatus}"
    # puts "STDOUT: #{stdout}"
    # puts "STDERR: #{stderr}"

    if status.success? && !stdout.strip.empty?
      response = PythonScriptParser.parse_output(stdout)
      print_entities(response) if response['status'] == 'success' && response['entities']
      response

    else
      puts "Error in script #{script_path}: #{stderr} (Status: #{status})"
      nil
    end
  end

  def self.call_inspect_salary_predictions(script_path:, input_text:)
    input_json = { text: input_text }.to_json
    encoded_data = Base64.strict_encode64(input_json)
    command = "python3 #{script_path} '#{encoded_data}'"

    stdout, stderr, status = Open3.capture3(command)
    # puts "Salary extraction command executed with status: #{status.exitstatus}"
    # puts "STDOUT: #{stdout}"
    # puts "STDERR: #{stderr}"

    if status.success? && !stdout.strip.empty?
      PythonScriptParser.parse_output(stdout)
    else
      puts "Error in script #{script_path}: #{stderr} (Status: #{status})"
      nil
    end
  end

  def self.prepare_salary_update_data(predictions, job_post)
    update_data = {}

    min_salary = predictions.find { |p| p['predicted_label'] == 'SALARY_MIN' }
    max_salary = predictions.find { |p| p['predicted_label'] == 'SALARY_MAX' }
    single_salary = predictions.find { |p| p['predicted_label'] == 'SALARY_SINGLE' }
    currency = predictions.find { |p| p['predicted_label'] == 'CURRENCY' }
    interval = predictions.find { |p| p['predicted_label'] == 'INTERVAL' }

    update_data[:job_salary_min] = min_salary['token'].to_i if min_salary
    update_data[:job_salary_max] = max_salary['token'].to_i if max_salary
    update_data[:job_salary_single] = single_salary['token'].to_i if single_salary
    if currency
      update_data[:job_salary_currency_id] =
        find_salary_currency_id(currency['token'], job_post)
    end
    update_data[:job_salary_interval_id] = find_salary_interval_id(interval['token']) if interval

    update_data
  end

  def self.find_salary_currency_id(currency_code, job_post)
    JobSalaryCurrency.find_or_adjudicate_currency(currency_code, job_post.company_id,
                                                  job_post.job_url)&.id
  end

  def self.find_salary_interval_id(interval)
    JobSalaryInterval.find_by(interval: interval)&.id
  end
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