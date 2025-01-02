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
                       audit budgeting revenue],
    'Business Analyst' => ['business analyst', 'business intelligence', 'business development',
                           'development analyst'],
    'Care Coordinator' => ['care coordinator', 'care manager', 'care'],
    'Chief Staff Officer' => ['chief of staff'],
    'Client Partner' => %w[partnerships partnership alliance],
    'Clinical Specialist' => ['health information', 'cannabis specialist', 'healtheconomics', 'geneticist', 'clinical', 'response team', 'aba', 'behavior', 'behavioral', 'eeg',
                              'health tech strategy', 'developmental therapies', 'pv scientist', 'pharmacovigilance',
                              'drug safety', 'bioinformatics'],
    'Community Health Worker' => ['community health', 'community outreach', 'community'],
    'Content Creator' => ['content', ' content writer', 'editor'],
    'Counsel' => %w[legal litigation contracts counsel compliance credentialing],
    'Customer Support Specialist' => ['customer', 'client', 'contact center', 'billing', 'intake',
                                      'problem'],
    'Data Engineer' => ['data analyst', 'data specialist', 'data engineer',
                        'statistical programmer', 'data visualization', 'computational engineer'],
    'Data Scientist' => ['data scientist', 'data architect', 'clinical data', 'statistics',
                         'clinical database', 'data science', 'data modeler', 'data', 'analytical', 'analytics'],
    'DevOps Engineer' => ['devops', 'site reliability', 'sre', 'cloud'],
    'DevSecOps Engineer' => ['systems architect', 'systems administrator'],
    'Digital Marketing Specialist' => ['seo'],
    'Director of Information Technology' => ['it director', 'information technology director'],
    'Director of Medical Affairs' => ['medical director', 'biotransformation director',
                                      'drug director', 'clinical director', 'biostatistics director'],
    'Executive Assistant' => ['executive assistant', 'office manager'],
    'Graduate' => %w[graduate intern fellow student internship],
    'Growth Analyst' => ['growth'],
    'Head of Clinical' => ['clinical head'],
    'Healthcare Analyst' => ['healthcare analytics'],
    'Human Resources Specialist' => ['hr', 'human resources', 'myworkday', 'workday', 'workforce',
                                     'leave of absence'],
    'Implementation Engineer' => %w[implementation integration],
    'Insurance Specialist' => ['clinical policy'],
    'IT Operations Specialist' => ['it operations', 'information technology', 'netsuite', 'it',
                                   'technical', 'oracle'],
    'Laboratory Technician' => %w[laboratory lab chemistry],
    'Machine Learning Engineer' => ['machine learning', 'ai engineer'],
    'Materials Management Specialist' => ['materials management', 'resources', 'asset',
                                          'manufacturing specialist'],
    'Marketing Specialist' => %w[marketing marketplace brand branding],
    'Mechanical Engineer' => ['mechanical engineer', 'fluidics engineer', 'mechanical design'],
    'Medical Coder' => ['medical coding', 'coding specialist'],
    'Medical Writer' => ['medical writing', 'policy writer'],
    'Nurse' => %w[nurse rn],
    'Nurse Practitioner' => ['nurse practitioner'],
    'Occupational Therapist' => ['occupational therapy'],
    'Operations Specialist' => ['vertical', 'business operations', 'strategy', 'operations', 'ops',
                                'process specialist'],
    'Pharmacist' => ['pharmacist'],
    'Pharmacy Technician' => ['pharmacy technician'],
    'Physician' => ['physician', 'doctor', 'md', 'practice provider'],
    'Process Engineer' => ['automation'],
    'Product Manager' => ['product manager'],
    'Project Manager' => ['project manager', 'jira', 'projects manager'],
    'Public Relations' => ['public relations', 'communications'],
    'Quality Assurance Engineer' => ['qa engineer', 'software quality', 'test engineer',
                                     'validation engineer'],
    'Quality Assurance Specialist' => %w[quality qc],
    'Recruiter' => ['talent', 'people ops', 'recruiting'],
    'Regional Marketer' => ['regional sales', 'regional account'],
    'Research Scientist' => %w[research researcher discovery],
    'Revenue Operations Analyst' => ['revenue'],
    'Safety Specialist' => ['safety', 'environmental health', 'ehs'],
    'Sales Representative' => ['sales', 'user acquisition', 'buyer', 'b2b', 'reimbursement'],
    'Salesforce Specialist' => ['salesforce'],
    'Scientist' => ['development scientist'],
    'Security Engineer' => ['security engineer', 'cybersecurity engineer'],
    'Social Worker' => ['lcsw'],
    'Software Engineer' => ['fullstack', 'product engineering', 'software engineer', 'developer',
                            'software engineering', 'sde', 'swe', 'software development'],
    'Solutions Engineer' => ['solutions engineer', 'escalation engineer', 'support engineer',
                             'sales engineer', 'customer engineer'],
    'Supply Chain Analyst' => ['supply chain', 'inventory control'],
    'Territory Manager' => ['area'],
    'Therapist' => ['licensed therapist', 'mental health therapist'],
    'Trainer' => %w[training learning education training],
    'Warehouse Associate' => ['packaging associate', 'packaging technician', 'cultivation', 'machine operator', 'batch auditor', 'warehouse',
                              'facility', 'facilities', 'fulfillment', 'production supervisor', 'packaging supervisor',
                              'packaging agent', 'processing technician', 'processing agent', 'manufacturing',
                              'equipment technician', 'maintenance technician', 'maintenance', 'delivery manager',
                              'manufacturing operator', 'truck operator', 'cultivation', 'delivery driver', 'delivery associate',
                              'handler', 'automation technician'],
    'UI/UX Designer' => %w[designer art design "motion designer"],
  }.freeze

  def self.find_or_create_job_role(job_title)
    titles = Utils::TitleCleaner.clean_title(job_title)
    puts "#{BLUE}original title #{job_title}#{RESET}"
    puts "#{BLUE}titles #{titles}#{RESET}"
    cleaned_title = titles[:cleaned_title].presence || titles[:modified_title]
    modified_title = titles[:modified_title]

    KEYWORD_MAPPINGS.each do |mapped_role, keywords|
      keyword_regex = Regexp.union(keywords.map { |keyword| /\b#{Regexp.escape(keyword)}\b/i })
      if cleaned_title.match?(keyword_regex) || modified_title.match?(keyword_regex)
        job_role = find_by(role_name: mapped_role)
        puts "#{ORANGE}Normalized name match to one of #{keywords}, matching job role to #{mapped_role}#{RESET}"
        return job_role if job_role
      end
    end

    job_role = JobRole.find_by('LOWER(role_name) = ?', modified_title.downcase)
    job_role ||= JobRole.find_by('LOWER(role_name) = ?', cleaned_title.downcase)

    if job_role.nil?
      job_role = JobRole.where('LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                               cleaned_title.downcase).first
      job_role ||= JobRole.where('LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                                 modified_title.downcase).first
    end

    if job_role.nil?
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

    end

    puts "Job Role: #{job_role.role_name} found."
    job_role
  end
end
