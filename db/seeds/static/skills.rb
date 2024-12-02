# frozen_string_literal: true

skills = [
  { skill_code: 'ANALYSIS', skill_name: 'Analytical Thinking',
    aliases: ['data analysis', 'reviewing data', 'critical thinking'] },
  { skill_code: 'COMMUNICATION', skill_name: 'Communication',
    aliases: ['verbal communication', 'written communication', 'articulate communication'] },
  { skill_code: 'LEADERSHIP', skill_name: 'Leadership',
    aliases: ['team leadership', 'managing teams', 'cross-functional collaboration'] },
  { skill_code: 'PROGRAMMING', skill_name: 'Programming',
    aliases: ['software development', 'coding'] },
  { skill_code: 'CUSTOMER_SERVICE', skill_name: 'Customer Service',
    aliases: ['client interaction', 'customer interaction', 'customer relationship management'] },
  { skill_code: 'SALES', skill_name: 'Sales',
    aliases: ['business development', 'selling skills', 'prospecting'] },
  { skill_code: 'NEGOTIATION', skill_name: 'Negotiation',
    aliases: ['deal negotiation', 'conflict resolution', 'contract negotiation'] },
  { skill_code: 'PROBLEM_SOLVING', skill_name: 'Problem Solving',
    aliases: ['critical problem solving', 'troubleshooting', 'issue resolution'] },
  { skill_code: 'TEAMWORK', skill_name: 'Teamwork',
    aliases: ['collaboration', 'working with teams', 'team collaboration'] },
  { skill_code: 'TIME_MANAGEMENT', skill_name: 'Time Management',
    aliases: ['prioritization', 'scheduling', 'meeting deadlines'] },
  { skill_code: 'ORGANIZATION', skill_name: 'Organization',
    aliases: ['project management', 'task management', 'planning'] },
  { skill_code: 'INNOVATION', skill_name: 'Innovation',
    aliases: ['creative thinking', 'idea generation', 'out-of-the-box thinking'] },
  { skill_code: 'ADAPTABILITY', skill_name: 'Adaptability',
    aliases: ['flexibility', 'learning new skills', 'handling change'] },
  { skill_code: 'PRESENTATION', skill_name: 'Presentation Skills',
    aliases: ['public speaking', 'pitching', 'visual communication'] },
  { skill_code: 'TECHNICAL_WRITING', skill_name: 'Technical Writing',
    aliases: ['documentation', 'manual writing', 'instructional design'] },
  { skill_code: 'RESEARCH', skill_name: 'Research',
    aliases: ['information gathering', 'market research', 'academic research'] },
  { skill_code: 'PROJECT_MANAGEMENT', skill_name: 'Project Management',
    aliases: ['PM', 'task coordination', 'project planning'] },
  { skill_code: 'DATA_ANALYTICS', skill_name: 'Data Analytics',
    aliases: ['data interpretation', 'statistical analysis', 'data-driven decision making'] },
  { skill_code: 'CUSTOMER_RETENTION', skill_name: 'Customer Retention',
    aliases: ['client retention', 'building loyalty', 'customer satisfaction'] },
  { skill_code: 'EMPLOYEE_TRAINING', skill_name: 'Employee Training',
    aliases: ['mentorship', 'staff training', 'coaching'] }
]

