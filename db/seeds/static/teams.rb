# frozen_string_literal: true

teams = [
  { team_name: 'Business Development',
    aliases: ['Sales', 'Sales Team', 'Business Development Team', 'Product/S&O'] },

  { team_name: 'Business Intelligence', aliases: ['BI Team', 'BI', 'Data Analytics'] },

  { team_name: 'Care Operations',
    aliases: ['Care Team', 'Operations Team', 'Operations', 'Member Care'] },

  { team_name: 'Client Services',
    aliases: ['Customer Success', 'Customer Support', 'Strategic Alliances',
              'Customer Operations', 'client engagement'] },

  { team_name: 'Clinical Team',
    aliases: ['Healthcare Team', 'Medical Team', 'Therapy', 'Psychiatry',
              'Clinical Strategy and Services', 'Pharmacy'] },

  { team_name: 'Data Science', aliases: ['Data Team', 'Data Analytics', 'Data Engineering'] },

  { team_name: 'Engineering',
    aliases: ['Development Team', 'Engineering Team', 'Software Engineering', 'DevOps',
              'Infrastructure', 'Site Reliability', 'Cloud Engineering'] },

  { team_name: 'Executive',
    aliases: ['Leadership', 'Management', 'C-Suite', 'Board of Directors'] },

  { team_name: 'Finance', aliases: ['Accounting', 'Financial Planning', 'FP&A', 'Finance Team'] },

  { team_name: 'Human Resources', aliases: ['HR', 'People Operations', 'Talent Acquisition'] },

  { team_name: 'IT',
    aliases: ['Cybersecurity', 'Security Team', 'Information Security', 'Information Technology'] },

  { team_name: 'Internship',
    aliases: ['Interns', 'Internship Team', 'Internship Program', 'fellowship', 'graduate'] },

  { team_name: 'Legal',
    aliases: ['Corporate Law', 'Compliance', 'Legal Affairs', 'regulatory affairs'] },

  { team_name: 'Marketing', aliases: ['Digital Marketing', 'Branding Team'] },

  { team_name: 'Operations',
    aliases: ['Ops', 'Operations Team', 'Operations and Strategy', 'service operations'] },

  { team_name: 'Product',
    aliases: ['Product Development', 'Product Team', 'Design', 'Product/S&O'] },

  { team_name: 'Project Management', aliases: ['PM Team', 'Project Team'] },

  { team_name: 'Public Relations', aliases: ['PR Team', 'Public Affairs', 'Communications'] },

  { team_name: 'Quality Assurance',
    aliases: ['QA Team', 'Quality Control', 'QA', 'quality operations'] },

  { team_name: 'Safety', aliases: ['Environmental Health and Safety'] },

  { team_name: 'Sales',
    aliases: ['Business Development', 'Sales Team', 'reimbursement operations'] },

  { team_name: 'Science', aliases: ['Research', 'R&D', 'Scientific Research', 'medical writing'] },

  { team_name: 'Supply Chain', aliases: ['Logistics', 'Procurement', 'Supply Chain Team'] },

  { team_name: 'Technical Support', aliases: ['Tech Support', 'Help Desk', 'IT Support'] }
]

seeded_count = 0
updated_count = 0
existing_count = 0
Team.count

teams.each do |team|
  team_record = Team.find_or_initialize_by(team_name: team[:team_name])

  if team_record.persisted?
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

total_teams_after = Team.count

puts "*******Seeded #{seeded_count} new teams. Updated #{updated_count} teams. #{existing_count} teams already existed. Total teams in the table: #{total_teams_after}."
