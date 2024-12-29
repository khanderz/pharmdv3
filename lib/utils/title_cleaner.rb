# frozen_string_literal: true

module Utils
  class TitleCleaner
    def self.clean_title(title)
      return '' if title.nil?

      original_title = title.strip
      cleaned_title = title.gsub(/\(.*?\)/i, '')

      employment_terms = ['Contract', 'Full Time', 'Part Time', 'Temporary', 'Intern', 'Per Diem',
                          'Locum', 'Locum Tenens']
      seniority_terms = ['Senior', 'Junior', 'Lead', 'Principal', 'sr', 'jr', 'sr.',
                         'jr.', 'staff', 'SVP']

      employment_pattern = /\b(#{employment_terms.join('|')})\b/i
      seniority_pattern = /\b(#{seniority_terms.join('|')})\b/i

      cleaned_title.gsub!(employment_pattern, '')
      cleaned_title.gsub!(seniority_pattern, '')

      parts = cleaned_title.split(%r{[-,/]}i).map(&:strip)

      meaningful_phrases = [
        'Chief of Staff',
        'Business Development & Strategic Alliances',
        'Materials Management',
        'External Engagement Manager',
        'Compliance Manager',
        'Environmental Health and Safety',
        'Regulatory and Quality',
        'Machine Learning',
        'Scientist'
      ]

      cleaned_title = parts.find do |part|
        meaningful_phrases.any? { |phrase| part.downcase.include?(phrase.downcase) }
      end

      cleaned_title ||= parts.first

      locations = Location.all.pluck(:name).compact.map { |loc| Regexp.escape(loc) }
      location_pattern = /\b(#{locations.join('|')})\b/i
      cleaned_title.gsub!(location_pattern, '')

      roman_numerals_pattern = /\b(I{1,3})\b/
      cleaned_title.gsub!(roman_numerals_pattern, '')

      if original_title.downcase.include?('machine learning')
        cleaned_title = "#{cleaned_title.strip} Machine Learning".strip
      end

      cleaned_title = cleaned_title.strip.squeeze(' ')

      modified_title = original_title.gsub(seniority_pattern, '').gsub(/,/,
                                                                       ' of').strip.squeeze(' ')

      {
        cleaned_title: cleaned_title,
        modified_title: modified_title
      }
    end
  end
end
