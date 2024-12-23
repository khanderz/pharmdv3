# frozen_string_literal: true

experiences = [
  { experience_code: 'ENTRY', experience_name: 'Entry Level', min_years: 0, max_years: 1 },
  { experience_code: 'MID', experience_name: 'Mid Level', min_years: 2, max_years: 5 },
  { experience_code: 'SENIOR', experience_name: 'Senior Level', min_years: 6, max_years: 10 },
  { experience_code: 'EXECUTIVE', experience_name: 'Executive Level', min_years: 11,
    max_years: nil }
]

seeded_count = 0
existing_count = 0
updated_count = 0

experiences.each do |experience|
  experience_record = Experience.find_or_initialize_by(experience_code: experience[:experience_code])

  if experience_record.persisted?
    existing_count += 1
    updates_made = false

    if experience_record.experience_name != experience[:experience_name]
      experience_record.experience_name = experience[:experience_name]
      updates_made = true
      puts "Updated experience_name for experience #{experience[:experience_code]}."
    end

    if experience_record.min_years != experience[:min_years] || experience_record.max_years != experience[:max_years]
      experience_record.min_years = experience[:min_years]
      experience_record.max_years = experience[:max_years]
      updates_made = true
      puts "Updated min_years and max_years for experience #{experience[:experience_code]}."
    end

    if updates_made
      experience_record.save!
      updated_count += 1
      puts "Experience #{experience[:experience_code]} updated in database."
    else
      puts "Experience #{experience[:experience_code]} is already up-to-date."
    end
  else
    experience_record.experience_name = experience[:experience_name]
    experience_record.min_years = experience[:min_years]
    experience_record.max_years = experience[:max_years]
    experience_record.save!
    seeded_count += 1
    puts "Seeded new experience: #{experience[:experience_code]}"
  end
end

total_experiences = Experience.count
puts "*********** Seeded #{seeded_count} new experiences. #{existing_count} experiences already existed. #{updated_count} experiences updated. Total experiences in the table: #{total_experiences}."
