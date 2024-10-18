job_roles = [
  { role_name: 'Account Manager', aliases: ['Sales Representative', 'Account Exec', 'Client Manager'], department_name: 'Sales', team_name: 'Sales' },
  { role_name: 'Behavioral Health Therapist', aliases: ['Mental Health Counselor', 'Licensed Therapist', 'Remote Therapist'], department_name: 'Clinical Team', team_name: 'Care Operations' },
  { role_name: 'Clinical Pharmacist', aliases: ['Remote Pharmacist', 'Telepharmacy Specialist', 'Pharmacist Consultant'], department_name: 'Clinical Team', team_name: 'Care Operations' },
  { role_name: 'Customer Support Specialist', aliases: ['Customer Service', 'Support Agent', 'Helpdesk'], department_name: 'Customer Support', team_name: 'Client Services' },
  { role_name: 'Data Analyst', aliases: ['Business Intelligence Analyst', 'BI Specialist', 'Data Specialist'], department_name: 'Data Science', team_name: 'Product' },
  { role_name: 'Data Scientist', aliases: ['Machine Learning Engineer', 'AI Specialist', 'Data Researcher'], department_name: 'Data Science', team_name: 'Software Engineering' },
  { role_name: 'Dental Hygienist', aliases: ['Remote Dental Specialist', 'Tele-Dentist', 'Oral Health Expert'], department_name: 'Clinical Team', team_name: 'Care Operations' },
  { role_name: 'Digital Marketing Specialist', aliases: ['SEO Specialist', 'Digital Marketer', 'Marketing Analyst'], department_name: 'Marketing', team_name: 'Marketing' },
  { role_name: 'Healthcare Administrator', aliases: ['Medical Administrator', 'Health Services Manager', 'Remote Healthcare Manager'], department_name: 'Operations', team_name: 'Care Operations' },
  { role_name: 'Marketing Specialist', aliases: ['Marketer', 'Digital Marketer', 'Brand Manager'], department_name: 'Marketing', team_name: 'Marketing' },
  { role_name: 'Nurse Practitioner', aliases: ['Telehealth NP', 'Remote Nurse', 'Virtual Care NP'], department_name: 'Clinical Team', team_name: 'Care Operations' },
  { role_name: 'Occupational Therapist', aliases: ['Remote OT', 'Teletherapy Specialist', 'Virtual OT'], department_name: 'Clinical Team', team_name: 'Care Operations' },
  { role_name: 'Physical Therapist', aliases: ['Remote PT', 'Telehealth PT', 'Virtual Physical Therapist'], department_name: 'Clinical Team', team_name: 'Care Operations' },
  { role_name: 'Product Manager', aliases: ['PM', 'Product Lead', 'Product Owner'], department_name: 'Product Management', team_name: 'Product' },
  { role_name: 'Project Manager', aliases: ['PM', 'Project Lead', 'Operations Manager'], department_name: 'Operations', team_name: 'Product' },
  { role_name: 'Sales Representative', aliases: ['Sales Rep', 'Account Manager', 'Sales Exec'], department_name: 'Sales', team_name: 'Sales' },
  { role_name: 'Software Engineer',   aliases: [
    'Software Developer', 
    'Programmer', 
    'Engineer', 
    'Fullstack Engineer', 
    'Full Stack Developer', 
    'Backend Engineer', 
    'Backend Developer', 
    'Frontend Engineer', 
    'Frontend Developer', 
    'Web Developer', 
    'Full Stack Engineer', 
    'Fullstack Developer', 
    'Mobile Engineer', 
    'Mobile Developer', 
    'iOS Developer', 
    'iOS Engineer', 
    'Android Developer', 
    'Android Engineer', 
    'Swift Developer', 
    'Kotlin Developer', 
    'Front-End Developer', 
    'Back-End Developer'
  ],  department_name: 'Engineering', team_name: 'Software Engineering' },
  { role_name: 'Technical Support Specialist', aliases: ['Tech Support', 'Support Engineer', 'Helpdesk'], department_name: 'IT', team_name: 'Client Services' },
  { role_name: 'UI/UX Designer', aliases: ['User Experience Designer', 'Interface Designer', 'Product Designer'], department_name: 'Design', team_name: 'Product' },
  { role_name: 'Virtual Care Physician', aliases: ['Telemedicine Physician', 'Remote Doctor', 'Remote Physician','Online Doctor'], department_name: 'Clinical Team', team_name: 'Care Operations' }
]

seeded_count = 0
updated_count = 0
existing_count = 0

job_roles.each do |role|
  begin
    department = Department.find_by(dept_name: role[:department_name])
    team = Team.find_by(team_name: role[:team_name])

    if department && team
      role_record = JobRole.find_or_initialize_by(role_name: role[:role_name], department_id: department.id, team_id: team.id)

      if role_record.persisted?
        # Update logic: Check if any changes were made
        changes_made = false

        if role_record.aliases.sort != role[:aliases].sort
          role_record.aliases = role[:aliases]
          changes_made = true
        end

        if changes_made
          role_record.save!
          updated_count += 1
          puts "Updated job role: #{role_record.role_name}."
        else
          existing_count += 1
          puts "No changes for job role: #{role_record.role_name}."
        end
      else
        # Create new role
        role_record.aliases = role[:aliases] if role[:aliases]
        role_record.save!
        seeded_count += 1
        puts "Created new job role: #{role_record.role_name}."
      end
    else
      puts "Error seeding job role: #{role[:role_name]} - Department (#{role[:department_name]}) or Team (#{role[:team_name]}) not found"
    end
  rescue StandardError => e
    puts "Error seeding job role: #{role[:role_name]} - #{e.message}"
  end
end

total_roles_after = JobRole.count

puts "*******Seeded #{seeded_count} new job roles. Updated #{updated_count} roles. #{existing_count} roles already existed. Total job roles in the table: #{total_roles_after}."