specific_skills = [
  { skill_code: 'AWS', skill_name: 'Amazon Web Services', aliases: ['AWS Cloud', 'Amazon Cloud'] },
  { skill_code: 'AZURE', skill_name: 'Microsoft Azure',
    aliases: ['Azure Cloud', 'Azure Services'] },
  { skill_code: 'C', skill_name: 'C Programming', aliases: ['C Language'] },
  { skill_code: 'CPLUSPLUS', skill_name: 'C++', aliases: ['C++ Programming', 'C++ Language'] },
  { skill_code: 'C_SHARP', skill_name: 'C#', aliases: ['C# Programming', 'C# Language'] },
  { skill_code: 'DART', skill_name: 'Dart', aliases: ['Dart Programming', 'Flutter Dart'] },
  { skill_code: 'DOCKER', skill_name: 'Docker',
    aliases: ['Containerization', 'Docker Containers'] },
  { skill_code: 'EXCEL', skill_name: 'Excel', aliases: ['Microsoft Excel', 'Excel spreadsheet'] },
  { skill_code: 'FIGMA', skill_name: 'Figma', aliases: ['UI/UX Design Tool', 'Figma Design'] },
  { skill_code: 'FLUTTER', skill_name: 'Flutter',
    aliases: ['Flutter Framework', 'Mobile Development'] },
  { skill_code: 'GOOGLE_CLOUD', skill_name: 'Google Cloud',
    aliases: ['Google Cloud Platform', 'GCP'] },
  { skill_code: 'HTML', skill_name: 'HTML', aliases: ['HyperText Markup Language', 'HTML5'] },
  { skill_code: 'JAVA', skill_name: 'Java', aliases: ['Java Programming'] },
  { skill_code: 'JAVASCRIPT', skill_name: 'JavaScript', aliases: ['JS', 'Frontend Development'] },
  { skill_code: 'KUBERNETES', skill_name: 'Kubernetes',
    aliases: ['K8s', 'Container Orchestration'] },
  { skill_code: 'LINUX', skill_name: 'Linux', aliases: ['Linux Administration', 'Linux OS'] },
  { skill_code: 'NODEJS', skill_name: 'Node.js', aliases: ['Node', 'Server-side JavaScript'] },
  { skill_code: 'NUMPY', skill_name: 'NumPy', aliases: ['Numerical Python', 'NumPy Library'] },
  { skill_code: 'PANDAS', skill_name: 'Pandas', aliases: ['Python Pandas', 'DataFrame Library'] },
  { skill_code: 'POWER_BI', skill_name: 'Power BI',
    aliases: ['Microsoft Power BI', 'Data Visualization'] },
  { skill_code: 'PYTHON', skill_name: 'Python',
    aliases: ['Python Programming', 'Python Language'] },
  { skill_code: 'R', skill_name: 'R Programming',
    aliases: ['R Statistical Programming', 'R Language'] },
  { skill_code: 'REACT', skill_name: 'React.js', aliases: ['React Framework', 'Frontend React'] },
  { skill_code: 'RUBY', skill_name: 'Ruby', aliases: ['Ruby Programming'] },
  { skill_code: 'SCALA', skill_name: 'Scala', aliases: ['Scala Programming'] },
  { skill_code: 'SCI_KIT', skill_name: 'Sci-Kit Learn',
    aliases: ['Machine Learning Sci-Kit', 'Sci-Kit Library'] },
  { skill_code: 'SQL', skill_name: 'SQL',
    aliases: ['Structured Query Language', 'Database Management'] },
  { skill_code: 'SWIFT', skill_name: 'Swift', aliases: ['Swift Programming', 'iOS Development'] },
  { skill_code: 'TABLEAU', skill_name: 'Tableau',
    aliases: ['Data Visualization Tableau', 'Tableau Software'] },
  { skill_code: 'TYPESCRIPT', skill_name: 'TypeScript', aliases: ['TS', 'Typed JavaScript'] },
  { skill_code: 'VUEJS', skill_name: 'Vue.js', aliases: ['Vue Framework', 'Frontend Vue'] }
]

all_skills = (skills + specific_skills).sort_by { |skill| skill[:skill_code] }

seeded_count = 0
existing_count = 0
updated_count = 0

all_skills.each do |skill|
  skill_record = Skill.find_or_initialize_by(skill_code: skill[:skill_code])

  if skill_record.persisted?
    existing_count += 1
    updates_made = false

    if skill_record.skill_name != skill[:skill_name]
      skill_record.skill_name = skill[:skill_name]
      updates_made = true
      puts "Updated skill_name for skill #{skill[:skill_code]}."
    end

    if skill[:aliases] && skill_record.aliases != skill[:aliases]
      skill_record.aliases = skill[:aliases]
      updates_made = true
      puts "Updated aliases for skill #{skill[:skill_code]}."
    end

    if updates_made
      skill_record.save!
      updated_count += 1
      puts "Skill #{skill[:skill_code]} updated in database."
    else
      puts "Skill #{skill[:skill_code]} is already up-to-date."
    end
  else
    skill_record.skill_name = skill[:skill_name]
    skill_record.aliases = skill[:aliases] if skill[:aliases]
    skill_record.save!
    seeded_count += 1
    puts "Seeded new skill: #{skill[:skill_code]}"
  end
end

total_skills = Skill.count
puts "*********** Seeded #{seeded_count} new skills. #{existing_count} skills already existed. #{updated_count} skills updated. Total skills in the table: #{total_skills}."
