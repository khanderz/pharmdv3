# frozen_string_literal: true

# spec/factories/company_sizes.rb
FactoryBot.define do
  factory :company_size do
    sequence(:size_range) { |n| "#{n * 10}-#{n * 10 + 9}" }
  end
end
