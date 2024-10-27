# frozen_string_literal: true

json.extract! company, :id, :company_name, :operating_status, :company_type, :company_type_value, :company_ats_type,
              :company_size, :last_funding_type, :linkedin_url, :is_public, :year_founded, :company_city, :company_state, :company_country, :acquired_by, :ats_id, :created_at, :updated_at
json.url company_url(company, format: :json)
