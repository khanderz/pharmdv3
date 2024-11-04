require 'open3'
require 'shellwords'

class JobPostService
  def self.extract_currency_from_text(job_post)
    job_description = job_post.job_description.to_s
    job_additional = job_post.job_additional.to_s
    combined_text = "#{job_description} #{job_additional}"

    # puts "Combined text for currency extraction: #{combined_text}"
    currency_mappings = JobSalaryCurrency.pluck(:currency_sign, :currency_code).to_h
    return nil if currency_mappings.empty?

    currency_symbol = currency_mappings.keys.find { |symbol| combined_text.include?(symbol) }

    if currency_symbol
      currency_mappings[currency_symbol]
      #   puts "Extracted currency symbol: #{currency_symbol}, code: #{currency_code}"

    else
      puts 'No currency symbol found in text.'
      nil
    end
  end

  def self.extract_salary_range(job_post)
    job_description = job_post.job_description.to_s || ''
    job_additional = job_post.job_additional.to_s || ''
    combined_text = "#{job_description} #{job_additional}"
    escaped_text = Shellwords.escape(combined_text)

    interval_data = JobSalaryInterval.pluck(:interval).join(',')
    currency_mappings = JobSalaryCurrency.pluck(:currency_sign, :currency_code).to_h
    currency_data = currency_mappings.map { |sign, code| "#{sign}:#{code}" }.join(',')

    json_data = { text: combined_text, currency_data: currency_data,
                  interval_data: interval_data }.to_json
    encoded_data = Base64.strict_encode64(json_data)
    print "Encoded data: #{encoded_data}"
    command = "python3 app/python/job_post_processing.py '#{encoded_data}'"

    stdout, stderr, status = Open3.capture3(command)

    # puts "Python script stdout: #{stdout}"
    # puts "Python script stderr: #{stderr}"
    puts "Python script status: #{status.exitstatus}"

    if status.success? && !stdout.strip.empty?
      min_salary, max_salary, interval, currency_code = stdout.strip.split(', ')
      puts "-------------------------Salary range: #{min_salary} - #{max_salary} #{interval} #{currency_code}"

      {
        min: min_salary.to_i,
        max: max_salary.to_i,
        interval: interval,
        currency_code: currency_code
      }
    else
      puts "Error in Python script: #{stderr} or status: #{status}"
      nil
    end
  end

  def self.process_job_post_with_salary_extraction(job_post)
    salary_range = extract_salary_range(job_post)
    return unless salary_range

    job_post.update(
      job_salary_min: salary_range[:min],
      job_salary_max: salary_range[:max],
      job_salary_interval_id: JobSalaryInterval.find_by(interval: salary_range[:interval])&.id,
      job_salary_currency_id: JobSalaryCurrency.find_or_adjudicate_currency(
        salary_range[:currency_code], job_post.company_id, job_post.job_url, job_post
      )&.id
    )
  end
end
