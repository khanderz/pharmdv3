# frozen_string_literal: true

# factories/job_roles.rb
FactoryBot.define do
  factory :job_role do
    sequence(:role_name) { |n| "Role #{n}" }
  end
end
