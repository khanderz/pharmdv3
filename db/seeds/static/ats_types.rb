# Seeding ATS types
ats_types = [
  { ats_type_code: 'ASHBYHQ', ats_type_name: 'AshbyHQ' },
  { ats_type_code: 'BAMBOOHR', ats_type_name: 'BambooHR' },
  { ats_type_code: 'BREEZYHR', ats_type_name: 'BreezyHR' },
  { ats_type_code: 'BUILTIN', ats_type_name: 'BuiltIn' },
  { ats_type_code: 'DOVER', ats_type_name: 'Dover' },
  { ats_type_code: 'EIGHTFOLD', ats_type_name: 'Eightfold' },
  { ats_type_code: 'GREENHOUSE', ats_type_name: 'Greenhouse' },
  { ats_type_code: 'ICIMS', ats_type_name: 'iCIMS' },
  { ats_type_code: 'JAZZHR', ats_type_name: 'JazzHR' },
  { ats_type_code: 'LEVER', ats_type_name: 'Lever' },
  { ats_type_code: 'MYWORKDAY', ats_type_name: 'MyWorkday' },
  { ats_type_code: 'RIPPLING', ats_type_name: 'Rippling' },
  { ats_type_code: 'SMARTRECRUITERS', ats_type_name: 'SmartRecruiters' },
  { ats_type_code: 'TALEO', ats_type_name: 'Taleo' },
  { ats_type_code: 'WELLFOUND', ats_type_name: 'Wellfound' },
  { ats_type_code: 'WORKABLE', ats_type_name: 'Workable' },
  { ats_type_code: 'YCOMBINATOR', ats_type_name: 'YCombinator' }
]

ats_types.each do |ats_type|
  begin
    AtsType.find_or_create_by!(ats_type_code: ats_type[:ats_type_code]) do |type|
      type.ats_type_name = ats_type[:ats_type_name]
    end
  rescue StandardError => e
    # Error handling: Log a message if something goes wrong
    puts "Error seeding ATS type: #{ats_type[:ats_type_name]} - #{e.message}"
  end
end

puts "****************Seeded ATS types****************"
