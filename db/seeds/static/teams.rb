# Seeding common teams in job posts
teams = [
  { team_name: 'Clinical Team', aliases: ['Healthcare Team', 'Medical Team'] },
  { team_name: 'Software Engineering', aliases: ['Development Team', 'Engineering Team'] },
  { team_name: 'Care Operations', aliases: ['Care Team', 'Operations Team'] },
  { team_name: 'Product Management', aliases: ['PM Team', 'Product Team'] },
  { team_name: 'Client Services', aliases: ['Customer Success', 'Customer Support'] },
  { team_name: 'Product', aliases: ['Product Development', 'Product Team'] },
  { team_name: 'Marketing', aliases: ['Digital Marketing', 'Branding Team'] },
  { team_name: 'Sales', aliases: ['Business Development', 'Sales Team'] },
  { team_name: 'Information Security', aliases: ['Cybersecurity', 'Security Team'] },
]

teams.each do |team|
  begin
    Team.find_or_create_by!(team_name: team[:team_name], aliases: team[:aliases])
  rescue StandardError => e
    puts "Error seeding team: #{team[:team_name]} - #{e.message}"
  end
end

puts "*************Seeded common teams in job posts"
