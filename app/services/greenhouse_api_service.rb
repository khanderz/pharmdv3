# app/services/greenhouse_api_service.rb
require 'net/http'
require 'json'

class GreenhouseApiService
  BASE_URL = 'https://boards-api.greenhouse.io/v1/boards'

  def self.fetch_jobs(company)
    return unless company.ats_id

    url = "#{BASE_URL}/#{company.ats_id}/jobs?content=true"

    response = make_request(url)
    return unless response

    parse_response(response, company)
  end

  private

  def self.make_request(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    return response.body if response.is_a?(Net::HTTPSuccess)

    handle_error(response, url)
    nil
  end

  def self.handle_error(response, url)
    puts "Error fetching Greenhouse jobs from #{url}: #{response.message} (#{response.code})"
  end

  def self.parse_response(response, company)
    jobs = JSON.parse(response)
    return jobs['jobs'] if jobs.is_a?(Hash) && jobs['jobs']

    handle_error_response(jobs, company)
    nil
  rescue JSON::ParserError
    puts "Failed to parse Greenhouse API response for company: #{company.company_name}"
    nil
  end

  def self.handle_error_response(error_response, company)
    error_message = error_response['error'] || 'Unknown error'
    puts "Error fetching Greenhouse jobs for company #{company.company_name}: #{error_message}"
  end
end
