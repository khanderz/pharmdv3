# frozen_string_literal: true

educations = [
  { education_code: 'AA', education_name: 'Associate of Arts' },
  { education_code: 'AS', education_name: 'Associate of Science' },
  { education_code: 'BA', education_name: 'Bachelor of Arts' },
  { education_code: 'BFA', education_name: 'Bachelor of Fine Arts' },
  { education_code: 'BS', education_name: 'Bachelor of Science' },
  { education_code: 'CERT', education_name: 'Certification Program' },
  { education_code: 'DDS', education_name: 'Doctor of Dental Surgery' },
  { education_code: 'DIP', education_name: 'Diploma Program' },
  { education_code: 'DMD', education_name: 'Doctor of Medicine in Dentistry' },
  { education_code: 'DNP', education_name: 'Doctor of Nursing Practice' },
  { education_code: 'DNS', education_name: 'Doctor of Nursing Science' },
  { education_code: 'DO', education_name: 'Doctor of Osteopathic Medicine' },
  { education_code: 'DPT', education_name: 'Doctor of Physical Therapy' },
  { education_code: 'EdD', education_name: 'Doctor of Education' },
  { education_code: 'FELLOW', education_name: 'Fellowship Program' },
  { education_code: 'GED', education_name: 'General Education Diploma' },
  { education_code: 'HS', education_name: 'High School' },
  { education_code: 'JD', education_name: 'Juris Doctor' },
  { education_code: 'LPN', education_name: 'Licensed Practical Nurse Program' },
  { education_code: 'MA', education_name: 'Master of Arts' },
  { education_code: 'MBA', education_name: 'Master of Business Administration' },
  { education_code: 'MFA', education_name: 'Master of Fine Arts' },
  { education_code: 'MD', education_name: 'Doctor of Medicine' },
  { education_code: 'MS', education_name: 'Master of Science' },
  { education_code: 'PhD', education_name: 'Doctor of Philosophy' },
  { education_code: 'PharmD', education_name: 'Doctor of Pharmacy' },
  { education_code: 'POSTDOC', education_name: 'Postdoctoral Fellowship' },
  { education_code: 'RES', education_name: 'Residency Program' },
  { education_code: 'RN', education_name: 'Registered Nurse Program' }
]

seeded_count = 0
existing_count = 0
updated_count = 0

educations.each do |education|
  education_record = Education.find_or_initialize_by(education_code: education[:education_code])

  if education_record.persisted?
    existing_count += 1
    updates_made = false

    if education_record.education_name != education[:education_name]
      education_record.education_name = education[:education_name]
      updates_made = true
      puts "Updated education_name for education #{education[:education_code]}."
    end

    if updates_made
      education_record.save!
      updated_count += 1
      puts "Education #{education[:education_code]} updated in database."
    else
      puts "Education #{education[:education_code]} is already up-to-date."
    end
  else
    education_record.education_name = education[:education_name]
    education_record.save!
    seeded_count += 1
    puts "Seeded new education: #{education[:education_code]}"
  end
end

total_educations = Education.count
puts "*********** Seeded #{seeded_count} new educations. #{existing_count} educations already existed. #{updated_count} educations updated. Total educations in the table: #{total_educations}."
