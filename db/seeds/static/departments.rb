# frozen_string_literal: true

departments = [
  { dept_name: 'Administrative',
    aliases: ['General & Administrative', 'Admin', 'Office Management', 'General'] },

  { dept_name: 'Business Development',
    aliases: ['Sales', 'Business Development and Sales', 'Business Development & Sales',
              'Finance & Business Operations', 'strategic product planning'] },

  { dept_name: 'Clinical Team',
    aliases: ['drug safety', 'health systems', 'Medical Team', 'Care Team', 'Healthcare Team', 'Behavioral Health', 'service provider', 'patient services',
              'Clinical Strategy and Services', 'Pharmacy', 'medical affairs', 'Clinical Operations', 'Clinical Research & Operations'] },

  { dept_name: 'Customer Support',
    aliases: ['Customer Service', 'Client Support', 'Help Desk', 'Customer Operations',
              'commercial', 'client services'] },

  { dept_name: 'Data Science', aliases: ['Data Analytics', 'Machine Learning', 'AI'] },

  { dept_name: 'Design', aliases: ['UI/UX Design', 'Graphic Design', 'Product & Design'] },

  { dept_name: 'Engineering',
    aliases: ['process engineering', 'core dev', 'Development', 'Software Engineering', 'Tech',
              'Information Technology', 'DevOps'] },

  { dept_name: 'Executive',
    aliases: ['Leadership', 'Management', 'C-Suite', 'Board of Directors', 'headquarters',
              'executive officer'] },

  { dept_name: 'Finance',
    aliases: ['Accounting', 'Financial Planning', 'FP&A', 'accounting/finance'] },

  { dept_name: 'Human Resources',
    aliases: ['HR', 'Talent Acquisition', 'People Operations', 'Talent & Organization'] },

  { dept_name: 'Internship',
    aliases: ['Interns', 'Internship Team', 'Internship Program', 'fellowship', 'graduate'] },

  { dept_name: 'IT',
    aliases: ['Information Technology', 'Tech Support', 'Ops/Member Care', 'it operations',
              'technology', 'information systems'] },

  { dept_name: 'Legal',
    aliases: ['Corporate Law', 'Compliance', 'Legal Affairs', 'Regulatory', 'regulatory affairs'] },

  { dept_name: 'Marketing',
    aliases: ['Digital Marketing', 'Content Marketing', 'Branding', 'Brand',
              'Commercial Operations', 'Market Access'] },

  { dept_name: 'Operations',
    aliases: ['Strategy & Operations', 'Business Operations', 'Growth & Business Excellence', 'worker operations', 'People Operations', 'Institute of Computation',
              'Process Development', 'process analytics'] },

  { dept_name: 'Product Management',
    aliases: ['Product Development', 'Product', 'PM, CA & MA',
              'Product Management, Clinical Affairs, Market Access'] },

  { dept_name: 'Project Management',
    aliases: ['Program Management', 'Project Delivery'] },

  { dept_name: 'Quality', aliases: ['Quality Assurance', 'Quality Control', 'QA'] },

  { dept_name: 'Sales',
    aliases: ['diagnostic sales', 'Commercial Field', 'Commercial Effectiveness & Training', 'Business Development', 'Account Management', 'Field sales', 'Sales Operations',
              'Sales Training & Development', 'commercial strategy', 'sales ops', 'field sales managers', 'Commercial Insights, Analytics, & Operations'] },

  { dept_name: 'Supply Chain',
    aliases: ['Logistics', 'Procurement', 'Supply Chain Management', 'MFG & Supply Chain',
              'Fulfillment'] },

  { dept_name: 'Science',
    aliases: ['research/discovery', 'laboratory operations', 'Research & Science', 'pharmaceutical development', 'CLIA ops', 'Bioinformatics and PE', 'bioinformatics', 'proteomics', 'Research', 'R&D',
              'Scientific Research', 'bioanalysis', 'clinical r&d', 'analytical research & development', 'lnp platforms'] },
]

seeded_count = 0
updated_count = 0
existing_count = 0
Department.count

departments.each do |dept|
  department_record = Department.find_or_initialize_by(dept_name: dept[:dept_name])

  if department_record.persisted?
    if department_record.aliases.sort != dept[:aliases].sort
      department_record.aliases = dept[:aliases]
      department_record.save!
      updated_count += 1
      puts "Updated aliases for department: #{dept[:dept_name]}"
    else
      existing_count += 1
    end
  else
    department_record.aliases = dept[:aliases]
    department_record.save!
    seeded_count += 1
    puts "Created new department: #{dept[:dept_name]}"
  end
rescue StandardError => e
  puts "Error seeding department: #{dept[:dept_name]} - #{e.message}"
end

total_departments_after = Department.count

puts "*********Seeded #{seeded_count} new departments. Updated #{updated_count} departments. #{existing_count} departments already existed. Total departments in the table: #{total_departments_after}."
