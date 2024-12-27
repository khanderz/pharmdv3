# frozen_string_literal: true

namespace :db do
    desc 'Seed only locations'
    task seed_locations: :environment do
        load File.join(Rails.root, 'db', 'seeds', 'static', 'locations.rb')
        puts '*************Location seeding completed**************'
    end
    end