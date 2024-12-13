# frozen_string_literal: true

json.extract! company, :id, :company_name, :operating_status, :linkedin_url,
              :company_url, :year_founded, :acquired_by, :company_description,
              :logo_url, :company_tagline, :is_completely_remote

json.company_size company.company_size.size_range if company.company_size.present?
json.ats_type company.ats_type.ats_type_name if company.ats_type.present?

if company.company_countries.present?
  json.countries(company.company_countries.map do |cc|
    cc.country.country_name
  end)
end
if company.company_states.present?
  json.states(company.company_states.map do |cs|
    cs.state.state_name
  end)
end
if company.company_cities.present?
  json.cities(company.company_cities.map do |cc|
    cc.city.city_name
  end)
end

if company.company_specializations.present?
  json.specializations(company.company_specializations.map do |spec|
    spec.company_specialty.attributes.slice('key',
                                            'value')
  end)
end

if company.company_domains.present?
  json.domains(company.company_domains.map do |domain|
    domain.healthcare_domain.attributes.slice('key', 'value')
  end)
end

if company.job_posts.present?
  json.job_posts(company.job_posts.map do |job|
    job.attributes.slice('job_title', 'job_description', 'job_active')
  end)
end
