# Seeding common departments with aliases
departments = [
  { dept_name: 'Engineering', aliases: ['Development', 'Software Engineering', 'Tech'] },
  { dept_name: 'Marketing', aliases: ['Digital Marketing', 'Content Marketing', 'Branding'] },
  { dept_name: 'Sales', aliases: ['Business Development', 'Account Management'] },
  { dept_name: 'Human Resources', aliases: ['HR', 'Talent Acquisition', 'People Operations'] },
  { dept_name: 'Finance', aliases: ['Accounting', 'Financial Planning', 'FP&A'] },
  { dept_name: 'Customer Support', aliases: ['Customer Service', 'Client Support', 'Help Desk'] },
  { dept_name: 'Legal', aliases: ['Corporate Law', 'Compliance', 'Legal Affairs'] },
  { dept_name: 'Operations', aliases: ['Business Operations', 'Logistics', 'Supply Chain'] },
  { dept_name: 'Product Management', aliases: ['Product Development', 'Product'] },
  { dept_name: 'Design', aliases: ['UI/UX Design', 'Graphic Design'] },
  { dept_name: 'IT', aliases: ['Information Technology', 'Tech Support'] },
  { dept_name: 'Data Science', aliases: ['Data Analytics', 'Machine Learning', 'AI'] }
]

departments.each do |dept|
  begin
    Department.find_or_create_by!(dept_name: dept[:dept_name], aliases: dept[:aliases])
  rescue StandardError => e
    puts "Error seeding department: #{dept[:dept_name]} - #{e.message}"
  end
end

puts "Seeded common departments with aliases"
