teams = [
  { team_name: 'Business Development', aliases: ['Sales', 'Sales Team', 'Business Development Team'] },  
  { team_name: 'Care Operations', aliases: ['Care Team', 'Operations Team', 'Operations', 'Member Care'] },
  { team_name: 'Client Services', aliases: ['Customer Success', 'Customer Support', 'Strategic Alliances'] },
  { team_name: 'Clinical Team', aliases: ['Healthcare Team', 'Medical Team', 'Therapy', 'Psychiatry', 'Clinical Strategy and Services'] },
  { team_name: 'Information Security', aliases: ['Cybersecurity', 'Security Team', 'Information Technology'] },
  { team_name: 'Finance', aliases: ['Accounting', 'Financial Planning', 'FP&A', 'Finance Team'] },
  { team_name: 'Marketing', aliases: ['Digital Marketing', 'Branding Team'] },
  { team_name: 'Product', aliases: ['Product Development', 'Product Team', 'Design'] },
  { team_name: 'Product Management', aliases: ['PM Team', 'Product Team'] },
  { team_name: 'Sales', aliases: ['Business Development', 'Sales Team'] },
  { team_name: 'Software Engineering', aliases: ['Development Team', 'Engineering Team', 'Engineering'] },
  { team_name: 'Tech Support', aliases: ['Technical Support', 'Help Desk', 'IT Support'] },
  { team_name: 'Data Science', aliases: ['Data Team', 'Data Analytics', 'Data Engineering'] },
  { team_name: 'Business Intelligence', aliases: ['BI Team', 'BI', 'Data Analytics'] },
  { team_name: 'DevOps', aliases: ['Infrastructure', 'Site Reliability', 'Cloud Engineering'] }
]

seeded_count = 0
updated_count = 0
existing_count = 0
total_teams = Team.count

teams.each do |team|
  begin
    team_record = Team.find_or_initialize_by(team_name: team[:team_name])

    if team_record.persisted?
      # Check if the aliases need to be updated
      if team_record.aliases.sort != team[:aliases].sort
        team_record.aliases = team[:aliases]
        team_record.save!
        updated_count += 1
        puts "Updated aliases for team: #{team[:team_name]}"
      else
        existing_count += 1
      end
    else
      team_record.aliases = team[:aliases]
      team_record.save!
      seeded_count += 1
      puts "Created new team: #{team[:team_name]}"
    end
  rescue StandardError => e
    puts "Error seeding team: #{team[:team_name]} - #{e.message}"
  end
end

total_teams_after = Team.count

puts "*******Seeded #{seeded_count} new teams. Updated #{updated_count} teams. #{existing_count} teams already existed. Total teams in the table: #{total_teams_after}."
