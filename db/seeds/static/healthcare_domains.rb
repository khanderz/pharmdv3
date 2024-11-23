# frozen_string_literal: true

healthcare_domains = [
  { key: 'ALLERGY_IMMUNOLOGY', value: 'Allergy and Immunology',
    aliases: ['allergy', 'immunodeficiency', 'adaptive immunity', 'innate immunityimmunodeficient', 'immunodeficiencies', 'antibodies', 'immune system', 'immunotherapy', 'asthma', 'hay fever', 'eczema', 'anaphylaxis', 'joint health', 'autoimmune', 'rheumatic', 'rheumatoid arthritis', 'lupus', 'spondylitis'] },
  { key: 'CARDIOLOGY', value: 'Cardiology',
    aliases: ['heart', 'cardiac', 'cardiovascular', 'hypertension', 'heart disease', 'arrhythmia', 'heart attack'] },
  { key: 'DENTAL', value: 'Dental',
    aliases: ['dentistry', 'oral', 'teeth', 'orthodontics', 'dental', 'cavities', 'gum disease', 'tooth decay'] },
  { key: 'DERMATOLOGY', value: 'Dermatology',
    aliases: ['skin', 'skincare', 'dermatological', 'dermatology', 'acne', 'eczema', 'psoriasis', 'skin cancer'] },
  { key: 'DIGITAL_HEALTH', value: 'Digital Health',
    aliases: ['telemedicine', 'virtual', 'e-health', 'telehealth', 'remote health', 'health tech', 'AI based', 'wearables', 'mobile app', 'web app', 'app'] },
  { key: 'EMERGENCY_MEDICINE', value: 'Emergency Medicine',
    aliases: ['urgent', 'emergency', 'trauma', 'resuscitation', 'critical care'] },
  { key: 'ENDOCRINOLOGY', value: 'Endocrinology',
    aliases: ['hormone health', 'diabetes', 'metabolic', 'diabetic', 'insulin', 'thyroid', 'hypothyroidism', 'hyperthyroidism', 'adrenal'] },
  { key: 'ENT', value: 'Ear, Nose, and Throat',
    aliases: ['ENT care', 'otolaryngology', 'head and neck', 'hearing', 'auditory', 'nasal', 'throat', 'sinusitis', 'tonsillitis', 'hearing loss', 'lung', 'lungs', 'breathe', 'air', 'air pollution', 'respiratory', 'COPD', 'pulmonary', 'respiratory', 'asthma', 'bronchitis', 'emphysema'] },
  { key: 'EPIDEMIOLOGY', value: 'Epidemiology',
    aliases: ['disease control', 'public health', 'epidemiological', 'community health', 'health education', 'population health', 'pandemic', 'infectious diseases', 'infectious', 'epidemiology', 'disease prevention', 'COVID-19', 'HIV/AIDS', 'hepatitis', 'tuberculosis', 'malaria', 'covid', 'ebola'] },
  { key: 'ENVIRONMENTAL_HEALTH', value: 'Environmental Health',
    aliases: ['environmental', 'environmental medicine', 'environmental science', 'pollution', 'toxins', 'climate change'] },
  { key: 'GASTROENTEROLOGY', value: 'Gastroenterology',
    aliases: ['digestive', 'GI', 'gastrointestinal health', 'IBS', 'crohn\'s', 'ulcerative colitis', 'acid reflux', 'liver disease', 'gerd'] },
  { key: 'GENETICS', value: 'Genetics',
    aliases: ['genomics', 'gene therapy', 'genetic counseling', 'genomic', 'gene', 'reproductive technology', 'hereditary', 'cystic fibrosis'] },
  { key: 'GERIATRICS', value: 'Geriatrics',
    aliases: %w[elder elderly senior geriatric aging dementia osteoporosis arthritis] },
  { key: 'HEMATOLOGY', value: 'Hematology',
    aliases: %w[blood hematologic anemia hematology leukemia lymphoma hemophilia] },
  {
    key: 'MENS_HEALTH', value: 'Men\'s Health', aliases: ['urology', 'prostate', 'erectile dysfunction', 'testosterone']
  },
  { key: 'NEPHROLOGY', value: 'Nephrology',
    aliases: ['kidney', 'renal', 'nephrology', 'dialysis', 'kidney disease', 'chronic kidney disease', 'ckd', 'urinary', 'kidney', 'urological', 'prostate', 'kidney stones', 'incontinence'] },
  { key: 'NEUROLOGY', value: 'Neurology',
    aliases: ['brain', 'neurological', 'neuroscience', 'neurodegenerative', 'epilepsy', 'parkinson\'s disease', 'Alzheimers', 'migraine'] },
  { key: 'NURSING', value: 'Nursing',
    aliases: ['nurse', 'nursing', 'nurse practitioners', 'patient care'] },
  { key: 'ONCOLOGY', value: 'Oncology',
    aliases: ['cancer', 'oncological', 'cancer treatment', 'chemotherapy', 'chemo', 'precision medicine', 'immuno-oncology', 'breast cancer', 'lung cancer', 'leukemia'] },
  { key: 'OPTOMETRY', value: 'Optometry',
    aliases: ['eye care', 'vision health', 'ophthalmology', 'vision', 'ocular', 'glasses', 'cataract', 'glaucoma', 'macular degeneration'] },
  { key: 'ORTHOPEDICS', value: 'Orthopedics',
    aliases: ['bone', 'bones', 'musculoskeletal', 'orthopedic', 'joint replacement', 'arthritis', 'osteoporosis'] },
  { key: 'PATHOLOGY', value: 'Pathology',
    aliases: ['disease diagnosis', 'diagnosis', 'testing', 'lab', 'laboratory', 'pathology', 'biopsy', 'tumor analysis'] },
  { key: 'PEDIATRICS', value: 'Pediatrics',
    aliases: ['child', 'pediatric', 'childcare', 'children', 'developmental disorders'] },
  { key: 'PHARMA', value: 'Pharmaceuticals',
    aliases: ['pharmacy', 'medication', 'drug development', 'pharmacology', 'medicinal chemistry', 'drugs', 'drug', 'biomanufacturing', 'antibodies', 'monoclonal', 'vaccines', 'biologics'] },
  { key: 'PHYSICAL_THERAPY', value: 'Physical Therapy',
    aliases: ['physiotherapy', 'rehabilitation', 'movement', 'recovery', 'rehab', 'post surgery', 'rehabilitation', 'musculoskeletal injuries'] },
  { key: 'PODIATRY', value: 'Podiatry',
    aliases: ['foot', 'podiatric', 'feet', 'orthotics', 'prosthetics', 'bunions', 'plantar fasciitis'] },
  { key: 'PRIMARY_CARE', value: 'Primary Care',
    aliases: ['general health', 'family', 'primary health', 'wellness', 'preventative', 'vaccinations'] },
  { key: 'PSYCHIATRY', value: 'Psychiatry',
    aliases: ['mental health', 'behavioral health', 'psychotherapy', 'behavioral therapy', 'psychiatric', 'mental health treatment', 'ptsd', 'neurofeedback', 'mental wellness', 'depression', 'anxiety', 'bipolar disorder'] },
  { key: 'RADIOLOGY', value: 'Radiology',
    aliases: ['imaging', 'medical imaging', 'diagnostic imaging', 'x-ray', 'tissue imaging', 'ultrasound', 'MRI', 'CT scan'] },
  { key: 'REPRODUCTIVE_HEALTH', value: 'Reproductive Health',
    aliases: ['fertility', 'family planning', 'reproductive', 'genetic counseling', 'fertility treatments', 'IVF', 'birth control'] },
  { key: 'RESEARCH', value: 'Research',
    aliases: ['clinical research', 'medical studies', 'biomedical research', 'biomedical', 'research', 'data activation', 'molecular', 'clinical trials', 'drug trials', 'discovery', 'biotechnology'] },
  { key: 'SLEEP_HEALTH', value: 'Sleep Health',
    aliases: ['sleep health', 'sleep disorders', 'insomnia', 'sleep', 'sleep apnea', 'narcolepsy'] },
  { key: 'SOCIAL_WORK', value: 'Social Work',
    aliases: ["social work", "community health", "social determinants of health", "case management", "social services", "family support", "counseling", "advocacy"]},
  { key: 'SPEECH_THERAPY', value: 'Speech Language Pathology',
    aliases: ['speech', 'language', 'communication', 'voice therapy', 'dysphagia', 'stuttering', 'aphasia'] },
  { key: 'SURGERY', value: 'Surgery',
    aliases: ['surgical', 'operative', 'operations', 'procedures', 'surgery', 'minimally invasive', 'heart surgery', 'organ transplant'] },
  {
    key: 'WOMENS_HEALTH', value: 'Women\'s Health',
    aliases: ['gynecology', 'obstetrics', 'pregnancy', 'menstrual', 'menopause', 'breast health', 'reproductive health', 'pelvic health', 'prenatal', 'contraception', 'hormone therapy', 'pap smear', 'mammogram', 'maternity', 'pregnant', 'childbirth']
  }
]

