# Seeding common job commitments
job_commitments = [
  { commitment_name: 'Full-time' },
  { commitment_name: 'Part-time' },
  { commitment_name: 'Contractor' },
  { commitment_name: 'Freelance' },
  { commitment_name: 'Internship' },
  { commitment_name: 'Temporary' },
  { commitment_name: 'Volunteer' },
  { commitment_name: 'Per Diem' }
]

job_commitments.each do |commitment|
  begin
    JobCommitment.find_or_create_by!(commitment_name: commitment[:commitment_name])
  rescue StandardError => e
    puts "Error seeding job commitment: #{commitment[:commitment_name]} - #{e.message}"
  end
end

puts "*****Seeded common job commitments"
