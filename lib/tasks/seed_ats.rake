# frozen_string_literal: true

namespace :db do
  desc 'seed ats types'
  task seed_ats: :environment do
    load File.join(Rails.root, 'db', 'seeds', 'static', 'ats_types.rb')
    puts '*************ATS types seeding completed**************'
  end
end
