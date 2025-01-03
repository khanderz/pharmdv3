# frozen_string_literal: true

# spec/factories/ats_types.rb
FactoryBot.define do
  factory :ats_type do
    sequence(:ats_type_code) { |n| "ATS#{n}" }
    sequence(:ats_type_name) { |n| "ATS Type #{n}" }
  end
end
