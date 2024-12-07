# frozen_string_literal: true

require 'open3'
require 'json'
require 'base64'
require 'python_script_parser'

class JobPostService
  def self.print_entities(response)
    puts 'Extracted Entities and Values:'
    response['entities'].each do |entity_type, values|
      puts "#{entity_type}:"
      values.each { |value| puts "  - #{value}" }
    end
  end

  def self.extract_and_save_job_description_and_salary(job_post)
    puts 'Preprocessing job description...'

    structured_data = preprocess_job_description(job_post['content'])

    unless structured_data
      puts "#{RED}Failed to preprocess job description.#{RESCUE}"
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

    python_script_path = 'app/python/ai_processing/utils/description_splitter.py'
    input_json = { text: job_description }.to_json
    encoded_data = Base64.strict_encode64(input_json)
    command = "python3 #{python_script_path} '#{encoded_data}'"

    stdout, stderr, status = Open3.capture3(command)

    if status.success? && !stdout.strip.empty?
      begin
        result = JSON.parse(stdout)
        puts 'Preprocessing successful. Structured data:'
        result.each { |key, value| puts "#{key.capitalize}: #{value[0..100]}..." if value } 
        return result
      rescue JSON::ParserError => e
        puts "#{RED}Error parsing JSON from description splitter: #{e.message}#{RESCUE}"
      end
    else
      puts "#{RED}Error running description splitter: #{stderr} (Status: #{status.exitstatus})#{RESCUE}"
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
