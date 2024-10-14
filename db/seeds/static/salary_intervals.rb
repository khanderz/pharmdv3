# Seeding common job salary intervals
job_salary_intervals = [
  { interval: 'Hourly' },
  { interval: 'Daily' },
  { interval: 'Weekly' },
  { interval: 'Bi-weekly' },
  { interval: 'Monthly' },
  { interval: 'Quarterly' },
  { interval: 'Annually' },
]

job_salary_intervals.each do |interval|
  begin
    JobSalaryInterval.find_or_create_by!(interval: interval[:interval])
  rescue StandardError => e
    puts "Error seeding job salary interval: #{interval[:interval]} - #{e.message}"
  end
end

puts "***********Seeded common job salary intervals"
