# frozen_string_literal: true

# spec/factories/healthcare_domains.rb
FactoryBot.define do
  factory :healthcare_domain do
    sequence(:key) { |n| "domain_key_#{n}" }
    sequence(:value) { |n| "Domain Value #{n}" }
  end
end