seeded_count = 0
existing_count = 0
updated_count = 0

healthcare_domains.each do |domain|
  domain_record = HealthcareDomain.find_or_initialize_by(key: domain[:key])

  if domain_record.persisted?
    existing_count += 1
    updates_made = false

    if domain_record.value != domain[:value]
      domain_record.value = domain[:value]
      updates_made = true
      puts "Updated value for domain #{domain[:key]}."
    end

    if domain_record.aliases != domain[:aliases]
      domain_record.aliases = domain[:aliases]
      updates_made = true
      puts "Updated aliases for domain #{domain[:key]}."
    end

    if updates_made
      domain_record.save!
      updated_count += 1
      puts "Domain #{domain[:key]} updated in database."
    else
      puts "Domain #{domain[:key]} already up-to-date."
    end
  else
    domain_record.value = domain[:value]
    domain_record.aliases = domain[:aliases]
    domain_record.save!
    seeded_count += 1
    puts "Seeded new domain: #{domain[:key]} - #{domain[:value]} with aliases: #{domain[:aliases]}"
  end
rescue StandardError => e
  puts "Error seeding healthcare domain: #{domain[:key]} - #{e.message}"
end

total_domains_after = HealthcareDomain.count
puts "*******Seeded #{seeded_count} new healthcare domains. #{existing_count} domains already existed. #{updated_count} domains updated. Total domains in the table: #{total_domains_after}."
