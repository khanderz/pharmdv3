# Seeding ATS types
ats_types = [
  { ats_type_code: 'bamboohr', ats_type_name: 'BambooHR' },
  { ats_type_code: 'greenhouse', ats_type_name: 'Greenhouse' },
  { ats_type_code: 'lever', ats_type_name: 'Lever' },
  { ats_type_code: 'dover', ats_type_name: 'Dover' },
  { ats_type_code: 'ashbyhq', ats_type_name: 'AshbyHQ' },
  { ats_type_code: 'breezyhr', ats_type_name: 'BreezyHR' },
  { ats_type_code: 'jazzhr', ats_type_name: 'JazzHR' },
  { ats_type_code: 'workable', ats_type_name: 'Workable' },
  { ats_type_code: 'rippling', ats_type_name: 'Rippling' },
  { ats_type_code: 'icims', ats_type_name: 'iCIMS' },
  { ats_type_code: 'taleo', ats_type_name: 'Taleo' },
  { ats_type_code: 'smartrecruiters', ats_type_name: 'SmartRecruiters' },
  { ats_type_code: 'eightfold', ats_type_name: 'Eightfold' },
  { ats_type_code: 'builtin', ats_type_name: 'BuiltIn' },
  { ats_type_code: 'wellfound', ats_type_name: 'Wellfound' },
  { ats_type_code: 'ycombinator', ats_type_name: 'YCombinator' },
  { ats_type_code: 'myworkday', ats_type_name: 'MyWorkday' }
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
