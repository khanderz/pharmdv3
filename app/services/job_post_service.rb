# frozen_string_literal: true

# app/services/job_post_service.rb
require 'open3'
require 'json'
require 'base64'

class JobPostService
  def self.extract_and_save_salary(job_post)
    combined_text = combine_salary_text(job_post)
    return if combined_text.empty?

    salary_data = call_python_model(
      script_path: 'app/python/salary_extraction/train_salary_expections.py',
      input_text: combined_text
    )

    return unless salary_data

    update_data = prepare_salary_update_data(salary_data, job_post)
    job_post.update(update_data) unless update_data.empty?
  end

  def self.extract_and_save_job_description(job_post)
    combined_text = combine_job_description_text(job_post)
    return if combined_text.empty?

    job_description_data = call_python_model(
      script_path: 'app/python/ai_processing/job_description_extraction/train_job_description_extraction.py',
      input_text: combined_text
    )

    return unless job_description_data

    job_post.update(job_description_extracted: true)
    log_extracted_entities(job_description_data)
  end

  private

  def self.combine_salary_text(job_post)
    "#{job_post.job_description} #{job_post.job_additional}".strip
  end

  def self.combine_job_description_text(job_post)
    [
      job_post.job_title,
      job_post.job_description,
      job_post.job_qualifications,
      job_post.job_responsibilities,
      job_post.job_setting,
      job_post.job_additional
    ].compact.join(' ').strip
  end

  def self.call_python_model(script_path:, input_text:)
    encoded_data = Base64.strict_encode64({ text: input_text }.to_json)
    command = "python3 #{script_path} '#{encoded_data}'"

    stdout, stderr, status = Open3.capture3(command)
    if status.success? && !stdout.strip.empty?
      JSON.parse(stdout)
    else
      puts "Error in script #{script_path}: #{stderr} (Status: #{status})"
      nil
    end
  rescue JSON::ParserError => e
    puts "Failed to parse Python script output: #{e.message}"
    nil
  end

  def self.prepare_salary_update_data(salary_data, job_post)
    update_data = {}
    update_data[:job_salary_min] = salary_data['min_salary'].to_i if salary_data['min_salary']
    update_data[:job_salary_max] = salary_data['max_salary'].to_i if salary_data['max_salary']

    if update_data[:job_salary_min] || update_data[:job_salary_max]
      interval = salary_data['interval']
      currency_code = salary_data['currency']

      update_data[:job_salary_interval_id] = find_salary_interval_id(interval) if interval
      update_data[:job_salary_currency_id] = find_salary_currency_id(currency_code, job_post) if currency_code
    end

    update_data
  end

  def self.find_salary_interval_id(interval)
    JobSalaryInterval.find_by(interval: interval)&.id
  end

  def self.find_salary_currency_id(currency_code, job_post)
    JobSalaryCurrency.find_or_adjudicate_currency(currency_code, job_post.company_id, job_post.job_url)&.id
  end

  def self.log_extracted_entities(entities)
    entities.each do |entity|
      puts "Extracted entity: #{entity['entity_name']} with value: #{entity['value']}"
    end
  end
end
