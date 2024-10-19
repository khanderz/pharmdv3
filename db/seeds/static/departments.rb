# Seeding common departments with aliases
departments = [
  { dept_name: 'Clinical Team', aliases: ['Medical Team', 'Care Team', 'Healthcare Team', 'Behavioral Health', 'Clinical Strategy and Services'] },
  { dept_name: 'Customer Support', aliases: ['Customer Service', 'Client Support', 'Help Desk'] },
  { dept_name: 'Data Science', aliases: ['Data Analytics', 'Machine Learning', 'AI'] },
  { dept_name: 'Design', aliases: ['UI/UX Design', 'Graphic Design', 'Product & Design'] },
  { dept_name: 'Engineering', aliases: ['Development', 'Software Engineering', 'Tech', 'Information Technology'] },
  { dept_name: 'Finance', aliases: ['Accounting', 'Financial Planning', 'FP&A'] },
  { dept_name: 'Human Resources', aliases: ['HR', 'Talent Acquisition', 'People Operations', 'Talent & Organization'] },
  { dept_name: 'IT', aliases: ['Information Technology', 'Tech Support', 'Ops/Member Care'] },
  { dept_name: 'Legal', aliases: ['Corporate Law', 'Compliance', 'Legal Affairs'] },
  { dept_name: 'Marketing', aliases: ['Digital Marketing', 'Content Marketing', 'Branding'] },
  { dept_name: 'Operations', aliases: ['Business Operations', 'Logistics', 'Supply Chain', 'Growth & Business Excellence'] },
  { dept_name: 'Product Management', aliases: ['Product Development', 'Product'] },
  { dept_name: 'Sales', aliases: ['Business Development', 'Account Management'] },
]

seeded_count = 0
existing_count = 0
total_departments = Department.count

departments.each do |dept|
  begin
    department_record = Department.find_or_initialize_by(dept_name: dept[:dept_name])
    
    if department_record.persisted?
      existing_count += 1
    else
      department_record.aliases = dept[:aliases]
      department_record.save!
      seeded_count += 1
    end
  rescue StandardError => e
    puts "Error seeding department: #{dept[:dept_name]} - #{e.message}"
  end
end

total_departments_after = Department.count

puts "*********Seeded #{seeded_count} new departments. #{existing_count} departments already existed. Total departments in the table: #{total_departments_after}."
