# frozen_string_literal: true

class Benefit < ApplicationRecord
    def self.find_or_create_benefit(benefit_name, company, job_post = nil)
      return nil if benefit_name.nil? || benefit_name.strip.empty?
  
      normalized_benefit_name = benefit_name.strip.downcase
  
      benefit = Benefit.all.find do |b|
        b.benefit_name.downcase.include?(normalized_benefit_name) ||
          b.aliases.any? { |alias_name| alias_name.downcase.include?(normalized_benefit_name) }
      end
  
      unless benefit
        puts "#{RED}Benefit #{benefit_name} not found for #{job_post} or company : #{company}.#{RESET}"
        error_details = "Benefit #{benefit_name} for #{job_post} or company : #{company} not found in existing records"
        adj_type = job_post ? 'Benefit' : 'Company'
  
        new_benefit = Benefit.create!(
          benefit_name: benefit_name,
          error_details: error_details,
          resolved: false
        )
  
        Adjudication.log_error(
          adjudicatable_type: adj_type,
          adjudicatable_id: new_benefit.id,
          error_details: error_details
        )
      end
  
      benefit
    end
  end