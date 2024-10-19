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
  
        # Final clean up of extra spaces and return the cleaned title
        cleaned_title.strip
      end
    end
  end
  