# frozen_string_literal: true

namespace :db do
  desc 'Seed currencies'
  task seed_currencies: :environment do
    load File.join(Rails.root, 'db', 'seeds', 'static', 'currency.rb')
    puts '*************Currency seeding completed**************'
  end
end
