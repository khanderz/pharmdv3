# app/services/python_job_description_service.rb
require 'open3'
require 'python_script_parser'

class PythonJobDescriptionService
  SCRIPT_PATH = Rails.root.join('app/python/ai_processing/job_description_extraction/train_job_description_extraction.py')

  def self.extract_job_description_entities(job_description)
    command = "python3 #{SCRIPT_PATH}"
    input = { text: job_description }.to_json
    stdout, stderr, status = Open3.capture3(command, stdin_data: Base64.encode64(input))

    if status.success?
      PythonScriptParser.parse_output(stdout)
    else
      Rails.logger.error("Python script failed with error: #{stderr}")
      raise "Python script execution failed"
    end
  end
end
