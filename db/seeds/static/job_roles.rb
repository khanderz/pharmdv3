job_roles = [
  { role_name: 'Account Manager', aliases: ['Sales Representative', 'Account Exec', 'Client Manager'], department_names: ['Sales'], team_names: ['Sales'] },
  { role_name: 'Behavioral Health Therapist', aliases: ['Mental Health Counselor', 'Licensed Therapist', 'Remote Therapist'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Clinical Pharmacist', aliases: ['Remote Pharmacist', 'Telepharmacy Specialist', 'Pharmacist Consultant'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Customer Support Specialist', aliases: ['Customer Service', 'Support Agent', 'Helpdesk'], department_names: ['Customer Support'], team_names: ['Client Services'] },
  { role_name: 'Data Analyst', aliases: ['Business Intelligence Analyst', 'BI Specialist', 'Data Specialist'], department_names: ['Data Science', 'Product Management'], team_names: ['Product', 'Business Intelligence'] },
  { role_name: 'Data Scientist', aliases: ['Machine Learning Engineer', 'AI Specialist', 'Data Researcher'], department_names: ['Data Science', 'Engineering'], team_names: ['Software Engineering'] },
  { role_name: 'Dental Hygienist', aliases: ['Remote Dental Specialist', 'Tele-Dentist', 'Oral Health Expert'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Digital Marketing Specialist', aliases: ['SEO Specialist', 'Digital Marketer', 'Marketing Analyst'], department_names: ['Marketing'], team_names: ['Marketing'] },
  { role_name: 'Healthcare Administrator', aliases: ['Medical Administrator', 'Health Services Manager', 'Remote Healthcare Manager'], department_names: ['Operations', 'Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Marketing Specialist', aliases: ['Marketer', 'Digital Marketer', 'Brand Manager'], department_names: ['Marketing'], team_names: ['Marketing'] },
  { role_name: 'Nurse Practitioner', aliases: ['Telehealth NP', 'Remote Nurse', 'Virtual Care NP'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Occupational Therapist', aliases: ['Remote OT', 'Teletherapy Specialist', 'Virtual OT'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Physical Therapist', aliases: ['Remote PT', 'Telehealth PT', 'Virtual Physical Therapist'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Product Manager', aliases: ['PM', 'Product Lead', 'Product Owner'], department_names: ['Product Management'], team_names: ['Product'] },
  { role_name: 'Project Manager', aliases: ['PM', 'Project Lead', 'Operations Manager'], department_names: ['Operations', 'Product Management'], team_names: ['Product'] },
  { role_name: 'Sales Representative', aliases: ['Sales Rep', 'Account Manager', 'Sales Exec'], department_names: ['Sales'], team_names: ['Sales'] },
  { role_name: 'Software Engineer', aliases: [
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
  ], department_names: ['Engineering', 'IT'], team_names: ['Software Engineering'] },
  { role_name: 'Technical Support Specialist', aliases: ['Tech Support', 'Support Engineer', 'Helpdesk'], department_names: ['IT', 'Engineering', 'Customer Support'], team_names: ['Client Services', 'Tech Support'] },
  { role_name: 'UI/UX Designer', aliases: ['User Experience Designer', 'Interface Designer', 'Product Designer'], department_names: ['Design', 'Product Management'], team_names: ['Product'] },
  { role_name: 'Virtual Care Physician', aliases: ['Telemedicine Physician', 'Remote Doctor', 'Remote Physician','Online Doctor'], department_names: ['Clinical Team'], team_names: ['Care Operations'] }
]

seeded_count = 0
updated_count = 0
existing_count = 0

job_roles.each do |role|
  begin
    # Find or create the job role itself
    role_record = JobRole.find_or_initialize_by(role_name: role[:role_name])

    changes_made = false

    # Update aliases if different
    if role_record.aliases.sort != role[:aliases].sort
      role_record.aliases = role[:aliases]
      changes_made = true
    end

    if role_record.new_record?
      role_record.save!
      seeded_count += 1
      puts "Created new job role: #{role_record.role_name}."
    else
      role_record.save! if changes_made
      updated_count += 1 if changes_made
      existing_count += 1 unless changes_made
      puts changes_made ? "Updated job role: #{role_record.role_name}." : "No changes for job role: #{role_record.role_name}."
    end

    # Associate with departments
    role[:department_names].each do |dept_name|
      department = Department.find_by(dept_name: dept_name)
      if department
        unless role_record.departments.include?(department)
          role_record.departments << department
          puts "Associated #{role_record.role_name} with department #{dept_name}."
        end
      else
        puts "Error: Department #{dept_name} not found for role #{role_record.role_name}."
      end
    end

    # Associate with teams
    role[:team_names].each do |team_name|
      team = Team.find_by(team_name: team_name)
      if team
        unless role_record.teams.include?(team)
          role_record.teams << team
          puts "Associated #{role_record.role_name} with team #{team_name}."
        end
      else
        puts "Error: Team #{team_name} not found for role #{role_record.role_name}."
      end
    end

  rescue StandardError => e
    puts "Error seeding job role: #{role[:role_name]} - #{e.message}"
  end
end

total_roles_after = JobRole.count
puts "*******Seeded #{seeded_count} new job roles. Updated #{updated_count} roles. #{existing_count} roles already existed. Total job roles in the table: #{total_roles_after}."