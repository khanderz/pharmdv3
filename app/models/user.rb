class User < ApplicationRecord
  has_many :saved_job_posts, dependent: :destroy
  has_many :saved_companies, dependent: :destroy

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  has_many :user_resources, dependent: :destroy
  has_many :resources, through: :user_resources

  has_many :user_healthcare_domains, dependent: :destroy
  has_many :healthcare_domains, through: :user_healthcare_domains

  has_many :user_company_specialties, dependent: :destroy
  has_many :company_specialties, through: :user_company_specialties

  has_secure_password

  def self.authenticate(email, password)
    user = find_by(email: email)
    user&.authenticate(password) ? user : nil
  end

  def generate_reset_token
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (reset_password_sent_at + 2.hours) > Time.now.utc
  end
end
