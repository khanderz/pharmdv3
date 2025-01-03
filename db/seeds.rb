# frozen_string_literal: true

# Load static seed data in the specified order

# 1. Healthcare domains
load File.join(Rails.root, 'db', 'seeds', 'static', 'healthcare_domains.rb')

# 2. Company specialties (depends on healthcare domains)
load File.join(Rails.root, 'db', 'seeds', 'static', 'company_specialties.rb')

# 3. ATS types
load File.join(Rails.root, 'db', 'seeds', 'static', 'ats_types.rb')

# 4. Company sizes
load File.join(Rails.root, 'db', 'seeds', 'static', 'company_sizes.rb')

# 5. Locations
load File.join(Rails.root, 'db', 'seeds', 'static', 'locations.rb')

# 8. Funding types
load File.join(Rails.root, 'db', 'seeds', 'static', 'funding_types.rb')

# 8b. Company types
load File.join(Rails.root, 'db', 'seeds', 'static', 'company_types.rb')

# 9. Companies
load File.join(Rails.root, 'db', 'seeds', 'companies.rb')

# 10. Departments
load File.join(Rails.root, 'db', 'seeds', 'static', 'departments.rb')

# 11. Teams
load File.join(Rails.root, 'db', 'seeds', 'static', 'teams.rb')

# 12. Job roles (depends on departments and teams)
load File.join(Rails.root, 'db', 'seeds', 'static', 'job_roles.rb')

#  Benefits
load File.join(Rails.root, 'db', 'seeds', 'static', 'benefits.rb')

#  Credentials
load File.join(Rails.root, 'db', 'seeds', 'static', 'credentials.rb')

# Educations
load File.join(Rails.root, 'db', 'seeds', 'static', 'educations.rb')

# Experiences
load File.join(Rails.root, 'db', 'seeds', 'static', 'experiences.rb')

# Skills
load File.join(Rails.root, 'db', 'seeds', 'static', 'skills.rb')

# 13. Job commitments
load File.join(Rails.root, 'db', 'seeds', 'static', 'job_commitments.rb')

# 14. Job settings
load File.join(Rails.root, 'db', 'seeds', 'static', 'job_settings.rb')

# 15. Job salary currencies
load File.join(Rails.root, 'db', 'seeds', 'static', 'currency.rb')

# 16. Job salary intervals
load File.join(Rails.root, 'db', 'seeds', 'static', 'salary_intervals.rb')

# 17. Job Seniority Levels
load File.join(Rails.root, 'db', 'seeds', 'static', 'job_seniorities.rb')

# 18. Job posts (depends on companies, job roles, etc.)
load File.join(Rails.root, 'db', 'seeds', 'job_posts.rb')

# Membership types
load File.join(Rails.root, 'db', 'seeds', 'static', 'membership_types.rb')

puts '*************Seeding completed**************'
