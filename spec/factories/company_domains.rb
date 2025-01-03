# frozen_string_literal: true

# spec/factories/company_domains.rb
FactoryBot.define do
  factory :company_domain do
    association :company
    association :healthcare_domain
  end
end
