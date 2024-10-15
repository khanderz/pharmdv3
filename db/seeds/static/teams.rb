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
    # Look up team by name or alias
    team_record = Team.find_by("team_name = ? OR ? = ANY(aliases)", team[:team_name], team[:team_name])

    if team_record.nil?
      # Create a new team if not found
      team_record = Team.new(team_name: team[:team_name], aliases: team[:aliases])
      
      if team_record.save
        seeded_count += 1
        puts "Seeded new team: #{team[:team_name]}"
      else
        # Send to adjudication if team cannot be saved
        Adjudication.create!(
          table_name: 'teams',
          error_details: "Failed to seed team: #{team[:team_name]}",
          reference_id: nil,
          resolved: false
        )
        puts "Error seeding team: #{team[:team_name]} - sent to adjudications"
      end
    else
      existing_count += 1
    end
  rescue StandardError => e
    puts "Error seeding team: #{team[:team_name]} - #{e.message}"
  end
end

total_teams_after = Team.count

puts "*******Seeded #{seeded_count} new teams. #{existing_count} teams already existed. Total teams in the table: #{total_teams_after}."
