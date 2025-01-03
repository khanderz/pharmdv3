# frozen_string_literal: true

class JobRole < ApplicationRecord
  has_many :job_roles_departments
  has_many :departments, through: :job_roles_departments

  has_many :job_roles_teams
  has_many :teams, through: :job_roles_teams

  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :role_name, presence: true, uniqueness: true

  KEYWORD_MAPPINGS = {
    'Account Manager' => ['account', 'partner', 'partners', 'account executive', 'accounts',
                          'channel'],
    'Accountant' => %w[payroll accountant accounting finance financial collections
                       audit budgeting revenue fpa],
    'Auditor' => %w[audit risk],
    'Business Analyst' => ['business analyst', 'business intelligence', 'business development',
                           'development analyst', 'strategy', 'service analyst', 'services analyst'],
    'Care Coordinator' => ['care coordinator', 'care manager', 'care'],
    'Chief Staff Officer' => ['chief of staff'],
    'Client Partner' => %w[partnerships partnership alliance],
    'Clinical Engineer' => ['field clinical engineer', 'medical imaging engineer'],
    'Clinical Specialist' => ['health information', 'cannabis specialist', 'healtheconomics', 'geneticist', 'clinical', 'response team', 'aba', 'behavior', 'behavioral', 'eeg',
                              'health tech strategy', 'developmental therapies', 'pv scientist', 'pharmacovigilance',
                              'drug safety', 'bioinformatics', 'wellness', 'genomics', 'patient engagement', 'pharmacology'],
    'Community Health Worker' => ['community health', 'community outreach', 'community'],
    'Content Creator' => ['content', ' content writer', 'editor', 'creative producer'],
    'Counsel' => %w[legal litigation contracts counsel compliance credentialing attorney paralegal
                    patent contract contracting compliances],
    'Customer Support Specialist' => ['call center', 'customer', 'client', 'contact center', 'billing', 'intake',
                                      'problem', 'member support', 'service representative'],
    'Data Engineer' => ['data analyst', 'data specialist', 'data engineer',
                        'statistical programmer', 'data visualization', 'computational engineer',
                        'database reliability'],
    'Data Scientist' => ['data scientist', 'data architect', 'clinical data', 'statistics',
                         'clinical database', 'data science', 'data modeler', 'data', 'analytical', 'analytics',
                         'database'],
    'Design Engineer' => ['design engineer'],
    'DevOps Engineer' => ['devops', 'site reliability', 'sre', 'cloud'],
    'Digital Marketing Specialist' => ['seo', 'social media'],
    'Director of Information Technology' => ['it director', 'information technology director'],
    'Director of Medical Affairs' => ['medical director', 'biotransformation director',
                                      'drug director', 'clinical director', 'biostatistics director'],
    'Executive Assistant' => ['executive assistant', 'office manager'],
    'General Manager' => ['general manager', 'gm', 'store manager'],
    'Geneticist' => ['genetic counseling', 'genetic counselor'],
    'Graduate' => %w[graduate intern fellow student internship],
    'Growth Analyst' => ['growth'],
    'Head of Clinical' => ['clinical head'],
    'Hardware Engineer' => ['hardware engineer', 'electrical engineer', 'electrical engineering'],
    'Healthcare Analyst' => ['healthcare analytics', 'healthcare actuarial'],
    'HEOR Specialist' => ['heor', 'health outcomes'],
    'Human Resources Specialist' => ['hr', 'human resources', 'myworkday', 'workday', 'workforce',
                                     'leave of absence', 'people'],
    'Implementation Engineer' => %w[implementation integration integrations],
    'Insurance Specialist' => ['clinical policy', 'insurance analyst', 'benefits'],
    'IT Operations Specialist' => ['it operations', 'information technology', 'netsuite', 'it',
                                   'technical', 'oracle'],
    'Laboratory Technician' => %w[laboratory lab chemistry microfabrication],
    'Machine Learning Engineer' => ['machine learning', 'ai engineer', 'algorithm engineer'],
    'Materials Management Specialist' => ['materials management', 'resources', 'asset',
                                          'manufacturing specialist', 'procurement', 'materials planning',
                                          'demand planner', 'trade', 'sourcing'],
    'Marketing Specialist' => %w[marketing marketplace brand branding "strategic marketing" "market
                                 analyst" demand market],
    'Medical Information Specialist' => ['medical information'],
    'Mechanical Engineer' => ['mechanical engineer', 'fluidics engineer', 'mechanical design'],
    'Medical Coder' => ['medical coding', 'coding specialist'],
    'Medical Science Liaison' => ['medical science liaison', 'msl', 'medical affairs'],
    'Medical Writer' => ['medical writing', 'policy writer'],
    'Nurse' => %w[nurse rn],
    'Nurse Practitioner' => ['nurse practitioner', 'np'],
    'Occupational Therapist' => ['occupational therapy'],
    'Operations Specialist' => ['vertical', 'business operations', 'strategy', 'operations', 'ops',
                                'process specialist'],
    'Patient Care Specialist' => ['patient care', 'patient services', 'patient support'],
    'Pharmacist' => ['pharmacist'],
    'Pharmacy Technician' => ['pharmacy technician'],
    'Physician' => ['physician', 'doctor', 'md', 'practice provider', 'practitioner'],
    'Process Engineer' => ['automation', 'Process Engineer'],
    'Product Manager' => ['product manager', 'product owner', 'product management', 'product lead',
                          'product leader'],
    'Project Manager' => ['project manager', 'jira', 'projects manager', 'program manager',
                          'program management'],
    'Public Relations' => ['public relations', 'communications', 'investor relations'],
    'Quality Assurance Engineer' => ['qa engineer', 'software quality', 'test engineer',
                                     'validation engineer'],
    'Quality Assurance Specialist' => %w[quality qc qa],
    'Recruiter' => ['talent', 'people ops', 'recruiting'],
    'Regional Marketer' => ['regional sales', 'regional account', 'regional business',
                            'regional marketer', 'regional manager', 'regional director',
                            'territory manager', 'regional leader'],
    'Regulatory Specialist' => ['regulatory'],
    'Research Scientist' => %w[research researcher discovery "research associate"],
    'Revenue Operations Analyst' => ['revenue'],
    'Robotics Engineer' => ['mechatronics'],
    'Safety Specialist' => ['safety', 'environmental health', 'ehs'],
    'Sales Representative' => ['sales', 'user acquisition', 'buyer', 'b2b', 'reimbursement'],
    'Salesforce Specialist' => ['salesforce'],
    'Scientist' => ['dmpk', 'development scientist', 'chemist', 'translational scientist',
                    'scientist associate', 'biotransformation', 'bioanalysis', 'cns scientist',
                    'process scientist', 'applications scientist', 'protein scientist', 'cell scientist',
                    'formulation scientist'],
    'Security Engineer' => ['security engineer', 'cybersecurity engineer', 'security architect'],
    'Social Worker' => ['lcsw', 'social worker', 'acsw'],
    'Software Engineer' => ['android', 'ios', 'engineering manager', 'fullstack', 'product engineering', 'software engineer', 'software developer',
                            'software engineering', 'sde', 'swe', 'software development', 'managing engineer', 'principal engineer', 'applications engineer'],
    'Solutions Engineer' => ['solutions engineer', 'escalation engineer', 'support engineer',
                             'sales engineer', 'customer engineer'],
    'Systems Engineer' => ['systems architect', 'systems administrator'],
    'Supply Chain Analyst' => ['supply chain', 'inventory control'],
    'Territory Manager' => ['area'],
    'Therapist' => ['licensed therapist', 'mental health therapist', 'therapy consultant',
                    'therapy specialist', 'adolescent therapist', 'therapist supervisor',
                    'associate therapist'],
    'Trainer' => %w[training learning education training trainer],
    'Warehouse Associate' => ['operator', 'shift technician', 'shift tech', 'production technician', 'section grower', 'production shift', 'custodian', 'packaging associate', 'packaging technician', 'cultivation', 'batch auditor', 'warehouse',
                              'facility', 'facilities', 'fulfillment', 'production supervisor', 'packaging supervisor',
                              'packaging agent', 'processing technician', 'processing agent', 'manufacturing',
                              'equipment technician', 'maintenance technician', 'maintenance', 'delivery manager',
                              'cultivation', 'delivery driver', 'delivery associate', 'hvac', 'equipment technician',
                              'handler', 'automation technician', 'shipping associate', 'receiving associate'],
    'UI/UX Designer' => %w[designer art design "motion designer"],
    'UX Researcher' => ['ux researcher', 'user experience', 'web optimization', 'web experience',
                        'site success'],
    'Veterinarian' => ['veterinarian'],
  }.freeze

  def self.find_or_create_job_role(job_title)
    titles = Utils::TitleCleaner.clean_title(job_title)
    puts "#{BLUE}original title #{job_title}#{RESET}"
    puts "#{BLUE}titles #{titles}#{RESET}"
    cleaned_title = titles[:cleaned_title].presence || titles[:modified_title]
    modified_title = titles[:modified_title]

    job_role = JobRole.find_by('LOWER(role_name) = ?', modified_title.downcase)
    job_role ||= JobRole.find_by('LOWER(role_name) = ?', cleaned_title.downcase)

    if job_role.nil?
      job_role = JobRole.where('LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                               cleaned_title.downcase).first
      job_role ||= JobRole.where('LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                                 modified_title.downcase).first
    end

    if job_role
      puts "#{GREEN}Job Role: #{job_role.role_name} found in existing data.#{RESET}"
      return job_role
    end

    KEYWORD_MAPPINGS.each do |mapped_role, keywords|
      keyword_regex = Regexp.union(keywords.map { |keyword| /\b#{Regexp.escape(keyword)}\b/i })
      next unless cleaned_title.match?(keyword_regex) || modified_title.match?(keyword_regex)

      job_role = find_by(role_name: mapped_role)
      if job_role
        puts "#{ORANGE}Normalized name match to one of #{keywords}, matching job role to #{mapped_role}.#{RESET}"
        return job_role
      end
    end

    job_role = JobRole.create!(
      role_name: cleaned_title,
      error_details: "Job Role: #{titles} not found in existing records",
      resolved: false
    )
    Adjudication.log_error(
      adjudicatable_type: 'JobRole',
      adjudicatable_id: job_role.id,
      error_details: "Job Role: #{titles} for original role #{job_title} not found in existing records"
    )

    puts "#{RED}Job Role: #{job_role.role_name} not found; created a new record.#{RESET}"
    job_role
  end
end
