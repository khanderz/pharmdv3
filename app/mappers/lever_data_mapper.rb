# frozen_string_literal: true

class LeverDataMapper
  def self.map(job, company, use_validation: false)
    puts "\n--- Lever Data Mapper ---"
    puts "Job: #{job}"
    location_input = LocationMapper.extract_location(job, 'lever')
    location_info = LocationMapper.new.match_location(location_input, job, company, job['country'])

    puts "\n--- Location Info ---"
    puts " returned Location Info: #{location_info}"

    job_post_data = JobPostDataMapper.map_basic_data(job, company, location_info, 'lever')

    updated_by_ai = AiUpdater.update_with_ai(job_post_data, job, company, location_info,
                                             use_validation)

    unless updated_by_ai
      job_post_data[:job_salary_min] ||= job['salaryRange']&.dig('min')
      job_post_data[:job_salary_max] ||= job['salaryRange']&.dig('max')
      job_post_data[:job_salary_single] ||= nil
      job_post_data[:job_salary_currency_id] ||= nil
      job_post_data[:job_salary_interval_id] ||= nil
    end

    job_post_data
  end
end
