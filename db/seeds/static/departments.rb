# Seeding common departments with aliases
departments = [
  { dept_name: 'Customer Support', aliases: ['Customer Service', 'Client Support', 'Help Desk'] },
  { dept_name: 'Data Science', aliases: ['Data Analytics', 'Machine Learning', 'AI'] },
  { dept_name: 'Design', aliases: ['UI/UX Design', 'Graphic Design'] },
  { dept_name: 'Engineering', aliases: ['Development', 'Software Engineering', 'Tech'] },
  { dept_name: 'Finance', aliases: ['Accounting', 'Financial Planning', 'FP&A'] },
  { dept_name: 'Human Resources', aliases: ['HR', 'Talent Acquisition', 'People Operations'] },
  { dept_name: 'IT', aliases: ['Information Technology', 'Tech Support'] },
  { dept_name: 'Legal', aliases: ['Corporate Law', 'Compliance', 'Legal Affairs'] },
  { dept_name: 'Marketing', aliases: ['Digital Marketing', 'Content Marketing', 'Branding'] },
  { dept_name: 'Operations', aliases: ['Business Operations', 'Logistics', 'Supply Chain'] },
  { dept_name: 'Product Management', aliases: ['Product Development', 'Product'] },
  { dept_name: 'Sales', aliases: ['Business Development', 'Account Management'] },
  { dept_name: 'Clinical Team', aliases: ['Medical Team', 'Care Team', 'Healthcare Team'] }
]

seeded_count = 0
existing_count = 0
total_departments = Department.count

departments.each do |dept|
  # Check for department by name or aliases
  department_record = Department.find_by(dept_name: dept[:dept_name]) || Department.find_by("aliases @> ARRAY[?]::varchar[]", dept[:aliases])

  unless department_record
    begin
      # Create the new department and log it for adjudication
      new_department = Department.create!(
        dept_name: dept[:dept_name],
        aliases: dept[:aliases],
        error_details: "Department not found in existing records",
        reference_id: nil, # Set reference_id if needed
        resolved: false
      )

      # Log adjudication entry
      Adjudication.create!(
        table_name: 'departments',
        error_details: "Department #{dept[:dept_name]} needs adjudication.",
        reference_id: new_department.id,
        resolved: false
      )

      seeded_count += 1
      puts "Department #{dept[:dept_name]} adjudicated."
    rescue StandardError => e
      puts "Error seeding department: #{dept[:dept_name]} - #{e.message}"
    end
  else
    existing_count += 1
    puts "Department #{dept[:dept_name]} already exists."
  end
end

total_departments_after = Department.count

puts "*********Seeded #{seeded_count} new departments. #{existing_count} departments already existed. Total departments in the table: #{total_departments_after}."
