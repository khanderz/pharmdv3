# frozen_string_literal: true

module Utils
  class TitleCleaner
    def self.clean_title(title)
      # puts "#{BLUE} Cleaning title: #{title} #{RESET}"
      return { cleaned_title: '', modified_title: '' } if title.nil?

      original_title = title.strip
      cleaned_title = title.strip.gsub(/\(.*?\)/i, '').gsub(/[^a-zA-Z0-9\s]/, '')

      employment_terms = ['Contract', 'Full Time', 'Part Time', 'Temporary', 'Intern', 'Per Diem',
                          'Locum', 'Locum Tenens']
      seniority_terms = ['Senior', 'Junior', 'Lead', 'Principal', 'sr', 'jr', 'sr.',
                         'jr.', 'SVP']

      employment_pattern = /\b(#{employment_terms.join('|')})\b/i
      seniority_pattern = /\b(#{seniority_terms.join('|')})\.?\b/i

      cleaned_title.gsub!(employment_pattern, '')
      cleaned_title.gsub!(seniority_pattern, '')

      # puts "cleaned_title after removing employment and seniority: #{cleaned_title}"

      parts = cleaned_title.split(%r{[-,/]}i).map(&:strip)

      # puts "parts: #{parts}"

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

      # puts "cleaned_title after finding meaningful phrases: #{cleaned_title}"

      cleaned_title ||= parts.reject(&:empty?).min_by(&:length)

      # puts "cleaned_title after finding min_by: #{cleaned_title}"

      if cleaned_title && !cleaned_title.downcase.include?('chief of staff')
        cleaned_title.gsub!(/\bstaff\b/i, '')
      end

      # puts "cleaned_title after removing staff: #{cleaned_title}"

      locations = Location.all.pluck(:name).compact.map { |loc| Regexp.escape(loc) }
      location_pattern = /\b(#{locations.join('|')})\b/i
      cleaned_title.gsub!(location_pattern, '') if cleaned_title

      # puts "cleaned_title after removing locations: #{cleaned_title}"

      roman_numerals_pattern = /\b(I{1,3})\b/
      cleaned_title.gsub!(roman_numerals_pattern, '') if cleaned_title

      # puts "cleaned_title after removing roman numerals: #{cleaned_title}"

      meaningful_phrases.each do |phrase|
        next if cleaned_title.downcase.include?(phrase.downcase)

        if original_title.downcase.include?(phrase.downcase)
          cleaned_title = "#{cleaned_title.strip} #{phrase}".strip
        end
      end

      # puts "cleaned_title after adding meaningful phrases: #{cleaned_title}"

      cleaned_title = cleaned_title.strip.squeeze(' ') if cleaned_title
      cleaned_title.gsub!(/^\.+|\.+$/, '') if cleaned_title

      # puts "cleaned_title after removing leading/trailing dots: #{cleaned_title}"

      modified_title = original_title.gsub(seniority_pattern, '').gsub(/,/,
                                                                       ' of').strip.squeeze(' ')

      # puts "modified_title after removing seniority: #{modified_title}"
      modified_title.gsub!(/^\.+|\.+$/, '')
      # puts "modified_title after removing leading/trailing dots: #{modified_title}"
      {
        cleaned_title: cleaned_title.strip,
        modified_title: modified_title.strip
      }
    end
  end
end
