# frozen_string_literal: true

job_seniorities = [
  { job_seniority_code: 'ASSOCIATE', job_seniority_label: 'Associate', aliases: ['Assoc'] },
  { job_seniority_code: 'ASSOCIATE_DIRECTOR', job_seniority_label: 'Associate Director' },
  { job_seniority_code: 'C_LEVEL', job_seniority_label: 'C-Level', aliases: %w[CEO CTO CFO] },
  { job_seniority_code: 'DIRECTOR', job_seniority_label: 'Director', aliases: ['Dir'] },
  { job_seniority_code: 'ENTRY', job_seniority_label: 'Entry Level',
    aliases: %w[Beginner Junior] },
  { job_seniority_code: 'EXECUTIVE', job_seniority_label: 'Executive', aliases: ['Exec'] },
  { job_seniority_code: 'FELLOWSHIP', job_seniority_label: 'Fellowship', aliases: ['Fellow'] },
  { job_seniority_code: 'INTERNSHIP', job_seniority_label: 'Internship', aliases: ['Intern'] },
  { job_seniority_code: 'MANAGER', job_seniority_label: 'Manager', aliases: %w[Mgr Supervisor] },
  { job_seniority_code: 'MIDLEVEL', job_seniority_label: 'Midlevel',
    aliases: %w[Mid Intermediate] },
  { job_seniority_code: 'PRINCIPAL', job_seniority_label: 'Principal', aliases: ['Lead'] },
  { job_seniority_code: 'SENIOR', job_seniority_label: 'Senior', aliases: %w[Sr Experienced] },
  { job_seniority_code: 'STAFF', job_seniority_label: 'Staff', aliases: ['Team Member'] },
  { job_seniority_code: 'VP', job_seniority_label: 'Vice President', aliases: ['Vice Pres', 'VP'] }
]

seeded_count = 0
existing_count = 0
updated_count = 0

job_seniorities.each do |seniority|
  seniority_record = JobSeniority.find_or_initialize_by(job_seniority_code: seniority[:job_seniority_code])

  if seniority_record.persisted?
    existing_count += 1
    updates_made = false

    if seniority_record.job_seniority_label != seniority[:job_seniority_label]
      seniority_record.job_seniority_label = seniority[:job_seniority_label]
      updates_made = true
      puts "Updated seniority label for #{seniority[:job_seniority_code]} to #{seniority[:job_seniority_label]}."
    end

    if seniority_record.aliases != seniority[:aliases]
      seniority_record.aliases = seniority[:aliases]
      updates_made = true
      puts "Updated aliases for #{seniority[:job_seniority_code]} to #{seniority[:aliases].join(', ')}."
    end

    if updates_made
      seniority_record.save!
      updated_count += 1
      puts "Seniority level #{seniority[:job_seniority_label]} updated in the database."
    else
      puts "Seniority level #{seniority[:job_seniority_label]} is already up-to-date."
    end
  else
    seniority_record.job_seniority_label = seniority[:job_seniority_label]
    seniority_record.aliases = seniority[:aliases]
    seniority_record.save!
    seeded_count += 1
    puts "Seeded new seniority level: #{seniority[:job_seniority_label]}"
  end
rescue StandardError => e
  puts "Error seeding seniority level: #{seniority[:job_seniority_label]} - #{e.message}"
end

total_seniorities_after = JobSeniority.count
puts "*********** Seeded #{seeded_count} new seniority levels. #{existing_count} seniority levels already existed. #{updated_count} seniority levels updated. Total seniority levels in the table: #{total_seniorities_after}."
