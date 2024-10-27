# frozen_string_literal: true

namespace :db do
    desc 'Seed only specialties'
    task seed_specialties: :environment do
        load File.join(Rails.root, 'db', 'seeds', 'static', 'company_specialties.rb')
        puts '*************Specialty seeding completed**************'
    end
    end