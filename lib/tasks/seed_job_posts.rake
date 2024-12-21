# frozen_string_literal: true

namespace :db do
  desc 'Seed only job posts with optional validation flag'
  task seed_job_posts: :environment do

    load File.join(Rails.root, 'db', 'seeds', 'job_posts.rb')

    if defined?(JobPost)
      JobPost.fetch_and_save_jobs(SomeCompanyModel.all )
    end

    puts '*************Job Post seeding completed**************'
  end
end
