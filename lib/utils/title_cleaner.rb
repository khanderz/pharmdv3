# lib/utils/title_cleaner.rb
module Utils
  class TitleCleaner
    # Universal method for cleaning job titles or team names
    def self.clean_title(title)
      cleaned_title = title.gsub(/\(.*?\)/, '') # Remove content in parentheses
                           .split(/[-,]/).first.strip # Split by dash or comma and get the first part

      # Get state names and codes from the database
      states = State.all.pluck(:state_code, :state_name).flatten.map { |s| Regexp.escape(s) }
      state_pattern = /\b(#{states.join('|')})\b/i # Create a pattern with state codes and names

      # Remove state names or codes from the title
      cleaned_title.gsub!(state_pattern, '')

      # List of common employment terms to remove
      employment_terms = ['Contract', 'Full Time', 'Part Time', 'Temporary', 'Intern', 'Per Diem', 'Locum', 'Locum Tenens']

      # Create a pattern with employment terms
      employment_pattern = /\b(#{employment_terms.join('|')})\b/i

      # Remove employment terms from the title
      cleaned_title.gsub!(employment_pattern, '')

      # List of seniority or job level terms to remove
      seniority_terms = ['Senior', 'Sr.', 'I', 'II', 'III', 'Lead', 'Staff', 'junior', 'jr.', 'midlevel', 'mid-level', 'mid level', 'entry level', 'entry-level', 'principal', 'local']

      # Create a pattern for seniority or job level terms
      seniority_pattern = /\b(#{seniority_terms.join('|')})\b/i

      # Remove seniority or job level terms from the title
      cleaned_title.gsub!(seniority_pattern, '')

      # Final clean up of extra spaces and return the cleaned title
      cleaned_title.strip
    end
  end
end
