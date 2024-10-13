class JobRole < ApplicationRecord
    has_many :job_posts
    
    # Storing additional role details in JSON format
    store :additional_attributes, accessors: [:job_function, :clearance_level], coder: JSON
    # roles with similar names
    serialize :aliases, JSON # Add JSON as the coder
    validates :role_name, presence: true, uniqueness: true
  end