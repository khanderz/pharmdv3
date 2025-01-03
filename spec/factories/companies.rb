# frozen_string_literal: true

# spec/factories/companies.rb
FactoryBot.define do
  factory :company do
    sequence(:company_name) { |n| "Test Company #{n}" }
    operating_status { true }
    sequence(:linkedin_url) { |n| "https://linkedin.com/company/test-company-#{n}" }
    sequence(:company_url) { |n| "https://testcompany#{n}.com" }
    year_founded { rand(1900..2023) }
    company_description { 'A description for Test Company' }
    ats_id { "ATS-#{rand(1000..9999)}" }
    logo_url { "https://example.com/logo#{rand(1..100)}.png" }
    company_tagline { 'Innovating the Future' }
    is_completely_remote { true }
    ats_type
    company_size { nil }
    funding_type { nil }
    company_type { nil }

    transient do
      create_domains { false } 
    end

    # Associations
    after(:create) do |company, evaluator|
      if evaluator.create_domains
        create(:company_domain, company: company, healthcare_domain: create(:healthcare_domain))
      end
    end

    transient do
      healthcare_domain { [] }
    end

    trait :with_associations do
      ats_type
      company_size
      funding_type
      company_type
    end
  end
end
