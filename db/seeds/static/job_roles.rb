# frozen_string_literal: true

job_roles = [
  { role_name: 'Account Manager',
    aliases: ['strategic account manager', 'central account executive', 'dental account executive', 'Provider Account Manager', 'clinical account manager', 'Pharmacy Partner Coordinator', 'SMB Account Executive', 'Manager Franchise Portfolio Management', 'Account Development Representative', 'National Strategic Accounts Manager', 'account operations', 'strategic account executive', 'specialty account manager', 'Account Exec', 'Client Manager', 'Account Executive', 'growth account executive', 'Enterprise Account Executive'], department_names: ['Sales'], team_names: ['Sales'] },

  { role_name: 'Accountant',
    aliases: ['Strategic Finance', 'cost accountant', 'corporate finance manager', 'Accounting Specialist', 'Financial Analyst', 'Accounting Manager', 'Finance Manager', 'Accounting Clerk', 'Accounting Associate', 'Accounting Consultant'], department_names: ['Finance'], team_names: ['Finance'] },

  { role_name: 'Auditor',
    aliases: ['Internal Auditor', 'External Auditor', 'Audit Manager', 'Audit Specialist', 'Audit Analyst', 'Audit Consultant', 'Audit Associate', 'Audit Clerk'], department_names: ['Finance'], team_names: ['Finance'] },

  { role_name: 'Business Analyst',
    aliases: ['Business Development Manager', 'IT business analyst', 'Business Intelligence Analyst', 'Financial Analyst', 'Business Intelligence Specialist', 'Business Intelligence Consultant',], department_names: ['Business Development', 'Finance'], team_names: ['Business Intelligence', 'Finance'] },

  {
    role_name: 'Client Partner',
    aliases: ['Strategic Client Partner', 'Client Relationship Manager', 'Key Account Partner',
              'Customer Success Partner', 'Strategic Partner Manager'],
    department_names: ['Sales', 'Customer Support', 'Business Development'],
    team_names: ['Client Services', 'Sales']
  },
  { role_name: 'Compliance Manager', aliases: ['Legal Operations Manager', 'Compliance Specialist', 'Compliance Analyst', 'Compliance Officer', 'Compliance Consultant'],
    department_names: ['Legal'], team_names: ['Legal'] },

  { role_name: 'Content Creator', aliases: ['Content Strategist & Writer', 'Content Specialist', 'Content Manager', 'Content Strategist', 'Content Writer', 'Content Marketing Manager', 'Content Marketing Specialist', 'Social Expert & Content Creator'],
    department_names: ['Editorial'], team_names: ['Marketing'] },

  { role_name: 'Controller',
    aliases: ['assistant controller', 'Finance Controller', 'Accounting Controller', 'Financial Controller'], department_names: ['Finance'], team_names: ['Finance'] },

  { role_name: 'Copywriter', aliases: ['Content Writer', 'Content Creator', 'Content Specialist', 'Content Manager', 'Content Strategist', 'Content Marketing Manager', 'Content Marketing Specialist', 'Social Expert & Content Creator'],
    department_names: ['Editorial'], team_names: ['Marketing'] },

  { role_name: 'Counsel',
    aliases: ['general counsel', 'compliance attorney', 'paralegal', 'Legal Counsel', 'Legal Advisor', 'Legal Specialist', 'Legal Analyst', 'Legal Consultant'], department_names: ['Legal'], team_names: ['Legal'] },

  { role_name: 'Customer Support Specialist',
    aliases: ['Call Center Representative', 'customer service representative', 'call center specialist', 'Bilingual Spanish Customer Service', 'Contact Center Quality', 'Customer Service', 'Support Agent', 'Helpdesk', 'customer success manager', 'Customer Support Manager', 'Customer Support Training Specialist', 'Training Specialist', 'Trust and Safety Analyst', 'Voice Customer Service Representative', 'customer support representative'], department_names: ['Customer Support'], team_names: ['Client Services'] },

  { role_name: 'Digital Marketing Specialist',
    aliases: ['Online Marketing Manager', 'SEO Specialist', 'Digital Marketer', 'Marketing Analyst'], department_names: ['Marketing'], team_names: ['Marketing'] },

  { role_name: 'Executive Assistant', aliases: ['Administrative Assistant', 'Office Manager', 'Personal Assistant', 'Administrative Coordinator', 'Office Assistant', 'Administrative Specialist', 'Administrative Associate', 'Administrative Consultant'],
    department_names: ['Executive'], team_names: ['Executive'] },

  {
    role_name: 'External Engagement Manager',
    aliases: ['Engagement Manager', 'Client Engagement Manager', 'External Affairs Manager',
              'Senior Engagement Manager'],
    department_names: ['Marketing', 'Customer Support'],
    team_names: ['Client Services', 'Marketing']
  },

  { role_name: 'General Manager',
    aliases: ['assistant general manager', 'GM', 'Operations Manager', 'Business Manager', 'Branch Manager', 'Store Manager', 'Market Owner'], department_names: ['Operations'], team_names: ['Operations'] },

  { role_name: 'Graduate',
    aliases: ['Pharmacy Intern', 'postdoc', 'Intern', 'Internship', 'Fellow', 'Resident', 'Trainee', 'Apprentice', 'New Graduate Product Leadership Program', 'new graduate'], department_names: %w[Internship], team_names: %w[Internship] },

  { role_name: 'Growth Analyst', aliases: ['Analyst of Growth & Revenue Operations', 'Media Revenue Growth Analyst', 'Growth Marketing Analyst', 'Growth Marketing Specialist', 'Growth Marketing Manager', 'Growth Marketing Lead'],
    department_names: ['Marketing'], team_names: ['Marketing'] },

  { role_name: 'Human Resources Specialist', aliases: [],
    department_names: ['Human Resources'], team_names: ['Human Resources'] },

  { role_name: 'Marketing Specialist',
    aliases: ['Manager of Market Access', 'engagement marketing manager', 'enrollment marketing associate', 'strategic customer marketing manager', 'partner marketing manager', 'marketing coordinator', 'Marketer', 'Digital Marketer', 'Brand Manager', 'Marketing Manager', 'Product Marketing Manager', 'Enterprise Marketing Manager'], department_names: ['Marketing'], team_names: ['Marketing'] },

  {
    role_name: 'Materials Management Specialist',
    aliases: ['Materials Specialist', 'Inventory Specialist', 'Supply Chain Specialist',
              'Warehouse Specialist', 'Specialist of Materials Management'],
    department_names: ['Operations', 'Supply Chain'],
    team_names: ['Supply Chain']
  },

  { role_name: 'New Verticals Founder',
    aliases: ['New Verticals Lead', 'New Verticals Manager', 'New Verticals Director', 'New Verticals Specialist'], department_names: ['Operations', 'Product Management', 'Strategy & Operations'], team_names: ['Product', 'Product/S&O'] },

  { role_name: 'Operations Specialist',
    aliases: ['Knowledge Management Associate', 'Clinical Business Operations Manager', 'Operations Associate', 'Operations Analyst', 'Operations Coordinator', 'Operations Writer', 'Knowledge operations writer', 'product operations associate', 'Strategy & Operations', 'revenue operations'], department_names: ['Operations', 'Human Resources'], team_names: ['Operations'] },

  {
    role_name: 'People Business Partner',
    aliases: ['HR Business Partner', 'Strategic People Partner', 'Workforce Partner',
              'Human Resources Partner'],
    department_names: ['Human Resources', 'Operations'],
    team_names: ['Human Resources']
  },

  { role_name: 'Product Analyst', aliases: ['analyst of insights', 'product operations', 'Product Data Analyst', 'Product Insights Analyst', 'Product Insights Specialist', 'Product Insights Manager', 'Product Insights Lead'],
    department_names: ['Product Management'], team_names: ['Product'] },

  { role_name: 'Product Manager', aliases: ['PM', 'Product Lead', 'Product Owner', 'group product manager'],
    department_names: ['Product Management'], team_names: ['Product'] },

  { role_name: 'Project Manager',
    aliases: ['Project Manager EPMO Operations', 'PM', 'Project Lead', 'Operations Manager', 'program manager'], department_names: ['Operations', 'Product Management'], team_names: ['Product'] },

  { role_name: 'Public Relations', aliases: ['PR Specialist', 'PR Manager', 'PR Director', 'PR Lead', 'PR and Communications manager', 'communications specialist', 'communications manager'],
    department_names: ['Public Relations'], team_names: ['Public Relations'] },

  { role_name: 'Quality Assurance Specialist', aliases: ['Quality Compliance Manager', 'qc specialist', 'manager of quality', 'Specialist of Quality Control', 'QA Specialist', 'Quality Specialist', 'Quality Analyst', 'QA Analyst', 'Quality Assurance Analyst'],
    department_names: ['Quality Assurance'], team_names: ['Quality Assurance'] },

  { role_name: 'Regulatory Specialist',
    aliases: ['Regulatory Affairs Specialist', 'Regulatory Affairs Manager', 'Regulatory Affairs Associate', 'Regulatory Affairs Analyst', 'Regulatory Affairs Consultant', 'Regulatory Affairs Officer'], department_names: ['Regulatory Affairs'], team_names: ['Regulatory Affairs'] },

  { role_name: 'Receptionist', aliases: ['office team', 'office coordinator', 'Front Desk Receptionist', 'Front Desk Coordinator', 'Front Desk Associate', 'Front Desk Manager', 'Front Desk Specialist', 'Front Desk Clerk', 'Front Desk Agent', 'Front Desk Supervisor', 'bilingual front desk receptionist'],
    department_names: ['Operations'], team_names: ['Operations'] },

  { role_name: 'Recruiter',
    aliases: ['HR Generalist and Talent Acquisition Specialist', 'Corporate Recruiter', 'Talent Acquisition Specialist', 'HR Recruiter', 'Technical Recruiter', 'Recruitment Specialist'], department_names: ['Human Resources'], team_names: ['Human Resources'] },

  { role_name: 'Regional Marketer', aliases: ['regional associate', 'Regional Marketing Specialist', 'Regional Marketing Manager',
                                              'Regional Sales Manager', 'Regional Operations Manager', 'Regional Business Manager', 'Regional Account Manager', 'Regional Manager'],
    department_names: %w[Sales Operations Marketing], team_names: %w[Sales Operations Marketing] },

  { role_name: 'Revenue Operations Analyst', aliases: ['manager revenue operations', 'Revenue Operations Analyst', 'Revenue Operations Specialist', 'Revenue Operations Manager', 'Revenue Operations Lead'],
    department_names: ['Operations'], team_names: ['Operations'] },

  { role_name: 'Safety Specialist',
    aliases: ['Safety Specialist', 'Safety Manager', 'Safety Coordinator', 'Safety Consultant', 'Safety Analyst', 'Safety Associate', 'Safety Officer', 'Safety Supervisor'], department_names: ['Operations'], team_names: ['Operations'] },

  { role_name: 'Sales Representative',
    aliases: ['Sales Support Specialist', 'Payer Relations Specialist', 'inside sales representative', 'therapeutic sales specialist', 'Field Reimbursement Manager', 'Aesthetic Sales Consultant', 'Sales Rep', 'Account Manager', 'Sales Exec', 'Sales', 'Core Sales', 'sales development representative'], department_names: ['Sales'], team_names: ['Sales'] },

  { role_name: 'Supply Chain Analyst', aliases: ['Supply Chain Analyst', 'Supply Chain Specialist', 'Supply Chain Manager', 'Supply Chain Lead', 'Supply Chain Coordinator', 'Supply Chain Consultant', 'Supply Chain Associate'],
    department_names: ['Supply Chain'], team_names: ['Supply Chain'] },

  { role_name: 'Territory Manager', aliases: ['Territory Sales Manager', 'Territory Manager', 'Area Manager', 'Regional Manager'],
    department_names: ['Sales'], team_names: ['Sales'] },

  { role_name: 'Trainer', aliases: ['East Coast Field Training Manager', 'training coordinator', 'Training Specialist', 'Training Manager', 'Training Coordinator', 'Training Facilitator', 'corporate trainer'],
    department_names: ['Operations'], team_names: ['Operations'] },

  { role_name: 'Warehouse Associate', aliases: ['machine technician', 'greenhouse technician', 'Medical Device Reprocessing Technician', 'manufacturing technician', 'Material Handler', 'Maintenance Technician', 'Maintenance Supervisor', 'General Production Operator', 'Food Safety Site Manager', 'Food Manufacturing Sanitation Operator', 'Facilities and Maintenance Manager', 'Semiconductor Equipment Technician', 'Production Technician', 'Warehouse Operations Supervisor', 'Warehouse Training and Development Supervisor', 'Warehouse Specialist', 'Warehouse Worker', 'Warehouse Manager', 'Warehouse Clerk', 'Warehouse Coordinator', 'Warehouse Supervisor'],
    department_names: ['Operations'], team_names: ['Operations'] },
]

