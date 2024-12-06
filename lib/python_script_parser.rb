# lib/python_script_parser.rb

module PythonScriptParser
    def self.parse_output(output)
      json_output = output.lines.find { |line| line.strip.start_with?('{') && line.strip.end_with?('}') }
      raise 'No valid JSON output found' unless json_output
  
      JSON.parse(json_output)
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse Python script output: #{e.message}")
      raise
    end
  end
  