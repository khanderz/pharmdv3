# frozen_string_literal: true

namespace :db do
  desc 'Seed only departments'
  task seed_dept: :environment do
    load File.join(Rails.root, 'db', 'seeds', 'static', 'departments.rb')
    puts '*************Department seeding completed**************'
  end
end
