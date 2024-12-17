# app/services/train_models_service.rb

# frozen_string_literal: true

require 'open3'

GREEN = "\033[32m"
BLUE = "\033[34m"
RESET = "\033[0m"
ORANGE = "\033[38;2;255;165;0m"
RED = "\033[31m"

class TrainModelsService
  PYTHON_SCRIPT_PATH = Rails.root.join('app', 'python', 'ai_processing', 'train_all_models.py').to_s.freeze

  def self.call
    new.call
  end

  def call
    puts "#{BLUE}Starting model training process...#{RESET}"

    Open3.popen3("python3 #{PYTHON_SCRIPT_PATH}") do |_stdin, stdout, stderr, wait_thr|
      Thread.new do
        stdout.each_line { |line| puts "#{GREEN}#{line.chomp}#{RESET}" }
      end

      Thread.new do
        stderr.each_line { |line| puts "#{RED}#{line.chomp}#{RESET}" }
      end

      exit_status = wait_thr.value

      if exit_status.success?
        puts "#{BLUE}Model training completed successfully.#{RESET}"
      else
        puts "#{RED}Error occurred during model training.#{RESET}"
        raise StandardError, "#{RED}Model training failed. Check Python script output for errors.#{RESET}"
      end
    end
  end
end
