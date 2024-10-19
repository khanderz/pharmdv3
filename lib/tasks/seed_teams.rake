namespace :db do
    desc "Seed only teams"
    task seed_teams: :environment do
        load File.join(Rails.root, "db", "seeds", "static", "teams.rb")
        puts "*************Team seeding completed**************"
    end
    end