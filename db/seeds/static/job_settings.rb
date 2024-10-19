job_settings = [
  { setting_name: 'Field-based', aliases: ['Travel Required', 'Field Work'] },
  { setting_name: 'Flexible', aliases: ['Flexible Location', 'Flexible Hours', 'Work from Anywhere'] },
  { setting_name: 'Hybrid', aliases: ['Part-time Remote', 'Mixed Remote and On-site'] },
  { setting_name: 'On-site', aliases: ['In-office', 'Office-based', 'onsite'] },
  { setting_name: 'Remote', aliases: ['Work from Home', 'Telecommute', 'WFH'] }
]

seeded_count = 0
updated_count = 0
existing_count = 0
total_settings = JobSetting.count

job_settings.each do |setting|
  begin
    job_setting = JobSetting.find_or_initialize_by(setting_name: setting[:setting_name])
    
    if job_setting.persisted?
      # Check if the aliases need to be updated
      if job_setting.aliases.sort != setting[:aliases].sort
        job_setting.aliases = setting[:aliases]
        job_setting.save!
        updated_count += 1
        puts "Updated aliases for job setting: #{setting[:setting_name]}"
      else
        existing_count += 1
      end
    else
      job_setting.aliases = setting[:aliases]
      job_setting.save!
      seeded_count += 1
      puts "Created new job setting: #{setting[:setting_name]}"
    end
  rescue StandardError => e
    puts "Error seeding job setting: #{setting[:setting_name]} - #{e.message}"
  end
end

total_settings_after = JobSetting.count

puts "*******Seeded #{seeded_count} new job settings. Updated #{updated_count} settings. #{existing_count} settings already existed. Total job settings in the table: #{total_settings_after}."
