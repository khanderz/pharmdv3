class JobRole < ApplicationRecord
    # has_many :tech_skills
    # has_many :soft_skills
    # has_many :job_posts
    has_many :tags, through: :job_post
  
    # Storing additional role details in JSON format
    serialize :additional_attributes, JSON # Rails < 5
    # or
    store :additional_attributes, accessors: [:job_function, :clearance_level], coder: JSON
  
  
  
  
  # roles with similar names
    serialize :aliases, Array # Assuming aliases are stored as an array
  
    validates :role_name, presence: true, uniqueness: true
  
  end