# frozen_string_literal: true

namespace :db do
  desc 'Seed only companies'
  task seed_companies: :environment do
    load File.join(Rails.root, 'db', 'seeds', 'companies.rb')
    puts '*************Company seeding completed**************'
  end
end
