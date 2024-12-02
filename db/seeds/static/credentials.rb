# frozen_string_literal: true

credentials = [
  { credential_code: 'BCPS', credential_name: 'Board Certified Pharmacotherapy Specialist' },
  { credential_code: 'CFA', credential_name: 'Chartered Financial Analyst' },
  { credential_code: 'CHES', credential_name: 'Certified Health Education Specialist' },
  { credential_code: 'CCRN', credential_name: 'Critical Care Registered Nurse' },
  { credential_code: 'CISSP', credential_name: 'Certified Information Systems Security Professional' },
  { credential_code: 'CLS', credential_name: 'Clinical Laboratory Scientist' },
  { credential_code: 'CNA', credential_name: 'Certified Nursing Assistant' },
  { credential_code: 'CPHQ', credential_name: 'Certified Professional in Healthcare Quality' },
  { credential_code: 'CPT', credential_name: 'Certified Personal Trainer' },
  { credential_code: 'CRNA', credential_name: 'Certified Registered Nurse Anesthetist' },
  { credential_code: 'CSCS', credential_name: 'Certified Strength and Conditioning Specialist' },
  { credential_code: 'DDS', credential_name: 'Doctor of Dental Surgery' },
  { credential_code: 'DMD', credential_name: 'Doctor of Medicine in Dentistry' },
  { credential_code: 'DO', credential_name: 'Doctor of Osteopathic Medicine' },
  { credential_code: 'MD', credential_name: 'Doctor of Medicine' },
  { credential_code: 'PhD', credential_name: 'Doctor of Philosophy' },
  { credential_code: 'PHARMD', credential_name: 'Doctor of Pharmacy' },
  { credential_code: 'EMT', credential_name: 'Emergency Medical Technician' },
  { credential_code: 'LPN', credential_name: 'Licensed Practical Nurse' },
  { credential_code: 'MBA', credential_name: 'Master of Business Administration' },
  { credential_code: 'MSW', credential_name: 'Master of Social Work' },
  { credential_code: 'MT', credential_name: 'Medical Technologist' },
  { credential_code: 'NP', credential_name: 'Nurse Practitioner' },
  { credential_code: 'PARAMEDIC', credential_name: 'Paramedic' },
  { credential_code: 'PA', credential_name: 'Physician Assistant' },
  { credential_code: 'PT', credential_name: 'Physical Therapist' },
  { credential_code: 'RD', credential_name: 'Registered Dietitian' },
  { credential_code: 'RHIA', credential_name: 'Registered Health Information Administrator' },
  { credential_code: 'RN', credential_name: 'Registered Nurse' },
  { credential_code: 'RPH', credential_name: 'Registered Pharmacist' },
  { credential_code: 'RRT', credential_name: 'Registered Respiratory Therapist' },
  { credential_code: 'OT', credential_name: 'Occupational Therapist' }
]

seeded_count = 0
existing_count = 0
updated_count = 0

credentials.each do |credential|
  credential_record = Credential.find_or_initialize_by(credential_code: credential[:credential_code])

  if credential_record.persisted?
    existing_count += 1
    updates_made = false

    if credential_record.credential_name != credential[:credential_name]
      credential_record.credential_name = credential[:credential_name]
      updates_made = true
      puts "Updated credential_name for credential #{credential[:credential_code]}."
    end

    if updates_made
      credential_record.save!
      updated_count += 1
      puts "Credential #{credential[:credential_code]} updated in database."
    else
      puts "Credential #{credential[:credential_code]} is already up-to-date."
    end
  else
    credential_record.credential_name = credential[:credential_name]
    credential_record.save!
    seeded_count += 1
    puts "Seeded new credential: #{credential[:credential_code]}"
  end
end

total_credentials = Credential.count
puts "*********** Seeded #{seeded_count} new credentials. #{existing_count} credentials already existed. #{updated_count} credentials updated. Total credentials in the table: #{total_credentials}."
