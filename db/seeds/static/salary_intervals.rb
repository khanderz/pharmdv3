# frozen_string_literal: true

job_salary_intervals = [
  { interval: 'Annually' },
  { interval: 'Bi-weekly' },
  { interval: 'Daily' },
  { interval: 'Hourly' },
  { interval: 'Monthly' },
  { interval: 'Quarterly' },
  { interval: 'Weekly' }
]

seeded_count = 0
existing_count = 0
JobSalaryInterval.count

job_salary_intervals.each do |interval|
  job_salary_interval = JobSalaryInterval.find_or_initialize_by(interval: interval[:interval])

  if job_salary_interval.persisted?
    existing_count += 1
  else
    job_salary_interval.save!
    seeded_count += 1
  end
rescue StandardError => e
  puts "Error seeding job salary interval: #{interval[:interval]} - #{e.message}"
end

total_intervals_after = JobSalaryInterval.count

puts "*******Seeded #{seeded_count} new job salary intervals. #{existing_count} intervals already existed. Total job salary intervals in the table: #{total_intervals_after}."
