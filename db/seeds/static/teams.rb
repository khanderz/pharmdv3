# Seeding common teams in job posts
teams = [
  { team_name: 'Care Operations', aliases: ['Care Team', 'Operations Team'] },
  { team_name: 'Client Services', aliases: ['Customer Success', 'Customer Support'] },
  { team_name: 'Clinical Team', aliases: ['Healthcare Team', 'Medical Team'] },
  { team_name: 'Information Security', aliases: ['Cybersecurity', 'Security Team'] },
  { team_name: 'Marketing', aliases: ['Digital Marketing', 'Branding Team'] },
  { team_name: 'Product', aliases: ['Product Development', 'Product Team'] },
  { team_name: 'Product Management', aliases: ['PM Team', 'Product Team'] },
  { team_name: 'Sales', aliases: ['Business Development', 'Sales Team'] },
  { team_name: 'Software Engineering', aliases: ['Development Team', 'Engineering Team'] }
]

seeded_count = 0
existing_count = 0
total_teams = Team.count

teams.each do |team|
  begin
    team_record = Team.find_or_initialize_by(team_name: team[:team_name])

    if team_record.persisted?
      existing_count += 1
    else
      team_record.aliases = team[:aliases]
      team_record.save!
      seeded_count += 1
    end
  rescue StandardError => e
    puts "Error seeding team: #{team[:team_name]} - #{e.message}"
  end
end

total_teams_after = Team.count

puts "*******Seeded #{seeded_count} new teams. #{existing_count} teams already existed. Total teams in the table: #{total_teams_after}."
