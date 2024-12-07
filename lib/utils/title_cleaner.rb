# frozen_string_literal: true

# lib/utils/title_cleaner.rb
module Utils
  class TitleCleaner
    def self.clean_title(title)
      return '' if title.nil?

      cleaned_title = title.gsub(/\(.*?\)/, '')
                           .split(/[-,]/).first.strip

      # Get state names and codes from the database, excluding nil values
      states = State.all.pluck(:state_code, :state_name).flatten.compact.map do |s|
        Regexp.escape(s)
      end
      state_pattern = /\b(#{states.join('|')})\b/i # Create a pattern with state codes and names

      cleaned_title.gsub!(state_pattern, '')

      # Get country names from the database, excluding nil values
      countries = Country.all.pluck(:country_name).compact.map { |c| Regexp.escape(c) }
      country_pattern = /\b(#{countries.join('|')})\b/i # Create a pattern with country names

      cleaned_title.gsub!(country_pattern, '')

      # List of common employment terms to remove
      employment_terms = ['Contract', 'Full Time', 'Part Time', 'Temporary', 'Intern', 'Per Diem', 'Locum',
                          'Locum Tenens']

      employment_pattern = /\b(#{employment_terms.join('|')})\b/i
      cleaned_title.gsub!(employment_pattern, '')

      # List of seniority or job level terms to remove
      seniority_terms = [
        'Senior',
        'Sr.',
        'sr',
        'I',
        'II',
        'III',
        'Lead',
        'Staff',
        'junior',
        'jr.',
        'midlevel',
        'mid-level',
        'mid level',
        'entry level',
        'entry-level',
        'principal',
        'local',
        'associate',
        'collections',
        'team',
        'supervisor',
        'team leader',
        'Mid-Market'
      ]

      seniority_pattern = /\b(#{seniority_terms.join('|')})\b/i
      cleaned_title.gsub!(seniority_pattern, '')

      cleaned_title.strip
    end
  end
end
