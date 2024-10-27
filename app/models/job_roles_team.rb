# frozen_string_literal: true

class JobRolesTeam < ApplicationRecord
  belongs_to :job_role
  belongs_to :team
end
