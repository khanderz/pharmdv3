json.extract! company, :id, :company_name, :operating_status, :linkedin_url,
              :company_url, :year_founded, :acquired_by, :company_description,
              :logo_url, :company_tagline, :is_completely_remote

json.company_size company.company_size.size_range if company.company_size.present?
json.ats_type company.ats_type.ats_type_name if company.ats_type.present?

json.countries company.company_countries.map { |cc| cc.country.country_name } if company.company_countries.present?
json.states company.company_states.map { |cs| cs.state.state_name } if company.company_states.present?
json.cities company.company_cities.map { |cc| cc.city.city_name } if company.company_cities.present?

json.specializations company.company_specializations.map { |spec| spec.company_specialty.attributes.slice('key', 'value') } if company.company_specializations.present?

json.domains company.company_domains.map { |domain| domain.healthcare_domain.attributes.slice('key', 'value') } if company.company_domains.present?

json.job_posts company.job_posts.map { |job| job.attributes.slice('job_title', 'job_description', 'job_active') } if company.job_posts.present?
