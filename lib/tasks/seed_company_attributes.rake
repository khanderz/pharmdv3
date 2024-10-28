# frozen_string_literal: true

namespace :db do
  desc 'Seed only company attributes'
  task seed_company_attributes: :environment do
    # 3. ATS types
    load File.join(Rails.root, 'db', 'seeds', 'static', 'ats_types.rb')

    # 4. Company sizes
    load File.join(Rails.root, 'db', 'seeds', 'static', 'company_sizes.rb')

    # 5. Countries
    load File.join(Rails.root, 'db', 'seeds', 'static', 'countries.rb')

    # 6. States
    load File.join(Rails.root, 'db', 'seeds', 'static', 'states.rb')

    # 7. Cities
    load File.join(Rails.root, 'db', 'seeds', 'static', 'cities.rb')

    # 8. Funding types
    load File.join(Rails.root, 'db', 'seeds', 'static', 'funding_types.rb')
    puts '*************Company ats, size, countires, states, cities, funding types seeding completed**************'
  end
end
