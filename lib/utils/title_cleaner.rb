module Utils
  class TitleCleaner
    def self.clean_title(title)
      return '' if title.nil?

      original_title = title.strip

      cleaned_title = title.gsub(/\(.*?\)/i, '').split(/[-,]/i).first.strip

      locations = Location.all.pluck(:name).compact.map { |loc| Regexp.escape(loc) }
      location_pattern = /\b(#{locations.join('|')})\b/i
      cleaned_title.gsub!(location_pattern, '')

      employment_terms = ['Contract', 'Full Time', 'Part Time', 'Temporary', 'Intern', 'Per Diem', 'Locum', 'Locum Tenens']
      seniority_terms = ['Senior', 'Junior', 'Lead', 'Principal', 'Manager', 'sr', 'jr', 'sr.', 'jr.', 'staff']

      employment_pattern = /\b(#{employment_terms.join('|')})\b/i
      seniority_pattern = /\b(#{seniority_terms.join('|')})\b/i

      cleaned_title.gsub!(employment_pattern, '')
      cleaned_title.gsub!(seniority_pattern, '')

      cleaned_title.gsub!(/\b(Chief|VP|Director|Officer|Manager|Engineer|Analyst)\b/i, '\1')

      roman_numerals_pattern = /\b(I{1,3})\b/
      cleaned_title.gsub!(roman_numerals_pattern, '')

      modified_title = original_title.gsub(seniority_pattern, '').gsub(/,/, ' of').strip

      {
        cleaned_title: cleaned_title.strip,
        modified_title: modified_title.strip
      }
    end
  end
end
