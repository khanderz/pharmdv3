# frozen_string_literal: true

# app/mappers/greenhouse_data_mapper.rb

class GreenhouseDataMapper
  def self.map(job, company)
    location_input = LocationHelper.extract_location(job, 'greenhouse')
    location_info = LocationMapper.new.match_location(location_input, job, company)

    job_post_data = JobPostDataMapper.map_basic_data(job, company, location_info, 'greenhouse')

    updated_by_ai = AiSalaryUpdater.update_with_ai(job_post_data, job, company)

    job_post_data
  end
end
