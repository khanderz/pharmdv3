# frozen_string_literal: true

namespace :db do
  desc 'Seed only domains'
  task seed_domains: :environment do
    load File.join(Rails.root, 'db', 'seeds', 'static', 'healthcare_domains.rb')
    puts '*************Domain seeding completed**************'
  end
end
