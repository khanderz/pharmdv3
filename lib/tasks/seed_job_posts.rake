namespace :db do
    desc "Seed only job posts"
    task seed_job_posts: :environment do
        load File.join(Rails.root, "db", "seeds", "job_posts.rb")
        puts "*************Job Post seeding completed**************"
    end
    end