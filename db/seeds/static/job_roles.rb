# frozen_string_literal: true

job_roles = [
  { role_name: 'Account Manager',
    aliases: ['Sales Representative', 'Account Exec', 'Client Manager', 'Account Executive'], department_names: ['Sales'], team_names: ['Sales'] },
  { role_name: 'Community Health Worker',
    aliases: ['CHW', 'Community Health Specialist', 'Community Health Advocate', 'Community Health Coordinator'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Counsel',
    aliases: ['Legal Counsel', 'Legal Advisor', 'Legal Specialist', 'Legal Analyst', 'Legal Consultant'], department_names: ['Legal'], team_names: ['Legal'] },
  { role_name: 'Customer Support Specialist',
    aliases: ['Contact Center Quality', 'Customer Service', 'Support Agent', 'Helpdesk', 'customer success manager', 'Customer Support Manager', 'Customer Support Training Specialist', 'Training Specialist', 'Trust and Safety Analyst', 'Voice Customer Service Representative'], department_names: ['Customer Support'], team_names: ['Client Services'] },
  { role_name: 'Data Scientist',
    aliases: ['Data Analyst', 'Statistician', 'Business Intelligence Analyst', 'BI Specialist', 'Data Specialist', 'Sales Data Analyst', 'Data Researcher'], department_names: ['Data Science', 'Engineering'], team_names: ['Software Engineering', 'Business Intelligence'] },
  { role_name: 'Dental Hygienist',
    aliases: ['Remote Dental Specialist', 'Tele-Dentist', 'Oral Health Expert'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'DevOps Engineer',
    aliases: ['Site Reliability Engineer', 'Cloud Engineer', 'Infrastructure Engineer'], department_names: %w[Engineering IT], team_names: %w[DevOps Infrastructure] },
  { role_name: 'Digital Marketing Specialist',
    aliases: ['SEO Specialist', 'Digital Marketer', 'Marketing Analyst'], department_names: ['Marketing'], team_names: ['Marketing'] },
  { role_name: 'Engineering Manager',
    aliases: ['Engineering Lead', 'Engineering Director', 'Software Engineering Manager'], department_names: ['Engineering'], team_names: ['Software Engineering'] },
  { role_name: 'General Manager',
    aliases: ['GM', 'Operations Manager', 'Business Manager', 'Branch Manager', 'Store Manager', 'Market Owner'], department_names: ['Operations'], team_names: ['Operations'] },
  { role_name: 'Graduate',
    aliases: ['Intern', 'Internship', 'Fellow', 'Resident', 'Trainee', 'Apprentice', 'New Graduate Product Leadership Program', 'new graduate'], department_names: %w[Internship sales], team_names: %w[Internship sales] },
  { role_name: 'Healthcare Administrator',
    aliases: ['Medical Administrator', 'Health Services Manager', 'Remote Healthcare Manager'], department_names: ['Operations', 'Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Machine Learning Engineer',
    aliases: ['AI Engineer', 'ML Engineer', 'artificial intelligence engineer'], department_names: ['Engineering'], team_names: ['Software Engineering'] },
  { role_name: 'Marketing Specialist',
    aliases: ['Marketer', 'Digital Marketer', 'Brand Manager', 'Marketing Manager'], department_names: ['Marketing'], team_names: ['Marketing'] },
  { role_name: 'Marketing Manager', aliases: ['Brand Manager', 'Product Marketing Manager'],
    department_names: ['Marketing'], team_names: ['Marketing'] },
  { role_name: 'New Verticals Founder',
    aliases: ['New Verticals Lead', 'New Verticals Manager', 'New Verticals Director', 'New Verticals Specialist'], department_names: ['Operations', 'Product Management', 'Strategy & Operations'], team_names: ['Product', 'Product/S&O'] },
  { role_name: 'Nurse',
    aliases: ['Registered Nurse', 'RN', 'Remote Nurse', 'Telehealth Nurse', 'Virtual Care Nurse', 'Nurse Care Manager', 'Nurse Investigator'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Nurse Care Manager',
    aliases: ['Nurse Case Manager', 'Remote Nurse Care Manager', 'Telehealth Nurse Care Manager', 'Virtual Care Nurse Care Manager'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Nurse Practitioner',
    aliases: ['Telehealth NP', 'Remote Nurse', 'Virtual Care NP', 'Licensed Nurse Practitioner'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Occupational Therapist',
    aliases: ['Remote OT', 'Teletherapy Specialist', 'Virtual OT'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Operations Associate',
    aliases: ['Operations Specialist', 'Operations Analyst', 'Operations Coordinator', 'Operations Writer', 'Knowledge operations writer', 'product operations associate', 'Strategy & Operations'], department_names: ['Operations', 'People Operations'], team_names: ['Operations'] },
  { role_name: 'Pharmacist',
    aliases: ['Remote Pharmacist', 'Telepharmacy Specialist', 'Pharmacist Consultant', 'Clinical Pharmacist', 'Informatics Pharmacist'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Pharmacy Technician',
    aliases: ['Remote Pharmacy Technician', 'Telepharmacy Technician', 'Pharmacy Tech', 'Pharmacy Specialist', 'Pharm Tech'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Physical Therapist',
    aliases: ['Remote PT', 'Telehealth PT', 'Virtual Physical Therapist'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Physician',
    aliases: ['Telemedicine Physician', 'Remote Doctor', 'Remote Physician', 'Virtual Care Physician', 'Palliative Care Physician'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Product Manager', aliases: ['PM', 'Product Lead', 'Product Owner'],
    department_names: ['Product Management'], team_names: ['Product'] },
  { role_name: 'Project Manager',
    aliases: ['PM', 'Project Lead', 'Operations Manager', 'Client Implementation Manager'], department_names: ['Operations', 'Product Management'], team_names: ['Product'] },
  { role_name: 'Psychiatrist',
    aliases: ['Mental Health Counselor', 'Licensed Therapist', 'Remote Therapist', 'Licensed Mental Health Therapist', 'Licensed Psychiatrist', 'Behavioral Health Therapist', 'Therapist', 'Mental Health Therapist'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Psychologist',
    aliases: ['Licensed Psychologist', 'Remote Psychologist', 'Telepsychologist', 'Clinical Psychologist', 'Behavioral Health Psychologist'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Recruiter',
    aliases: ['Talent Acquisition Specialist', 'HR Recruiter', 'Technical Recruiter', 'Recruitment Specialist'], department_names: ['Human Resources'], team_names: ['Human Resources'] },
  { role_name: 'Registered Dietitian', aliases: ['RD', 'Telehealth Dietitian', 'Remote Dietitian', 'Virtual Dietitian'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Remote Patient Monitoring Specialist', aliases: ['RPM Specialist', 'Remote Monitoring Specialist', 'Telehealth Specialist', 'Virtual Care Specialist'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },
  { role_name: 'Research Scientist', aliases: ['Researcher', 'Scientist', 'Research Analyst', 'Research Associate', 'AI Research Scientist'],
    department_names: ['Science'], team_names: ['Science'] },
  { role_name: 'Sales Representative',
    aliases: ['Sales Rep', 'Account Manager', 'Sales Exec', 'Sales', 'Core Sales'], department_names: ['Sales'], team_names: ['Sales'] },
  { role_name: 'Security Engineer',
    aliases: ['Information Security Engineer', 'Cybersecurity Engineer', 'Security Analyst', 'Application Security Engineer'], department_names: %w[Engineering IT], team_names: ['Information Security'] },
  { role_name: 'Software Engineer',
    aliases: ['Software Developer', 'Programmer', 'Engineer', 'Fullstack Engineer', 'full stack engineer', 'Backend Engineer', 'Frontend Engineer', 'fullstack developer', 'frontend developer', 'backend developer', 'full stack developer', 'mobile engineer', 'mobile software engineer', 'android engineer', 'ios engineer'], department_names: %w[Engineering IT], team_names: ['Software Engineering'] },
  { role_name: 'Solutions Engineer',
    aliases: ['Pre-Sales Engineer', 'Sales Engineer', 'Technical Sales Engineer', 'Solutions Architect'], department_names: %w[Sales Engineering], team_names: ['Sales', 'Software Engineering'] },
  { role_name: 'Technical Support Specialist',
    aliases: ['Tech Support', 'Support Engineer', 'Helpdesk'], department_names: ['IT', 'Engineering', 'Customer Support'], team_names: ['Client Services', 'Tech Support'] },
  { role_name: 'UI/UX Designer',
    aliases: ['User Experience Designer', 'Interface Designer', 'Product Designer'], department_names: ['Design', 'Product Management'], team_names: ['Product'] },

  # C-Level Roles
  { role_name: 'Associate Director of Business Development',
    aliases: ['Associate Business Development Director'], department_names: ['Sales', 'Business Development'], team_names: ['Sales', 'Business Development'] },
  { role_name: 'Associate Director of Data Science', aliases: ['Associate Data Science Director'],
    department_names: ['Data Science'], team_names: ['Data Science'] },
  { role_name: 'Associate Director of Engineering', aliases: ['Associate Engineering Director'],
    department_names: ['Engineering'], team_names: ['Software Engineering'] },
  { role_name: 'Associate Director of Operations', aliases: ['Associate Operations Director'],
    department_names: ['Operations'], team_names: ['Operations'] },
  { role_name: 'Associate Director of Product Management',
    aliases: ['Associate Product Management Director'], department_names: ['Product Management'], team_names: ['Product'] },
  { role_name: 'Associate Director of Quality',
    aliases: ['Associate Clinical Quality Assurance', 'Associate Director of Quality Assurance', 'Associate Director of Clinical Quality Assurance'], department_names: ['Quality'], team_names: ['Quality Assurance'] },
  { role_name: 'Chief Clinical Officer', aliases: ['CCO'], department_names: ['Clinical Team'],
    team_names: ['Care Operations'] },
  { role_name: 'Chief Compliance Officer', aliases: ['CCO'], department_names: ['Legal'],
    team_names: ['Legal'] },
  {
    role_name: 'Chief Data Officer', aliases: ['CDO', 'chief of data', 'chief of data science'], department_names: ['Data Science'],
    team_names: ['Data Science']
  },
  { role_name: 'Chief Executive Officer', aliases: ['CEO'], department_names: ['Executive'],
    team_names: ['Executive'] },
  { role_name: 'Chief Financial Officer', aliases: ['CFO'], department_names: ['Finance'],
    team_names: ['Finance'] },
  { role_name: 'Chief Information Security Officer', aliases: ['CISO'],
    department_names: %w[IT Engineering], team_names: ['Information Security'] },
  { role_name: 'Chief Marketing Officer', aliases: ['CMO'], department_names: ['Marketing'],
    team_names: ['Marketing'] },
  { role_name: 'Chief Medical Officer', aliases: ['CMO'], department_names: ['Clinical Team'],
    team_names: ['Care Operations'] },
  { role_name: 'Chief Operating Officer', aliases: ['COO'], department_names: ['Operations'],
    team_names: ['Operations'] },
  { role_name: 'Chief Product Officer', aliases: ['CPO'], department_names: ['Product Management'],
    team_names: ['Product'] },
  { role_name: 'Chief Revenue Officer', aliases: ['CRO'], department_names: ['Sales'],
    team_names: ['Sales'] },
  { role_name: 'Chief Staff Officer', aliases: ['COS', 'chief of human resources', 'chief of staff'], department_names: ['Executive', 'Human Resources'],
    team_names: ['Executive'] },
  { role_name: 'Chief Technology Officer', aliases: ['CTO'], department_names: ['Engineering'],
    team_names: ['Engineering'] },

  { role_name: 'Director of Business Development', aliases: ['Business Development Director'],
    department_names: ['Sales', 'Business Development'], team_names: ['Sales', 'Business Development'] },
  { role_name: 'Director of Data Science', aliases: ['Data Science Director', 'data officer'],
    department_names: ['Data Science'], team_names: ['Data Science'] },
  { role_name: 'Director of Engineering', aliases: ['Engineering Director'],
    department_names: ['Engineering'], team_names: ['Software Engineering'] },
  { role_name: 'Director of Operations', aliases: ['Operations Director'],
    department_names: ['Operations'], team_names: ['Operations'] },
  { role_name: 'Director of Product Management', aliases: ['Product Management Director'],
    department_names: ['Product Management'], team_names: ['Product'] },
  { role_name: 'Director of Quality', aliases: ['Clinical Quality Assurance'],
    department_names: ['Quality'], team_names: ['Quality Assurance'] },
  { role_name: 'Director of Sales', aliases: ['Sales Director'],
    department_names: ['Sales'], team_names: ['Sales'] },
  { role_name: 'Director of Staff', aliases: ['Staff Director', 'director of human resources'],
    department_names: ['Human Resources'], team_names: ['Human Resources'] },
  { role_name: 'Director of Communications', aliases: ['Communications Director'],
    department_names: ['Communications'], team_names: ['Communications'] },
  { role_name: 'Director of Finance and Accounting', aliases: ['Finance Director', 'Accounting Director'],
    department_names: %w[Finance Accounting], team_names: %w[Finance Accounting] },
  { role_name: 'Director of Science', aliases: ['Science Director', 'director of protein therapeutics'],
    department_names: ['Science'], team_names: ['Science'] },
  { role_name: 'Director of Information Technology', aliases: ['IT Director', 'Information Technology Director', 'director of it', 'director of information technology'],
    department_names: ['Information Technology', 'IT'], team_names: ['IT'] },

  { role_name: 'Head of Customer Success', aliases: ['Customer Success Lead'],
    department_names: ['Customer Support'], team_names: ['Client Services'] },
  { role_name: 'Head of DevOps', aliases: ['DevOps Lead'], department_names: %w[IT Engineering],
    team_names: ['DevOps'] },
  { role_name: 'Head of Growth', aliases: ['Growth Lead'], department_names: %w[Marketing Product],
    team_names: ['Business Development', 'Marketing'] },
  { role_name: 'Head of People', aliases: ['Head of HR', 'HR Lead'],
    department_names: ['Human Resources'], team_names: ['Human Resources'] },
  { role_name: 'Head of Science', aliases: ['Head of Research', 'head of ai research', 'head of ai science'],
    department_names: ['Science'], team_names: ['Science'] },

  { role_name: 'President of Engineering', aliases: ['President of Engineering'],
    department_names: ['Engineering'], team_names: ['Software Engineering'] },
  { role_name: 'President of Finance', aliases: ['President of Finance'],
    department_names: ['Finance'], team_names: ['Finance'] },
  { role_name: 'President of Marketing', aliases: ['President of Marketing'],
    department_names: ['Marketing'], team_names: ['Marketing'] },
  { role_name: 'President of Product', aliases: ['President of Product'],
    department_names: ['Product Management'], team_names: ['Product'] },
  { role_name: 'President of Sales', aliases: ['President of Sales'],
    department_names: ['Sales'], team_names: ['Sales'] },
  { role_name: 'President of Science', aliases: ['President of Research', 'president of ai research', 'president of ai science'],
    department_names: ['Science'], team_names: ['Science'] },

  { role_name: 'Vice President of Engineering', aliases: ['VP Engineering'],
    department_names: ['Engineering'], team_names: ['Software Engineering'] },
  { role_name: 'Vice President of Finance',
    aliases: ['VP Financial Operations', 'Vice President, Analytics & Financial Operations', 'Vice President, Financial Planning & Analysis', 'VP Financial Planning & Analysis'],
    department_names: ['Finance'], team_names: ['Finance'] },
  { role_name: 'Vice President of Marketing', aliases: ['VP Marketing'],
    department_names: ['Marketing'], team_names: ['Marketing'] },
  { role_name: 'Vice President of Product', aliases: ['VP Product'],
    department_names: ['Product Management'], team_names: ['Product'] },
  { role_name: 'Vice President of Sales', aliases: ['VP Sales'],
    department_names: ['Sales'], team_names: ['Sales'] },
  { role_name: 'Vice President of Science', aliases: ['VP Research', 'VP AI Research', 'VP AI Science',
                                                      'vice president of ai research', 'vice president of ai science', 'vice president of research'],
    department_names: ['Science'], team_names: ['Science'] }
]

seeded_count = 0
updated_count = 0
existing_count = 0

job_roles.each do |role|
  role_record = JobRole.find_or_initialize_by(role_name: role[:role_name])

  changes_made = false

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

  role[:department_names].each do |dept_name|
    department = Department.find_by('LOWER(dept_name) = ? OR LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                                    dept_name.downcase, dept_name.downcase)
    if department
      unless role_record.departments.include?(department)
        role_record.departments << department
        puts "Associated #{role_record.role_name} with department #{dept_name}."
      end
    else
      puts "Error: Department #{dept_name} not found for role #{role_record.role_name}."
    end
  end

  role[:team_names].each do |team_name|
    team = Team.find_by('LOWER(team_name) = ? OR LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                        team_name.downcase, team_name.downcase)
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

total_roles_after = JobRole.count
puts "*******Seeded #{seeded_count} new job roles. Updated #{updated_count} roles. #{existing_count} roles already existed. Total job roles in the table: #{total_roles_after}."
