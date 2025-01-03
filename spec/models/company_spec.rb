# frozen_string_literal: true

# spec/models/company_spec.rb
require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:ats_type) { create(:ats_type) }
  let(:company_size) { create(:company_size) }
  let(:funding_type) { create(:funding_type) }
  let(:company) { create(:company, ats_type: ats_type) }
  let(:location) { create(:location) }
  let(:healthcare_domain) { create(:healthcare_domain) }
  let(:company_specialty) { create(:company_specialty) }

  it 'creates a CompanyDomain record' do
    company = create(:company)
    healthcare_domain = create(:healthcare_domain)
  
    company_domain = CompanyDomain.create(company: company, healthcare_domain: healthcare_domain)
    expect(company_domain).to be_valid
    expect(company_domain.persisted?).to be(true)
  end

  describe 'associations' do
    it { should belong_to(:ats_type) }
    it { should belong_to(:company_size).optional }
    it { should belong_to(:funding_type).optional }
    it { should belong_to(:company_type).optional }

    it { should have_many(:company_locations).dependent(:destroy) }
    it { should have_many(:locations).through(:company_locations) }
    it { should have_many(:company_domains).dependent(:destroy) }
    it { should have_many(:healthcare_domains).through(:company_domains) }
    it { should have_many(:company_specializations).dependent(:destroy) }
    it { should have_many(:company_specialties).through(:company_specializations) }
    it { should have_many(:adjudications).dependent(:destroy) }
    it { should have_many(:job_posts).dependent(:destroy) }

    it 'destroys associated company_locations when destroyed' do
      company = create(:company, locations: [location])
      expect { company.destroy }.to change { CompanyLocation.count }.by(-1)
    end

    it 'has many locations through company_locations' do
      company = create(:company)
      location = create(:location)
      company.locations << location
      expect(company.locations).to include(location)
    end
  end

  describe 'validations' do
    before do
      create(:company, company_name: 'Unique Name', ats_type: ats_type)
    end

    it 'validates uniqueness of company_name' do
      duplicate = build(:company, company_name: 'Unique Name')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:company_name]).to include('has already been taken')
    end

    it 'validates uniqueness of linkedin_url, allowing blank values' do
      create(:company, linkedin_url: nil)
      duplicate = build(:company, linkedin_url: nil, ats_type: ats_type)
      expect(duplicate).to be_valid

      create(:company, linkedin_url: 'https://linkedin.com/test')
      duplicate_case = build(:company, linkedin_url: 'https://linkedin.com/test')
      expect(duplicate_case).not_to be_valid
      expect(duplicate_case.errors[:linkedin_url]).to include('has already been taken')
    end

    it 'validates uniqueness of company_url, allowing blank values' do
      create(:company, company_url: nil, ats_type: ats_type)
      duplicate = build(:company, company_url: nil, ats_type: ats_type)
      expect(duplicate).to be_valid

      create(:company, company_url: 'https://example.com', ats_type: ats_type)
      duplicate_case = build(:company, company_url: 'https://example.com', ats_type: ats_type)
      expect(duplicate_case).not_to be_valid
      expect(duplicate_case.errors[:company_url]).to include('has already been taken')
    end
  end

  describe 'instance methods' do
    let!(:active_job) { create(:job_post, company: company, job_active: true) }
    let!(:inactive_job) { create(:job_post, company: company, job_active: false) }

    it '#active_jobs' do
      expect(company.active_jobs).to include(active_job)
      expect(company.active_jobs).not_to include(inactive_job)
    end

    it '#inactive_jobs' do
      expect(company.inactive_jobs).to include(inactive_job)
      expect(company.inactive_jobs).not_to include(active_job)
    end
  end

  describe 'class methods' do
    it '.seed_existing_companies' do
      healthcare_domain = create(:healthcare_domain, key: 'domain_key_2')

      row = {
        'company_name' => 'Test Company',
        'operating_status' => 'true',
        'linkedin_url' => 'https://linkedin.com/test',
        'year_founded' => '2000',
        'company_tagline' => 'Innovating the Future',
        'is_completely_remote' => true,
        'healthcare_domain' => healthcare_domain.key,
        'company_specialty' => company_specialty.key
      }
      ats_type = create(:ats_type)
      locations = [location]

      company = create(:company, ats_type: ats_type, create_domains: false)
      changes_made = described_class.seed_existing_companies(company, row, ats_type, locations)

      company.reload

      expect(changes_made).to be_truthy
      expect(company.operating_status).to be_truthy
      expect(company.linkedin_url).to eq('https://linkedin.com/test')
      expect(company.year_founded).to eq(2000)
      expect(company.company_tagline).to eq('Innovating the Future')
      expect(company.is_completely_remote).to eq(true)

    #   puts "company #{company.inspect}"
      company_domains = CompanyDomain.where(company_id: company.id)
      puts "company_domains: #{company_domains.inspect}"
      puts "CompanyDomains in DB: #{CompanyDomain.where(company_id: company.id).pluck(:id, :healthcare_domain_id)}"

      expect(company_domains.count).to eq(1)
      expect(company_domains.first.healthcare_domain_id).to eq(healthcare_domain.id)

      expect(company.healthcare_domains).to include(healthcare_domain)
    end
  end
end
