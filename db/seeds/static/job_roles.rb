# Seeding common job roles with aliases
job_roles = [
  { role_name: 'Software Engineer', aliases: ['Developer', 'Programmer', 'Engineer'] },
  { role_name: 'Product Manager', aliases: ['PM', 'Product Lead', 'Product Owner'] },
  { role_name: 'Marketing Specialist', aliases: ['Marketer', 'Digital Marketer', 'Brand Manager'] },
  { role_name: 'Sales Representative', aliases: ['Sales Rep', 'Account Manager', 'Sales Exec'] },
  { role_name: 'Customer Support Specialist', aliases: ['Customer Service', 'Support Agent', 'Helpdesk'] }
]

seeded_count = 0
existing_count = 0
total_roles = JobRole.count

job_roles.each do |role|
  begin
    role_record = JobRole.find_or_initialize_by(role_name: role[:role_name])

    if role_record.persisted?
      existing_count += 1
    else
      role_record.aliases = role[:aliases]
      role_record.save!
      seeded_count += 1
    end
  rescue StandardError => e
    puts "Error seeding job role: #{role[:role_name]} - #{e.message}"
  end
end

total_roles_after = JobRole.count

puts "*******Seeded #{seeded_count} new job roles. #{existing_count} roles already existed. Total job roles in the table: #{total_roles_after}."
