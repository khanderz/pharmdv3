# frozen_string_literal: true

departments = [
  { dept_name: 'Administrative',
    aliases: ['Program Management (G&A)', 'General & Administrative', 'Admin', 'Office Management',
              'General'] },

  { dept_name: 'Business Development',
    aliases: ['Sales', 'Business Development and Sales', 'Business Development & Sales',
              'Finance & Business Operations', 'strategic product planning', 'Business Development & Strategy'] },

  { dept_name: 'Clinical Team',
    aliases: ['Professional Education', 'clinical development', 'drug safety', 'health systems', 'Medical Team', 'Care Team', 'Healthcare Team', 'Behavioral Health', 'service provider', 'patient services',
              'Clinical Strategy and Services', 'Pharmacy', 'medical affairs', 'Clinical Operations', 'Clinical Research & Operations', 'Pharmacovigilance',
              'blink health pharmacy', 'medical care', 'behavioral care', 'patient care', 'veterinarian full time', 'veterinarian relief', 'veterinarian technician full time'] },

  { dept_name: 'Customer Support',
    aliases: ['Customer Service', 'Client Support', 'Help Desk', 'Customer Operations',
              'commercial', 'client services'] },

  { dept_name: 'Data Science',
    aliases: ['Data Analytics', 'Machine Learning', 'AI', 'Biostatistics & Data Management'] },

  { dept_name: 'Design', aliases: ['UI/UX Design', 'Graphic Design', 'Product & Design'] },

  { dept_name: 'Editorial',
    aliases: ['Content Creation', 'Editing', 'Publishing', 'Editorial Team', 'Content Team',
              'medical writing'] },

  { dept_name: 'Engineering',
    aliases: ['mobile', 'process engineering', 'core dev', 'Development', 'Software Engineering', 'Tech',
              'Information Technology', 'DevOps', 'hardware', 'hardware & operations', 'fab tools', 'downstream processing'] },

  { dept_name: 'Executive',
    aliases: ['Leadership', 'Management', 'C-Suite', 'Board of Directors', 'headquarters',
              'executive officer', 'enterprise'] },

  { dept_name: 'Finance',
    aliases: ['Accounting', 'Financial Planning', 'FP&A', 'accounting/finance',
              'finance & accounting', 'finance and CEO'] },

  { dept_name: 'Human Resources',
    aliases: ['People Team', 'HR', 'Talent Acquisition', 'People Operations',
              'Talent & Organization', 'People and Culture', 'human res'] },

  { dept_name: 'Internship',
    aliases: ['Interns', 'Internship Team', 'Internship Program', 'fellowship', 'graduate'] },

  { dept_name: 'IT',
    aliases: ['Tech Ops', 'Information Technology', 'Tech Support', 'Ops/Member Care', 'it operations',
              'technology', 'information systems', 'Info Tech', 'integration engr'] },

  { dept_name: 'Legal',
    aliases: ['Corporate Law', 'Compliance', 'Legal Affairs', 'Regulatory', 'regulatory affairs'] },

  { dept_name: 'Marketing',
    aliases: ['Sales Development', 'Market Access & Strategic Accounts', 'Diagnostics Marketing', 'Digital Marketing', 'Content Marketing', 'Branding', 'Brand',
              'Commercial Operations', 'Market Access'] },

  { dept_name: 'Operations',
    aliases: ['Strategy & Operations', 'Business Operations', 'Growth & Business Excellence', 'worker operations', 'People Operations', 'Institute of Computation',
              'Process Development', 'process analytics', 'portfolio management'] },

  { dept_name: 'Product Management',
    aliases: ['Product Development', 'Product', 'PM, CA & MA',
              'Product Management, Clinical Affairs, Market Access'] },

  { dept_name: 'Project Management',
    aliases: ['Program Management', 'Project Delivery', 'enterprise project management office'] },

  { dept_name: 'Public Relations',
    aliases: ['Community Engagement', 'Public Outreach', 'Outreach Team', 'Community Relations'] },

  { dept_name: 'Quality',
    aliases: ['Quality Assurance', 'Quality Control', 'QA', 'quality affairs'] },

  { dept_name: 'Safety',
    aliases: ['Environmental Health and Safety'] },

  { dept_name: 'Sales',
    aliases: ['Sales AMER', 'Reimbursement', 'diagnostics sales', 'Commercial Field', 'Commercial Effectiveness & Training', 'Business Development', 'Account Management', 'Field sales', 'Sales Operations',
              'Sales Training & Development', 'commercial strategy', 'sales ops', 'field sales managers', 'Commercial Insights, Analytics, & Operations', 'customer success', 'account acquisitions',
              'partnerships', 'international sales', 'commercial'] },

  { dept_name: 'Supply Chain',
    aliases: ['Logistics', 'Procurement', 'Supply Chain Management', 'MFG & Supply Chain',
              'Fulfillment', 'Manufacturing', 'Fab Tech', 'facility'] },

  { dept_name: 'Science',
    aliases: ['Scientific Solutions Consulting', 'MSAT', 'Biometrics', 'Templates and Testing', 'Drug Discovery', 'research/discovery', 'laboratory operations', 'Research & Science', 'pharmaceutical development', 'CLIA ops', 'Bioinformatics and PE', 'bioinformatics', 'proteomics', 'Research', 'R&D',
              'Scientific Research', 'bioanalysis', 'clinical r&d', 'analytical research & development', 'lnp platforms', 'Cell Process Sciences',
              'Biostatistics & Data Management', 'Protein Sciences', 'cell biology', 'translational r&d', 'medicinal chemistry', 'protein testing team',
              'res & dev', 'gondolabio'] },
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
