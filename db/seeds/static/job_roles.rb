# Seeding common job roles with aliases
job_roles = [
  { role_name: 'Account Manager', aliases: ['Sales Representative', 'Account Exec', 'Client Manager'] },
  { role_name: 'Behavioral Health Therapist', aliases: ['Mental Health Counselor', 'Licensed Therapist', 'Remote Therapist'] },
  { role_name: 'Clinical Pharmacist', aliases: ['Remote Pharmacist', 'Telepharmacy Specialist', 'Pharmacist Consultant'] },
  { role_name: 'Customer Support Specialist', aliases: ['Customer Service', 'Support Agent', 'Helpdesk'] },
  { role_name: 'Data Analyst', aliases: ['Business Intelligence Analyst', 'BI Specialist', 'Data Specialist'] },
  { role_name: 'Data Scientist', aliases: ['Machine Learning Engineer', 'AI Specialist', 'Data Researcher'] },
  { role_name: 'Dental Hygienist', aliases: ['Remote Dental Specialist', 'Tele-Dentist', 'Oral Health Expert'] },
  { role_name: 'Digital Marketing Specialist', aliases: ['SEO Specialist', 'Digital Marketer', 'Marketing Analyst'] },
  { role_name: 'Healthcare Administrator', aliases: ['Medical Administrator', 'Health Services Manager', 'Remote Healthcare Manager'] },
  { role_name: 'Marketing Specialist', aliases: ['Marketer', 'Digital Marketer', 'Brand Manager'] },
  { role_name: 'Nurse Practitioner', aliases: ['Telehealth NP', 'Remote Nurse', 'Virtual Care NP'] },
  { role_name: 'Occupational Therapist', aliases: ['Remote OT', 'Teletherapy Specialist', 'Virtual OT'] },
  { role_name: 'Physical Therapist', aliases: ['Remote PT', 'Telehealth PT', 'Virtual Physical Therapist'] },
  { role_name: 'Product Manager', aliases: ['PM', 'Product Lead', 'Product Owner'] },
  { role_name: 'Project Manager', aliases: ['PM', 'Project Lead', 'Operations Manager'] },
  { role_name: 'Sales Representative', aliases: ['Sales Rep', 'Account Manager', 'Sales Exec'] },
  { role_name: 'Software Engineer', aliases: ['Developer', 'Programmer', 'Engineer'] },
  { role_name: 'Technical Support Specialist', aliases: ['Tech Support', 'Support Engineer', 'Helpdesk'] },
  { role_name: 'UI/UX Designer', aliases: ['User Experience Designer', 'Interface Designer', 'Product Designer'] },
  { role_name: 'Virtual Care Physician', aliases: ['Telemedicine Physician', 'Remote Doctor', 'Online Doctor'] }
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
