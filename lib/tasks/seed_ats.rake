# frozen_string_literal: true

namespace :db do
  desc 'Seed only ats'
  task seed_ats: :environment do
    load File.join(Rails.root, 'db', 'seeds', 'static', 'ats_types.rb')
    puts '*************ATS seeding completed**************'
  end
end
