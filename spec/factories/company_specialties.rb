# frozen_string_literal: true

# spec/factories/company_specialties.rb
FactoryBot.define do
  factory :company_specialty do
    key { 'specialty_key' }
    value { 'Specialty Value' }
  end
end
