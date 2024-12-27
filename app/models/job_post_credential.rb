# frozen_string_literal: true

class JobPostCredential < ApplicationRecord
  belongs_to :job_post
  belongs_to :credential, optional: true
end