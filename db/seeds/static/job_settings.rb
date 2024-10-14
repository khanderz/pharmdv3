job_settings = [
  { setting_name: 'Field-based', aliases: ['Travel Required', 'Field Work'] },
  { setting_name: 'Flexible', aliases: ['Flexible Location', 'Flexible Hours', 'Work from Anywhere'] },
  { setting_name: 'Hybrid', aliases: ['Part-time Remote', 'Mixed Remote and On-site'] },
  { setting_name: 'On-site', aliases: ['In-office', 'Office-based'] },
  { setting_name: 'Remote', aliases: ['Work from Home', 'Telecommute', 'WFH'] }
]

job_settings.each do |setting|
  begin
    JobSetting.find_or_create_by!(setting_name: setting[:setting_name]) do |job_setting|
      job_setting.aliases = setting[:aliases]
    end
  rescue StandardError => e
    puts "Error seeding job setting: #{setting[:setting_name]} - #{e.message}"
  end
end

puts "********Seeded popular job settings."