science_roles = [
  { role_name: 'Laboratory Technician', aliases: ['Quality Assurance Lab Technician', 'Quality Lab Supervisor'],
    department_names: ['Science'], team_names: ['Science'] },

  { role_name: 'Research Scientist', aliases: ['Research Associate of LNP Analytical Research and Development', 'Researcher', 'Research associate', 'Research Analyst', 'Research Associate', 'AI Research Scientist', 'Scientist Machine Learning'],
    department_names: ['Science'], team_names: ['Science'] },

  { role_name: 'Science Manager', aliases: ['Manager Molecular Pathology', 'Science Lead', 'Science Program Manager'],
    department_names: ['Science'], team_names: ['Science'] },

  { role_name: 'Scientific Solutions', aliases: ['Scientific Solutions Specialist', 'Scientific Solutions Manager', 'Scientific Solutions Lead', 'Scientific Solutions Consultant'],
    department_names: %w[Science Sales], team_names: ['Science'] },

  { role_name: 'Scientist', aliases: ['Microbiologist', 'Senior Scientist', 'Protein Testing Associate', 'analytical scientist', 'associate scientist'],
    department_names: ['Science'], team_names: ['Science'] },
]

technical_roles = [
  {
    role_name: 'Bioinformatics Engineer',
    aliases: ['Computational Biologist', 'Bioinformatics Developer', 'Bioinformatics Specialist',
              'Genomics Engineer', 'Bioinformatics Analyst', 'bioinformatics associate'],
    department_names: %w[Science Engineering],
    team_names: %w[Science Engineering]
  },

  { role_name: 'Clinical Engineer',
    aliases: ['Medical Engineer', 'Clinical Engineering Specialist', 'Clinical Engineering Analyst', 'Clinical Engineering Consultant', 'Clinical Engineering Associate'], department_names: ['Engineering', 'Clinical Team'], team_names: ['Engineering'] },

  { role_name: 'Computational Scientist',
    aliases: ['Computational Scientist Machine Learning', 'Computational Biologist', 'Computational Chemist', 'Computational Physicist', 'Computational Engineer', 'Computational Analyst', 'Computational Researcher'], department_names: ['Science'], team_names: ['Science'] },

  { role_name: 'Data Engineer',
    aliases: ['database engineer', 'MEMS Modeling and Simulation Engineer', 'Analytics Engineer', 'Data Platform Engineer', 'Data Infrastructure Engineer', 'Data Integration Engineer', 'Data Engineer', 'Data Engineering Specialist'], department_names: ['Engineering', 'Data Science'], team_names: ['Engineering', 'Data Science'] },

  { role_name: 'Data Scientist',
    aliases: ['Manager Data Analytics', 'data scientist manager', 'data product manager', 'Data Analyst', 'Statistician', 'Business Intelligence Analyst', 'BI Specialist', 'Data Specialist', 'Sales Data Analyst', 'Data Researcher'], department_names: ['Data Science', 'Engineering'], team_names: ['Engineering', 'Business Intelligence'] },

  { role_name: 'Design Engineer', aliases: ['Product Engineer', 'design quality engineer'], department_names: ['Engineering'],
    team_names: ['Engineering'] },

  { role_name: 'DevOps Engineer',
    aliases: ['Site Reliability Engineer', 'Cloud Engineer', 'Infrastructure Engineer', 'network engineer'], department_names: %w[Engineering IT], team_names: %w[DevOps Infrastructure] },

  {
    role_name: 'DevSecOps Engineer',
    aliases: ['Security DevOps Engineer', 'DevOps Security Engineer', 'Cloud Security Engineer',
              'Secure DevOps Engineer',],
    department_names: %w[Engineering IT],
    team_names: %w[Engineering IT]
  },

  { role_name: 'Electrical Engineer',
    aliases: ['Electrical Design Engineer', 'Electrical Engineering Manager', 'Electrical Engineering Specialist', 'Electrical Engineering Technician', 'Electrical Engineering Consultant', 'Electrical Engineering Analyst', 'Electrical Engineering Associate'], department_names: ['Engineering'], team_names: ['Engineering'] },

  { role_name: 'Field Service Engineer', aliases: ['Field Application Scientist', 'Field Service Engineer', 'Field Service Technician', 'Field Service Specialist', 'Field Service Consultant', 'Field Service Analyst', 'Field Service Associate'],
    department_names: ['Engineering'], team_names: ['Engineering'] },

  { role_name: 'Hardware Engineer',
    aliases: ['Hardware Design Engineer', 'Hardware Engineering Manager', 'Hardware Engineering Specialist', 'Hardware Engineering Technician', 'Hardware Engineering Consultant', 'Hardware Engineering Analyst', 'Hardware Engineering Associate'], department_names: ['Engineering'], team_names: ['Engineering'] },

  { role_name: 'IAM Engineer', aliases: ['Identity and Access Management Engineer', 'IAM Specialist', 'IAM Analyst', 'IAM Consultant', 'IAM Associate', 'IAM architect'],
    department_names: %w[Engineering IT], team_names: %w[Engineering IT] },

  { role_name: 'Implementation Engineer', aliases: ['Implementation Specialist', 'Implementation Consultant', 'Implementation Analyst', 'Implementation Associate', 'integration engineer'],
    department_names: %w[Engineering IT], team_names: ['Engineering'] },

  { role_name: 'IT Operations Specialist', aliases: ['IT Operations Specialist', 'IT Operations Analyst', 'IT Operations Engineer', 'IT Operations Consultant', 'IT Operations Associate'],
    department_names: ['IT'], team_names: ['IT'] },

  { role_name: 'Machine Learning Engineer',
    aliases: ['AI Engineer', 'ML Engineer', 'artificial intelligence engineer'], department_names: ['Engineering'], team_names: ['Engineering'] },

  { role_name: 'Mechanical Engineer',
    aliases: ['Mechanical Design Engineer', 'Mechanical Engineering Manager', 'Mechanical Engineering Specialist', 'Mechanical Engineering Technician', 'Mechanical Engineering Consultant', 'Mechanical Engineering Analyst', 'Mechanical Engineering Associate'], department_names: ['Engineering'], team_names: ['Engineering'] },

  { role_name: 'Platform Engineer', aliases: ['Platform Engineer', 'Platform Developer', 'Platform Specialist', 'Platform Architect'],
    department_names: ['Engineering'], team_names: ['Engineering'] },

  {
    role_name: 'Process Engineer',
    aliases: ['Process Optimization Engineer', 'Manufacturing Engineer', 'Production Engineer',
              'Process Development Engineer', 'Continuous Improvement Engineer', 'Wet Etch Process Engineer', 'Automation service engineer'],
    department_names: %w[Operations Engineering],
    team_names: ['Engineering']
  },

  { role_name: 'Quality Assurance Engineer', aliases: ['software development engineer in test', 'sdet', 'Test Engineer', 'API Testing Engineer', 'QA Engineer', 'Quality Engineer', 'Software Tester', 'QA Analyst', 'Quality Assurance Analyst', 'QA Tester', 'Quality Assurance Tester'],
    department_names: ['Quality Assurance', 'Engineering'], team_names: ['Quality Assurance', 'Engineering'] },

  {
    role_name: 'Quality Assurance Manager',
    aliases: ['Manager of Quality Assurance', 'QA Manager', 'Quality Manager',
              'Quality Assurance Lead', 'QA Lead'],
    department_names: ['Quality Assurance', 'Operations'],
    team_names: ['Quality Assurance', 'Product']
  },

  { role_name: 'Research Engineer', aliases: ['R&D Engineer'],
    department_names: %w[Engineering Science], team_names: ['Engineering'] },

  { role_name: 'Robotics Engineer',
    aliases: ['Robot optics', 'Robotics Specialist', 'Robotics Analyst', 'Robotics Consultant', 'Robotics Associate', 'Robotics Architect'], department_names: ['Engineering'], team_names: ['Engineering'] },

  { role_name: 'Salesforce Specialist', aliases: ['Salesforce Administrator', 'Salesforce Developer', 'Salesforce Consultant', 'Salesforce Analyst', 'Salesforce Associate'],
    department_names: %w[Sales IT], team_names: ['Sales'] },

  { role_name: 'Scrum Master', aliases: ['ScrumMaster', 'Agile Coach', 'Scrum Coach', 'Scrum Master', 'Agile Scrum Master', 'Scrum Product Owner'],
    department_names: ['Project Management'], team_names: ['Project Management'] },

  { role_name: 'Search Engineer',
    aliases: ['Search Engineer', 'Search Specialist', 'Search Analyst', 'Search Consultant', 'Search Associate', 'Search Architect', 'SEO engineer'], department_names: ['Engineering'], team_names: ['Engineering'] },

  { role_name: 'Security Engineer',
    aliases: ['Information Security Engineer', 'Cybersecurity Engineer', 'Security Analyst', 'Application Security Engineer'], department_names: %w[Engineering IT], team_names: ['IT'] },

  { role_name: 'Software Engineer',
    aliases: ['software architect', 'IT engineer', 'C++ Engineer', 'Software Developer', 'Programmer', 'Fullstack Engineer', 'full stack engineer', 'Backend Engineer', 'Frontend Engineer', 'fullstack developer', 'frontend developer', 'backend developer', 'full stack developer', 'mobile engineer', 'mobile software engineer', 'android engineer', 'ios engineer'], department_names: %w[Engineering IT], team_names: ['Engineering'] },

  { role_name: 'Solutions Engineer',
    aliases: ['customer success engineer', 'Pre-Sales Engineer', 'Sales Engineer', 'Technical Sales Engineer', 'Solutions Architect'], department_names: %w[Sales Engineering], team_names: %w[Sales Engineering] },

  { role_name: 'Systems Engineer', aliases: ['IT systems engineer', 'System Administrator', 'systems engineer', 'Embedded Software Engineer',
                                             'system engineer', 'firmware engineer'], department_names: %w[Engineering IT], team_names: ['Engineering'] },

  { role_name: 'Technical Support Specialist',
    aliases: ['technical engineer', 'application support engineer', 'it support specialist', 'helpdesk technician', 'it support technician', 'IT desktop support technician', 'Tech Support', 'helpdesk specialist', 'Helpdesk'], department_names: ['IT', 'Engineering', 'Customer Support'], team_names: ['Client Services', 'Technical Support'] },

  { role_name: 'Technical Writer', aliases: [],
    department_names: %w[Engineering IT], team_names: ['Engineering'] },

  { role_name: 'UI/UX Designer',
    aliases: ['user researcher', 'consultant product designer', 'product design', 'content production artist', 'Instructional Designer', 'User Experience Designer', 'Interface Designer', 'Product Designer', 'UX Manager', 'Graphic Designer', 'Product Designer', 'UI/UX Designer', 'Visual Designer', 'Web Designer', 'User Experience Designer', 'User Interface Designer', 'Product Designer'], department_names: ['Design', 'Product Management'], team_names: ['Product'] },

  { role_name: 'UX Researcher',
    aliases: ['User Researcher', 'User Experience Researcher', 'User Research Analyst', 'User Research Specialist', 'User Research Consultant', 'User Research Associate', 'User Research Manager'], department_names: ['Design', 'Product Management'], team_names: ['Product'] },
]

