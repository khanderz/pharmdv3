class JobDataMapper
    def self.map(company, job)
      ats_code = company.ats_type.ats_type_code
      case ats_code
      when 'LEVER'
        LeverDataMapper.map(job, company)
      when 'GREENHOUSE'
        GreenhouseDataMapper.map(job, company)
      end
    end
  
    def self.url(company, job)
      ats_code = company.ats_type.ats_type_code
      case ats_code
      when 'LEVER'
        job['hostedUrl']
      when 'GREENHOUSE'
        job['absolute_url']
      end
    end
  end
  