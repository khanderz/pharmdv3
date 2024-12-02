# frozen_string_literal: true

# Seeding ATS types
ats_types = [
  { ats_type_code: 'ASHBYHQ', ats_type_name: 'AshbyHQ', domain_matched_url: 'https://jobs.ashbyhq.com/*', redirect_url: 'https://ashbyhq.com/', post_match_url: nil },
  { ats_type_code: 'BAMBOOHR', ats_type_name: 'BambooHR', domain_matched_url: 'https://*.bamboohr.com/careers', redirect_url: 'https://www.bamboohr.com/', post_match_url: nil  },
  { ats_type_code: 'BREEZYHR', ats_type_name: 'BreezyHR', domain_matched_url: 'https://*.breezy.hr', redirect_url: 'https://breezy.hr/', post_match_url: nil  },
  # { ats_type_code: 'BUILTIN', ats_type_name: 'BuiltIn' },
  { ats_type_code: 'DOVER', ats_type_name: 'Dover', domain_matched_url: 'https://app.dover.com/*/careers/', redirect_url: 'https://dover.com/', post_match_url: nil  },
  { ats_type_code: 'EIGHTFOLD', ats_type_name: 'Eightfold', domain_matched_url: 'https://*.eightfold.ai/careers', redirect_url: 'https://eightfold.ai/', post_match_url: nil  },
  { ats_type_code: 'FOUNTAIN', ats_type_name: 'Fountain', domain_matched_url: 'https://*.fountain.com/', redirect_url: 'https://fountain.com/', post_match_url: nil  },
  { ats_type_code: 'GEM', ats_type_name: 'Gem', domain_matched_url: 'https://jobs.gem.com/*', redirect_url: 'https://gem.com/', post_match_url: nil  },
  { ats_type_code: 'GREENHOUSE', ats_type_name: 'Greenhouse', domain_matched_url: 'https://job-boards.greenhouse.io/*', redirect_url: 'https://www.greenhouse.io/', post_match_url: "https://boards-api.greenhouse.io/v1/boards/{ats_id}/jobs?content=true"  },
  { ats_type_code: 'HRM_DIRECT', ats_type_name: 'HRM Direct', domain_matched_url: 'https://*.hrmdirect.com', redirect_url: 'https://www.hrmdirect.com/', post_match_url: nil  },
  # { ats_type_code: 'ICIMS', ats_type_name: 'iCIMS' },
  { ats_type_code: 'JAZZHR', ats_type_name: 'JazzHR', domain_matched_url: 'https://*.applytojob.com', redirect_url: 'https://info.jazzhr.com/job-seekers.html', post_match_url: nil  },
  { ats_type_code: 'LEVER', ats_type_name: 'Lever', domain_matched_url: 'https://jobs.lever.co/*', redirect_url: 'https://www.lever.co/', post_match_url: "https://api.lever.co/v0/postings/{ats_id}"  },
  # { ats_type_code: 'MYWORKDAY', ats_type_name: 'MyWorkday' },
  { ats_type_code: 'PINPOINTHQ', ats_type_name: 'PinpointHQ', domain_matched_url: 'https://*.pinpointhq.com', redirect_url: 'https://www.pinpointhq.com/', post_match_url: nil  },
  # { ats_type_code: 'PROPRIETARY', ats_type_name: 'Proprietary', domain_matched_url: nil, redirect_url: nil },
  { ats_type_code: 'RIPPLING', ats_type_name: 'Rippling', domain_matched_url: 'https://ats.rippling.com/*', redirect_url: 'https://www.rippling.com/', post_match_url: nil  },
  { ats_type_code: 'SCREENLOOP', ats_type_name: 'Screenloop', domain_matched_url: 'https://app.screenloop.com/careers/*', redirect_url: 'https://app.screenloop.com/auth/sign_in', post_match_url: nil  },
  { ats_type_code: 'SMARTRECRUITERS', ats_type_name: 'SmartRecruiters', domain_matched_url: 'https://careers.smartrecruiters.com/*', redirect_url: 'https://jobs.smartrecruiters.com/', post_match_url: nil  },
  # { ats_type_code: 'TALEO', ats_type_name: 'Taleo' },
  # { ats_type_code: 'WELLFOUND', ats_type_name: 'Wellfound' },
  { ats_type_code: 'WORKABLE', ats_type_name: 'Workable', domain_matched_url: 'https://apply.workable.com/*', redirect_url: 'https://www.workable.com/', post_match_url: nil  },
  { ats_type_code: 'YCOMBINATOR', ats_type_name: 'YCombinator', domain_matched_url: 'https://ycombinator.com/companies/*/jobs', redirect_url: 'https://www.ycombinator.com/', post_match_url: nil  },
  # { ats_type_code: 'ULTIPRO', ats_type_name: 'Ultipro' }
  # { ats_type_code: 'INDEED', ats_type_name: 'Indeed' }
  # { ats_type_code: 'LINKEDIN', ats_type_name: 'LinkedIn' }
  # { ats_type_code: 'GUSTO', ats_type_name: 'Gusto' }
  # { ats_type_code: 'PAYLOCITY', ats_type_name: 'Paylocity' }
]

seeded_count = 0
existing_count = 0
updated_count = 0

ats_types.each do |ats_type|
  ats_type_record = AtsType.find_or_initialize_by(ats_type_code: ats_type[:ats_type_code])

  if ats_type_record.persisted?
    existing_count += 1
    updates_made = false

    %i[ats_type_name domain_matched_url redirect_url post_match_url].each do |attr|
      next if ats_type_record[attr] == ats_type[attr]

      ats_type_record[attr] = ats_type[attr]
      updates_made = true
      puts "Updated #{attr} for ATS type #{ats_type[:ats_type_code]} to #{ats_type[attr]}."
    end

    if updates_made
      ats_type_record.save!
      updated_count += 1
      puts "ATS type #{ats_type[:ats_type_code]} updated in database."
    else
      puts "ATS type #{ats_type[:ats_type_code]} is already up-to-date."
    end
  else
    ats_type_record.assign_attributes(ats_type)
    ats_type_record.save!
    seeded_count += 1
    puts "Seeded new ATS type: #{ats_type[:ats_type_code]} - #{ats_type[:ats_type_name]}"
  end
end

total_ats_types = AtsType.count
puts "*********** Seeded #{seeded_count} new ATS types. #{existing_count} ATS types already existed. #{updated_count} ATS types updated. Total ATS types in the table: #{total_ats_types}."