clinical_roles = [

  { role_name: 'Care Coordinator', aliases: ['health navigator'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Clinical Laboratory Scientist', aliases: ['Clinical Lab Technologist', 'Clinical Laboratory Associate', 'lab scientist'],
    department_names: ['Clinical Team'], team_names: ['Care Operations', 'Science'] },

  { role_name: 'Clinical Specialist', aliases: ['clinical scientist', 'Pharmacy Quality Improvement Specialist', 'Oncology Specialist', 'Clinical Analyst', 'Clinical Consultant', 'Clinical Research Specialist', 'Clinical Research Analyst', 'Clinical Research Consultant'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Clinical Support Specialist', aliases: ['Clinical Support Specialist', 'Clinical Support Analyst', 'Clinical Support Engineer', 'Clinical Support Consultant'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Clinical Trial Specialist', aliases: ['Clinical study manager', 'Clinical Trial manager', 'Clinical Trial Analyst', 'Clinical Trial Consultant'],
    department_names: ['Clinical Team', 'Science'], team_names: ['Care Operations'] },

  { role_name: 'Community Health Worker',
    aliases: ['CHW', 'Community Health Specialist', 'Community Health Advocate', 'Community Health Coordinator'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Dental Hygienist',
    aliases: ['Remote Dental Specialist', 'Tele-Dentist', 'Oral Health Expert'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Geneticist', aliases: ['Genetic Counselor', 'Genetic Specialist', 'Genetic Analyst', 'Genetic Consultant', 'Associate Statistical Geneticist'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'HEOR Specialist',
    aliases: ['Health Economics Outcomes Research Specialist', 'Health Economics Outcomes Research Analyst', 'Health Economics Outcomes Research Consultant', 'Health Economics Outcomes Research Manager'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Health Outcomes Liaison', aliases: ['clinical outcomes associate', 'Health Outcomes Specialist', 'Health Outcomes Analyst', 'Health Outcomes Consultant'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Healthcare Administrator',
    aliases: ['Medical Administrator', 'Health Services Manager', 'Remote Healthcare Manager'], department_names: ['Operations', 'Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Healthcare Analyst', aliases: ['Healthcare Data Analyst', 'Healthcare Business Analyst'],
    department_names: ['Data Science', 'Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Informaticist', aliases: ['Clinical Informatics Specialist', 'Clinical Informatics Analyst', 'Clinical Informatics Consultant', 'Clinical Informatics Manager'],
    department_names: ['Clinical Team', 'IT'], team_names: ['Care Operations', 'IT'] },

  { role_name: 'Insurance Specialist', aliases: ['billing analyst', 'Appeals Specialist', 'Prior Authorization Specialist', 'Pharmacy Prior Authorization Specialist', 'Pharmacy Insurance Claims Specialist', 'Insurance Verification Specialist', 'Insurance Analyst', 'Insurance Consultant', 'Insurance Manager'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Medical Assistant',
    aliases: ['Remote Medical Assistant', 'Telehealth Medical Assistant', 'Virtual Medical Assistant', 'Medical Assistant Specialist', 'Medical Assistant Analyst', 'Certified Medical Assistant'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Medical Coder', aliases: ['Remote Medical Coder', 'Telehealth Medical Coder', 'Virtual Medical Coder', 'Medical Coding Specialist', 'Medical Coding Analyst', 'Medical Coding Consultant'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Medical Device Specialist', aliases: ['Medical Device Operator', 'Medical Device Analyst', 'Medical Device Consultant'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Medical Education Specialist', aliases: ['Manager of Professional Education', 'Medical Education Manager', 'Medical Education Analyst', 'Medical Education Consultant', 'Medical Education Coordinator'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Medical Information Specialist', aliases: ['Medical Information Manager', 'Medical Information Analyst', 'Medical Information Consultant', 'manager of medical information'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Medical Science Liaison', aliases: ['science liaison', 'MSL', 'Medical Liaison', 'Medical Affairs Liaison', 'Medical Affairs Specialist', 'Medical Affairs Analyst', 'Medical Affairs Consultant'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Medical Writer', aliases: ['Scientific Writer', 'Medical Writer', 'Medical Writing Specialist', 'Medical Writing Analyst', 'Medical Writing Consultant'],
    department_names: ['Editorial'], team_names: ['Clinical Team'] },

  { role_name: 'Nurse',
    aliases: ['Licensed Vocational Nurse', 'Licensed Practical Nurse', 'Registered Nurse', 'RN', 'Remote Nurse', 'Telehealth Nurse', 'Virtual Care Nurse', 'Nurse Care Manager', 'Nurse Investigator'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Nurse Care Manager',
    aliases: ['Nurse Case Manager', 'Remote Nurse Care Manager', 'Telehealth Nurse Care Manager', 'Virtual Care Nurse Care Manager'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Nurse Practitioner',
    aliases: ['Psychiatric Mental Health Nurse Practitioner', 'Telehealth NP', 'Remote Nurse', 'Virtual Care NP', 'Licensed Nurse Practitioner'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Occupational Therapist',
    aliases: ['Remote OT', 'Teletherapy Specialist', 'Virtual OT'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Patient Care Specialist', aliases: ['patient care', 'patient care operations specialist', 'Patient Care Coordinator', 'Patient Care Analyst', 'Patient Care Consultant', 'Patient Support Specialist'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Pharmacist',
    aliases: ['Remote Pharmacist', 'Telepharmacy Specialist', 'Pharmacist Consultant', 'Clinical Pharmacist', 'Informatics Pharmacist'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Pharmacy Technician',
    aliases: ['Pharmacy Agent Trainee', 'Certified Pharmacy Technician', 'Remote Pharmacy Technician', 'Telepharmacy Technician', 'Pharmacy Tech', 'Pharmacy Specialist', 'Pharm Tech'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Phlebotomist', aliases: [], department_names: ['Clinical Team'],
    team_names: ['Care Operations'] },

  { role_name: 'Physical Therapist',
    aliases: ['Remote PT', 'Telehealth PT', 'Virtual Physical Therapist'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Physician',
    aliases: ['Independent Contractor Physician', 'Telemedicine Physician', 'Remote Doctor', 'Remote Physician', 'Virtual Care Physician', 'Palliative Care Physician'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Psychiatrist',
    aliases: ['Mental Health Counselor', 'Licensed Psychiatrist'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Psychologist',
    aliases: ['Licensed Psychologist', 'Licensed Clinical Psychologist', 'Remote Psychologist', 'Telepsychologist', 'Clinical Psychologist', 'Behavioral Health Psychologist'], department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Registered Dietitian', aliases: ['RD', 'Telehealth Dietitian', 'Remote Dietitian', 'Virtual Dietitian'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Remote Patient Monitoring Specialist', aliases: ['RPM Specialist', 'Remote Monitoring Specialist', 'Telehealth Specialist', 'Virtual Care Specialist'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Respiratory Therapist', aliases: ['Remote Respiratory Therapist', 'Telehealth Respiratory Therapist', 'Virtual Respiratory Therapist'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Social Worker', aliases: ['acsw', 'LCSW', 'Licensed Clinical Social Worker', 'Remote Social Worker', 'Telehealth Social Worker', 'Virtual Social Worker'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Speech Therapist', aliases: ['Remote Speech Therapist', 'Telehealth Speech Therapist', 'Virtual Speech Therapist'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Telehealth Specialist', aliases: ['Remote Telehealth Specialist', 'Telemedicine Specialist', 'Virtual Care Specialist'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Therapist', aliases: ['Associate Therapist', 'Licensed Mental Health Therapist', 'Behavioral Health Therapist', 'Mental Health Therapist', 'Licensed Therapist', 'Remote Therapist', 'Independently Licensed Therapist', 'Remote Therapist', 'Telehealth Therapist', 'Virtual Therapist'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Veterinarian', aliases: ['Remote Veterinarian', 'Telehealth Veterinarian', 'Virtual Veterinarian'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Veterinary Technician', aliases: ['Remote Veterinary Technician', 'Telehealth Veterinary Technician', 'Virtual Veterinary Technician'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Wellness Coach', aliases: ['Remote Wellness Coach', 'Telehealth Wellness Coach', 'Virtual Wellness Coach'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },
]

c_level = [
  # -----------------  ASSOCIATE DIRECTOR -----------------

  { role_name: 'Associate Director of Business Development',
    aliases: ['Associate Business Development Director'], department_names: ['Sales', 'Business Development', 'Executive'], team_names: ['Sales', 'Business Development'] },

  { role_name: 'Associate Director of Data Science', aliases: ['Associate Data Science Director'],
    department_names: ['Data Science', 'Executive'], team_names: ['Data Science'] },

  { role_name: 'Associate Director of Engineering', aliases: ['Associate Engineering Director', 'Director of Release Management and Software Quality'],
    department_names: %w[Engineering Executive], team_names: ['Engineering'] },

  { role_name: 'Associate Director of Learning and Development', aliases: ['Associate Learning and Development Director'],
    department_names: ['Human Resources', 'Executive'], team_names: ['Human Resources'] },

  { role_name: 'Associate Director of Marketing', aliases: ['Associate Marketing Director', 'Associate Director of HCP Marketing'],
    department_names: %w[Marketing Executive], team_names: ['Marketing'] },

  { role_name: 'Associate Director of Medical Affairs', aliases: ['Associate Medical Affairs Director', 'associate medical director'],
    department_names: ['Clinical Team', 'Executive'], team_names: ['Care Operations'] },

  { role_name: 'Associate Director of Editorials', aliases: ['Associate Medical Writing Director', 'Associate Director of Medical Writing'],
    department_names: %w[Editorial Executive], team_names: ['Marketing'] },

  { role_name: 'Associate Director of Operations', aliases: ['Associate Operations Director'],
    department_names: %w[Operations Executive], team_names: ['Operations'] },

  { role_name: 'Associate Director of Product Management',
    aliases: ['Associate Product Management Director'], department_names: ['Product Management', 'Executive'], team_names: ['Product'] },

  { role_name: 'Associate Director of Quality',
    aliases: ['Associate Clinical Quality Assurance', 'Associate Director of Quality Assurance', 'Associate Director of Clinical Quality Assurance'], department_names: %w[Quality Executive], team_names: ['Quality Assurance'] },

  { role_name: 'Associate Director of Training', aliases: ['Associate Director of Commercial Field Trainer'],
    department_names: %w[Operations Executive], team_names: ['Operations'] },

  # -----------------  CHIEF -----------------

  { role_name: 'Chief Clinical Officer', aliases: ['CCO'], department_names: ['Clinical Team'],
    team_names: ['Care Operations'] },

  { role_name: 'Chief Compliance Officer', aliases: ['CCO'], department_names: ['Legal'],
    team_names: ['Legal'] },
  {
    role_name: 'Chief Data Officer', aliases: ['CDO', 'chief of data', 'chief of data science'], department_names: ['Data Science'],
    team_names: ['Data Science']
  },
  { role_name: 'Chief Executive Officer', aliases: ['CEO'], department_names: ['Executive'],
    team_names: ['Executive'] },
  { role_name: 'Chief Financial Officer', aliases: ['CFO'], department_names: ['Finance'],
    team_names: ['Finance'] },

  { role_name: 'Chief Information Security Officer', aliases: ['CISO'],
    department_names: %w[IT Engineering], team_names: ['IT'] },

  { role_name: 'Chief Marketing Officer', aliases: ['CMO'], department_names: ['Marketing'],
    team_names: ['Marketing'] },

  { role_name: 'Chief Medical Officer', aliases: ['CMO'], department_names: ['Clinical Team'],
    team_names: ['Care Operations'] },

  { role_name: 'Chief Operating Officer', aliases: ['COO', 'Chief operations officer'], department_names: ['Operations'],
    team_names: ['Operations'] },

  { role_name: 'Chief Product Officer', aliases: ['CPO'], department_names: ['Product Management'],
    team_names: ['Product'] },

  { role_name: 'Chief Revenue Officer', aliases: ['CRO'], department_names: ['Sales'],
    team_names: ['Sales'] },

  { role_name: 'Chief Staff Officer', aliases: ['COS', 'chief of human resources', 'chief of staff'], department_names: ['Executive', 'Human Resources'],
    team_names: ['Executive'] },

  { role_name: 'Chief Technology Officer', aliases: ['CTO'], department_names: ['Engineering'],
    team_names: ['Engineering'] },

  # -----------------  DIRECTOR -----------------

  { role_name: 'Director of Business', aliases: ['Regional Business Director', 'Director of Business Development', 'Business Development Director', 'Business Development & Strategic Alliances', 'Professional Services - Growth & Enterprise', 'Director of Business Development & Strategic Alliances'],
    department_names: ['Sales', 'Business Development'], team_names: ['Sales', 'Business Development'] },

  { role_name: 'Director of Communications', aliases: ['Communications Director'],
    department_names: ['Public Relations'], team_names: ['Public Relations'] },

  { role_name: 'Director of Data Science', aliases: ['Data Science Director', 'data officer', 'director of data integrations'],
    department_names: ['Data Science'], team_names: ['Data Science'] },

  { role_name: 'Director of Design', aliases: ['Creative director'],
    department_names: ['Design'], team_names: ['Design'] },

  { role_name: 'Director of Engineering', aliases: ['Engineering Director', 'director of software engineering'],
    department_names: ['Engineering'], team_names: ['Engineering'] },

  { role_name: 'Director of Environmental Health and Safety', aliases: ['Environmental Health and Safety Director', 'Director of Environmental of Health and Safety (EHS)'],
    department_names: ['Environmental Health and Safety'], team_names: ['Environmental Health and Safety'] },

  { role_name: 'Director of Finance and Accounting', aliases: ['Finance Director', 'Accounting Director'],
    department_names: %w[Finance Accounting], team_names: %w[Finance Accounting] },

  { role_name: 'Director of Information Technology', aliases: ['IT Director', 'Information Technology Director', 'director of it', 'director of information technology'],
    department_names: ['Information Technology', 'IT'], team_names: ['IT'] },

  { role_name: 'Director of Marketing', aliases: ['Marketing Director', 'director of market access', 'director hcp marketing'],
    department_names: ['Marketing'], team_names: ['Marketing'] },

  { role_name: 'Director of Medical Affairs', aliases: ['Medical Affairs Director', 'medical director'],
    department_names: ['Clinical Team'], team_names: ['Clinical Team'] },

  { role_name: 'Director of Operations', aliases: ['Operations Director'],
    department_names: ['Operations'], team_names: ['Operations'] },

  { role_name: 'Director of Pharmacy', aliases: ['Director of Pharmacovigilance', 'Director Global Safety and PV Operations', 'Pharmacy Director', 'Executive Director Drug Safety and Pharmacovigilance', 'Director of Pharmacy Operations', 'Director of Pharmacy Services'],
    department_names: ['Clinical Team'], team_names: ['Clinical Team'] },

  { role_name: 'Director of Product Management', aliases: ['Product Management Director', 'Director of Product'],
    department_names: ['Product Management'], team_names: ['Product'] },

  { role_name: 'Director of Quality', aliases: ['Clinical Quality Assurance', 'director of quality assurance'],
    department_names: ['Quality'], team_names: ['Quality Assurance'] },

  { role_name: 'Director of Regulatory Affairs', aliases: ['Regulatory Affairs Director'],
    department_names: ['Regulatory Affairs'], team_names: ['Regulatory Affairs'] },

  { role_name: 'Director of Sales', aliases: ['Sales Director', 'regional director', 'payer sales director'],
    department_names: ['Sales'], team_names: ['Sales'] },

  { role_name: 'Director of Staff', aliases: ['Staff Director', 'director of human resources', 'Director Payroll'],
    department_names: ['Human Resources'], team_names: ['Human Resources'] },

  { role_name: 'Director of Science', aliases: ['Director of Scientific Affairs', 'Science Director', 'director of protein therapeutics', 'Director of Fermentation Process Development and Scale',
                                                'Director of Analytical Chemistry'],
    department_names: ['Science'], team_names: ['Science'] },

  { role_name: 'Director of Training', aliases: ['Director Commercial Field Leadership Training', 'Training Director', 'Director of Training and Development', 'Director of Training and Education'],
    department_names: ['Operations'], team_names: ['Operations'] },

  # -----------------  HEAD -----------------

  { role_name: 'Head of Clinical', aliases: ['Clinical Head', 'Clinical Operations Lead', 'Clinical Operations Head', 'Head of Clinical Operations'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Head of Customer Success', aliases: ['Customer Success Lead'],
    department_names: ['Customer Support', 'Executive'], team_names: ['Client Services'] },

  { role_name: 'Head of DevOps', aliases: ['DevOps Lead'], department_names: %w[IT Engineering],
    team_names: %w[DevOps Executive] },

  { role_name: 'Head of Growth', aliases: ['Growth Lead'], department_names: %w[Marketing Product],
    team_names: ['Business Development', 'Marketing', 'Executive'] },

  { role_name: 'Head of Marketing', aliases: ['Marketing Lead', 'Head of Marketing and Communications', 'Head of Marketing and Growth', 'Head of Marketing and Sales', 'Head of Marketing and Strategy', 'Head of Marketing and Business Development', 'Head of B2B Marketing'],
    department_names: %w[Marketing Executive], team_names: ['Marketing'] },

  { role_name: 'Head of Operations', aliases: ['Operations Lead', 'Head of Business Operations', 'Head of Operations and Strategy', 'Head of Downstream Processing'],
    department_names: %w[Operations Executive], team_names: ['Operations'] },

  { role_name: 'Head of People', aliases: ['Head of HR', 'HR Lead'],
    department_names: ['Human Resources', 'Executive'], team_names: ['Human Resources'] },

  { role_name: 'Head of Public Relations',
    aliases: ['Head of PR', 'PR Lead', 'Head of Communications', 'Communications Lead', 'Head of Media Relations', 'Media Relations Lead', 'Head of Public Relations & Communications'], department_names: ['Public Relations', 'Executive'], team_names: ['Public Relations'] },

  { role_name: 'Head of Regulatory Affairs', aliases: ['Head of Legal', 'Regulatory Affairs Lead', 'Head of Global Regulatory Affairs'],
    department_names: %w[Legal Executive], team_names: ['Legal'] },

  { role_name: 'Head of Science', aliases: ['Head of Research', 'head of ai research', 'head of ai science', 'head of biology'],
    department_names: %w[Science Executive], team_names: ['Science'] },

  { role_name: 'Head of Technology', aliases: ['Head of CyberSecurity', 'Technology Lead', 'Head of Tech', 'Head of IT'],
    department_names: %w[Engineering IT Executive], team_names: ['Engineering'] },

  # -----------------  PRESIDENT -----------------

  { role_name: 'President of Engineering', aliases: ['President of Engineering'],
    department_names: ['Engineering'], team_names: ['Engineering'] },
  { role_name: 'President of Finance', aliases: ['President of Finance'],
    department_names: ['Finance'], team_names: ['Finance'] },
  { role_name: 'President of Marketing', aliases: ['President of Marketing'],
    department_names: ['Marketing'], team_names: ['Marketing'] },
  { role_name: 'President of Product', aliases: ['President of Product'],
    department_names: ['Product Management'], team_names: ['Product'] },
  { role_name: 'President of Sales', aliases: ['President of Sales'],
    department_names: ['Sales'], team_names: ['Sales'] },
  { role_name: 'President of Science', aliases: ['President of Research', 'president of ai research', 'president of ai science'],
    department_names: ['Science'], team_names: ['Science'] },

  # -----------------  VICE PRESIDENT -----------------

  { role_name: 'Vice President of Clinical Development', aliases: ['VP Clinical Development', 'Vice President of Clinical Research', 'VP Clinical Research', 'Vice President of Clinical Affairs', 'Vice President of Clinical Development Operations', 'VP Clinical Affairs'],
    department_names: ['Clinical Team'], team_names: ['Care Operations'] },

  { role_name: 'Vice President of Engineering', aliases: ['VP Engineering', 'VP of engineering'],
    department_names: ['Engineering'], team_names: ['Engineering'] },

  { role_name: 'Vice President of Finance',
    aliases: ['VP Financial Operations', 'Vice President, Analytics & Financial Operations', 'Vice President, Financial Planning & Analysis', 'VP Financial Planning & Analysis'],
    department_names: ['Finance'], team_names: ['Finance'] },

  { role_name: 'Vice President of Marketing', aliases: ['VP Marketing', 'Vice President - Marketing of CRM & Brand', 'VP of Market Access & Distribution'],
    department_names: ['Marketing'], team_names: ['Marketing'] },

  { role_name: 'Vice President of Product', aliases: ['VP Product'],
    department_names: ['Product Management'], team_names: ['Product'] },

  { role_name: 'Vice President of Quality', aliases: ['VP of Regulatory and Quality', 'VP Quality', 'Vice President of Quality Assurance', 'VP Quality Assurance'],
    department_names: ['Quality'], team_names: ['Quality Assurance'] },

  { role_name: 'Vice President of Sales', aliases: ['VP Sales', 'VP of Franchise Portfolio Management', 'Vice President of Sales (Oncology)'],
    department_names: ['Sales'], team_names: ['Sales'] },

  { role_name: 'Vice President of Science', aliases: ['VP Research', 'VP AI Research', 'VP AI Science', 'vp of ai research',
                                                      'vice president of ai research', 'vice president of ai science', 'vice president of research', 'Vice President of Product and Portfolio Strategy of Genetic Diseases'],
    department_names: ['Science'], team_names: ['Science'] }
]

all_job_roles = job_roles + science_roles + technical_roles + clinical_roles + c_level

seeded_count = 0
updated_count = 0
existing_count = 0

all_job_roles.each do |role|
  role_record = JobRole.find_or_initialize_by(role_name: role[:role_name])

  changes_made = false

  if role_record.aliases.sort != role[:aliases].sort
    role_record.aliases = role[:aliases]
    changes_made = true
  end

  if role_record.new_record?
    role_record.save!
    seeded_count += 1
    puts "Created new job role: #{role_record.role_name}."
  else
    role_record.save! if changes_made
    updated_count += 1 if changes_made
    existing_count += 1 unless changes_made
    puts changes_made ? "Updated job role: #{role_record.role_name}." : "No changes for job role: #{role_record.role_name}."
  end

  role[:department_names].each do |dept_name|
    department = Department.find_by('LOWER(dept_name) = ? OR LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                                    dept_name.downcase, dept_name.downcase)
    if department
      unless role_record.departments.include?(department)
        role_record.departments << department
        puts "Associated #{role_record.role_name} with department #{dept_name}."
      end
    else
      puts "#{RED}Error: Department #{dept_name} not found for role #{role_record.role_name}.#{RESET}"
    end
  end

  role[:team_names].each do |team_name|
    team = Team.find_by('LOWER(team_name) = ? OR LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                        team_name.downcase, team_name.downcase)
    if team
      unless role_record.teams.include?(team)
        role_record.teams << team
        puts "Associated #{role_record.role_name} with team #{team_name}."
      end
    else
      puts "#{RED}Error: Team #{team_name} not found for role #{role_record.role_name}.#{RESET}"
    end
  end
rescue StandardError => e
  puts "Error seeding job role: #{role[:role_name]} - #{e.message}"
end

total_roles_after = JobRole.count
puts "*******Seeded #{seeded_count} new job roles. Updated #{updated_count} roles. #{existing_count} roles already existed. Total job roles in the table: #{total_roles_after}."
