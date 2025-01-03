# frozen_string_literal: true

# spec/factories/job_posts.rb
FactoryBot.define do
  factory :job_post do
    job_role { create(:job_role) }
    company
    job_active { true }
    job_title { 'Software Engineer' }
    job_description { 'Description for the job' }
    sequence(:job_url) { |n| "https://example.com/job/#{n}" }
    job_posted { Time.now }
    job_salary_min { 50_000 }
    job_salary_max { 100_000 }
  end
end
