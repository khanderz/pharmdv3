# Seeding common job salary intervals
job_salary_intervals = [
  { interval: 'Annually' },
  { interval: 'Bi-weekly' },
  { interval: 'Daily' },
  { interval: 'Hourly' },
  { interval: 'Monthly' },
  { interval: 'Quarterly' },
  { interval: 'Weekly' }
]

job_salary_intervals.each do |interval|
  begin
    JobSalaryInterval.find_or_create_by!(interval: interval[:interval])
  rescue StandardError => e
    puts "Error seeding job salary interval: #{interval[:interval]} - #{e.message}"
  end
end

puts "***********Seeded common job salary intervals"
