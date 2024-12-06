# app/services/job_fetcher.rb

# RED = "\033[31m"
# RESET = "\033[0m"

class JobFetcher
  def self.fetch(company)
    ats_type_code = company.ats_type.ats_type_code
    case ats_type_code
    when 'LEVER'
      LeverApiService.fetch_jobs(company)
    when 'GREENHOUSE'
      GreenhouseApiService.fetch_jobs(company)
    else
      puts "#{RED}No ATS type code found for #{company.company_name}#{RESET}"
      nil
    end
  end
end
