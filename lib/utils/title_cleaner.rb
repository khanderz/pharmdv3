# frozen_string_literal: true

# lib/utils/title_cleaner.rb
module Utils
  class TitleCleaner
    def self.clean_title(title)
      return '' if title.nil?

      cleaned_title = title.gsub(/\(.*?\)/, '')
                           .split(/[-,]/).first.strip

      states = State.all.pluck(:state_code, :state_name).flatten.compact.map do |s|
        Regexp.escape(s)
      end
      state_pattern = /\b(#{states.join('|')})\b/i  

      cleaned_title.gsub!(state_pattern, '')

      countries = Country.all.pluck(:country_name).compact.map { |c| Regexp.escape(c) }
      country_pattern = /\b(#{countries.join('|')})\b/i 

      cleaned_title.gsub!(country_pattern, '')

      # List of common employment terms to remove
      employment_terms = ['Contract', 'Full Time', 'Part Time', 'Temporary', 'Intern', 'Per Diem', 'Locum',
                          'Locum Tenens']

      employment_pattern = /\b(#{employment_terms.join('|')})\b/i
      cleaned_title.gsub!(employment_pattern, '')

      cleaned_title.strip
    end
  end
end
