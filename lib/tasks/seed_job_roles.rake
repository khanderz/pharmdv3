namespace :db do
    desc "Seed only job roles"
    task seed_job_roles: :environment do
      load File.join(Rails.root, "db", "seeds", "static", "job_roles.rb")
      puts "*************Job role seeding completed**************"
    end
  end