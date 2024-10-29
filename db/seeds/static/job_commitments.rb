# frozen_string_literal: true

# Seeding common job commitments
job_commitments = [
  { commitment_name: 'Contractor' },
  { commitment_name: 'Freelance' },
  { commitment_name: 'Full-time' },
  { commitment_name: 'Internship' },
  { commitment_name: 'Part-time' },
  { commitment_name: 'Per Diem' },
  { commitment_name: 'Temporary' },
  { commitment_name: 'Volunteer' }
]

seeded_count = 0
existing_count = 0
updated_count = 0

job_commitments.each do |commitment|
  job_commitment = JobCommitment.find_or_initialize_by(commitment_name: commitment[:commitment_name])

  if job_commitment.persisted?
    existing_count += 1
    updates_made = false

    if updates_made
      job_commitment.save!
      updated_count += 1
      puts "Updated job commitment #{commitment[:commitment_name]} in the database."
    else
      puts "Job commitment #{commitment[:commitment_name]} is already up-to-date."
    end
  else
    job_commitment.save!
    seeded_count += 1
    puts "Seeded new job commitment: #{commitment[:commitment_name]}"
  end
rescue StandardError => e
  puts "Error seeding job commitment: #{commitment[:commitment_name]} - #{e.message}"
end

total_commitments_after = JobCommitment.count
puts "******* Seeded #{seeded_count} new job commitments. #{existing_count} commitments already existed. #{updated_count} commitments updated. Total job commitments in the table: #{total_commitments_after}."
