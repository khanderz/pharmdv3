# frozen_string_literal: true

# spec/factories/locations.rb
FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Location #{n}" }
    sequence(:code) { |n| "LOC#{n}" }
    location_type { 'City' }
    parent_id { nil }
  end
end
