# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  has_many :job_roles_departments
  has_many :job_roles, through: :job_roles_departments

  validates :dept_name, presence: true, uniqueness: true

  KEYWORD_MAPPINGS = {
    'Business Development' => ['germany', 'japan', 'united kingdom'],
    'Clinical Team' => %w[clinical preclinical provider healthcare veterinary
                          pharmacy therapeutics clinicians dmpk therapy eeg
                          therapies aba ipa therapy nursing hematology genetic],
    'Customer Support' => ['customer'],
    'Data Science' => %w[data bioinformatics "causal inference" 'predictive modeling'],
    'Design' => ['creative'],
    'Editorial' => ['social'],
    'Engineering' => %w[engineering automation bioengineering infrastructure],
    'Executive' => %w[headquarters cmo cso],
    'Finance' => ['billing'],
    'Human Resources' => %w[talent cphr],
    'Internship' => %w[intern internships],
    'IT' => ['technology', 'artificial intelligence', 'security', 'it', 'cto'],
    'Legal' => %w[compliance policy],
    'Marketing' => %w[marketing commercial],
    'Operations' => %w[operations risk],
    'Product Management' => ['products'],
    'Public Relations' => ['community'],
    'Quality' => %w[quality qc],
    'Sales' => %w[sales retail "indirect channels"],
    'Science' => %w[science genomics clia cmc fusion microbiology chemistry epigenetic causal],
    'Supply Chain' => %w[packaging warehousing facilities manufacturing production]
  }.freeze

  def self.clean_department_name(department_name)
    puts "Cleaning department name: #{department_name}"
    cleaned_name = department_name.gsub(/\d+|\(.*?\)/, '').strip
    puts "Cleaned department name: #{cleaned_name}"

    parts = cleaned_name.split('-').map(&:strip)
    cleaned_name = parts.join(' ').strip unless parts.empty?
    puts "Cleaned name after joining parts: #{cleaned_name}"

    if parts.size > 1
      candidate_name = parts.join(' ')
      puts "Candidate name if parts > 1: #{candidate_name}"
      return candidate_name if exists?(dept_name: candidate_name)
    end
    cleaned_name
  end

  def self.find_department(department_name, job_url = nil)
    cleaned_name = clean_department_name(department_name)
    normalized_name = cleaned_name.downcase
    parts = cleaned_name.split(' ')

    puts "Finding department: #{cleaned_name}"
    puts "Normalized name: #{normalized_name}"

    KEYWORD_MAPPINGS.each do |mapped_name, keywords|
      keyword_regex = Regexp.union(keywords.map { |keyword| /\b#{Regexp.escape(keyword)}\b/i })
      next unless normalized_name.match?(keyword_regex)

      department = find_by(dept_name: mapped_name)
      puts "#{ORANGE}Normalized name match to one of #{keywords}, matching department to #{mapped_name}#{RESET}"
      return department if department
    end

    department = where('LOWER(dept_name) = ?', normalized_name)
                 .or(where('aliases::text ILIKE ?', "%#{normalized_name}%"))
                 .first

    unless department && parts.size > 1
      parts.each do |part|
        partial_name = part.downcase

        puts "Checking for partial name: #{partial_name}"
        department = where('LOWER(dept_name) = ?', partial_name)
                     .or(where('aliases::text ILIKE ?', "%#{partial_name}%"))
                     .first
        if department
          puts "#{GREEN}Match found for partial name: #{part}#{RESET}"
          return department
        end
      end
    end

    unless department

      new_department = Department.create!(
        dept_name: cleaned_name.titleize,
        error_details: "Department #{department_name} for #{job_url} not found in existing records",
        resolved: false
      )
      puts "#{RED}Logging error for department #{department_name} with cleaned name #{cleaned_name} for #{job_url} not found in existing records#{RESET}"
      Adjudication.log_error(
        adjudicatable_type: 'Department',
        adjudicatable_id: new_department.id,
        error_details: "Department #{department_name} for #{job_url} not found in existing records"
      )

    end
    puts "#{GREEN}Department found: #{department&.dept_name}#{RESET}"

    department
  end
end
