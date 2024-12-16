# frozen_string_literal: true

class Skill < ApplicationRecord
  def self.find_or_create_skill(skill_param, job_post)
    skill_param = skill_param.downcase

    skill = where('LOWER(skill_name) = ?', skill_param)
            .or(where('LOWER(skill_code) = ?', skill_param))
            .or(where('aliases @> ?', "{#{skill_param}}"))
            .first

    if skill
      puts "#{GREEN}Skill #{skill_param} found in existing records.#{RESET}"
    else
      error_details = "Skill #{skill_param} for #{job_post} not found in existing records"

      skill = create!(
        skill_name: skill_param,
        error_details: error_details,
        resolved: false
      )

      Adjudication.log_error(
        adjudicatable_type: 'Skill',
        adjudicatable_id: skill.id,
        error_details: error_details
      )
    end

    skill
  end
end
