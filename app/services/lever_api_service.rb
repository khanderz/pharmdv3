# frozen_string_literal: true

# app/services/lever_api_service.rb
require 'net/http'
require 'json'

class LeverApiService
  BASE_URL = 'https://api.lever.co/v0/postings'

  def self.fetch_jobs(company)
    identifier = company.ats_id || company.company_name.downcase.gsub(/\s+/, '')
    url = "#{BASE_URL}/#{identifier}"

    response = make_request(url)
    return unless response

    parse_response(response, company)
  end

  def self.make_request(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    return response.body if response.is_a?(Net::HTTPSuccess)

    handle_error(response, url)
    nil
  end

  def self.handle_error(response, url)
    puts "Error fetching Lever jobs from #{url}: #{response.message} (#{response.code})"
  end

  def self.parse_response(response, company)
    jobs = JSON.parse(response)
    return jobs if jobs.is_a?(Array)

    handle_error_response(jobs, company)
    nil
  rescue JSON::ParserError
    puts "Failed to parse Lever API response for company: #{company.company_name}"
    nil
  end

  def self.handle_error_response(error_response, company)
    error_message = error_response['message'] || 'Unknown error'
    puts "Error fetching Lever jobs for company #{company.company_name}: #{error_message}"
  end
end
