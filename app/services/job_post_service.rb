# app/services/job_post_service.rb
require 'open3'
require 'json'
require 'base64'

class JobPostService
  def self.extract_and_save_salary(job_post)
    job_description = job_post.job_description.to_s
    job_additional = job_post.job_additional.to_s
    combined_text = "#{job_description} #{job_additional}"

    return if combined_text.empty?

    json_data = { text: combined_text }.to_json
    encoded_data = Base64.strict_encode64(json_data)

    command = "python3 app/python/salary_extraction/job_post_processing.py '#{encoded_data}'"
    stdout, stderr, status = Open3.capture3(command)

    if status.success? && !stdout.strip.empty?
      salary_data = JSON.parse(stdout)

      min_salary = salary_data['min_salary']
      max_salary = salary_data['max_salary']
      interval = salary_data['interval']
      currency_code = salary_data['currency']

      puts "Extracted Salary range: #{min_salary} - #{max_salary}, Interval: #{interval}, Currency: #{currency_code}"

      update_data = {}
      update_data[:job_salary_min] = min_salary.to_i if min_salary
      update_data[:job_salary_max] = max_salary.to_i if max_salary

      if min_salary || max_salary
        if interval
          update_data[:job_salary_interval_id] = JobSalaryInterval.find_by(interval: interval)&.id
        end

        if currency_code
          update_data[:job_salary_currency_id] = JobSalaryCurrency.find_or_adjudicate_currency(
            currency_code, job_post.company_id, job_post.job_url
          )&.id
        end
      end

      job_post.update(update_data) unless update_data.empty?
    else
      puts "Error in salary extraction script: #{stderr} or status: #{status}"
    end
  end
end
