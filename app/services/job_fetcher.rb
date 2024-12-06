class JobFetcher
    def self.fetch(company)
      case company.ats_type.ats_type_code
      when 'LEVER'
        LeverApiService.fetch_jobs(company)
      when 'GREENHOUSE'
        GreenhouseApiService.fetch_jobs(company)
      else
        puts "Unsupported ATS type for company: #{company.company_name}"
        nil
      end
    end
  end
  