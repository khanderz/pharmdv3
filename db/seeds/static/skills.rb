# frozen_string_literal: true

skills = [
  { skill_code: 'ANALYSIS', skill_name: 'Analytical Thinking',
    aliases: ['data analysis', 'reviewing data', 'critical thinking'] },
  { skill_code: 'COMMUNICATION', skill_name: 'Communication',
    aliases: ['verbal communication', 'written communication', 'articulate communication'] },
  { skill_code: 'LEADERSHIP', skill_name: 'Leadership',
    aliases: ['team leadership', 'managing teams', 'cross-functional collaboration'] },
  { skill_code: 'PROGRAMMING', skill_name: 'Programming',
    aliases: ['software development', 'coding'] }
]

specific_skills = [
  { skill_code: 'EXCEL', skill_name: 'Excel', aliases: ['Microsoft Excel', 'Excel spreadsheet'] },
  { skill_code: 'JAVA', skill_name: 'Java', aliases: ['Java programming'] },
  { skill_code: 'JAVASCRIPT', skill_name: 'JavaScript', aliases: ['JS', 'frontend development'] },
  { skill_code: 'RUBY', skill_name: 'Ruby', aliases: ['Ruby programming'] },
  { skill_code: 'SQL', skill_name: 'SQL',
    aliases: ['Structured Query Language', 'database management'] }
]

all_skills = (skills + specific_skills).sort_by { |skill| skill[:skill_code] }

seeded_count = 0
existing_count = 0
updated_count = 0

all_skills.each do |skill|
  skill_record = Skill.find_or_initialize_by(skill_code: skill[:skill_code])

  if skill_record.persisted?
    existing_count += 1
    updates_made = false

    if skill_record.skill_name != skill[:skill_name]
      skill_record.skill_name = skill[:skill_name]
      updates_made = true
      puts "Updated skill_name for skill #{skill[:skill_code]}."
    end

    if skill[:aliases] && skill_record.aliases != skill[:aliases]
      skill_record.aliases = skill[:aliases]
      updates_made = true
      puts "Updated aliases for skill #{skill[:skill_code]}."
    end

    if updates_made
      skill_record.save!
      updated_count += 1
      puts "Skill #{skill[:skill_code]} updated in database."
    else
      puts "Skill #{skill[:skill_code]} is already up-to-date."
    end
  else
    skill_record.skill_name = skill[:skill_name]
    skill_record.aliases = skill[:aliases] if skill[:aliases]
    skill_record.save!
    seeded_count += 1
    puts "Seeded new skill: #{skill[:skill_code]}"
  end
end

total_skills = Skill.count
puts "*********** Seeded #{seeded_count} new skills. #{existing_count} skills already existed. #{updated_count} skills updated. Total skills in the table: #{total_skills}."
