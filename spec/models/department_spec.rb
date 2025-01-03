# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Department, type: :model do
  describe '.clean_department_name' do
    it 'removes numbers and parentheses from the department name' do
      result = Department.clean_department_name('Customer Service (403)')
      expect(result).to eq('Customer Service')
    end

    it 'removes hyphen prefixes and trims spaces' do
      result = Department.clean_department_name('123 - Customer Service')
      expect(result).to eq('Customer Service')
    end

    it 'handles names with multiple parts' do
      result = Department.clean_department_name('Clinical - Preclinical')
      expect(result).to eq('Clinical Preclinical')
    end
  end

  describe '.find_department' do
    let!(:sales) { create(:department, dept_name: 'Sales') }
    let!(:executive) { create(:department, dept_name: 'Executive') }
    let!(:clinical_team) { create(:department, dept_name: 'Clinical Team') }
    let!(:marketing) { create(:department, dept_name: 'Marketing') }
    let!(:operations) { create(:department, dept_name: 'Operations') }
    let!(:data_science) { create(:department, dept_name: 'Data Science') }
    let!(:it) { create(:department, dept_name: 'IT') }
    let!(:quality) { create(:department, dept_name: 'Quality') }
    let!(:science) { create(:department, dept_name: 'Science') }
    let!(:human_resources) { create(:department, dept_name: 'Human Resources') }
    let!(:customer_support) { create(:department, dept_name: 'Customer Support') }

    it 'finds an existing department by normalized name that includes hq' do
      result = Department.find_department('headquarters at blink health')
      expect(result).to eq(executive)
    end

    it 'finds an existing department by normalized name that includes Sales' do
      result = Department.find_department('Field Sales')
      expect(result).to eq(sales)
    end

    it 'finds an existing department by normalized name that includes Clinical' do
      result = Department.find_department('clinical - nurses')
      expect(result).to eq(clinical_team)
    end

    it 'finds an existing department by normalized name that includes Marketing' do
      result = Department.find_department('marketing - 123')
      expect(result).to eq(marketing)
    end

    it 'finds an existing department by normalized name that includes Operations' do
      result = Department.find_department('operations')
      expect(result).to eq(operations)
    end

    it 'finds an existing department by normalized name that includes Data' do
      result = Department.find_department('BBIO - data')
      expect(result).to eq(data_science)
    end

    it 'finds an existing department by normalized name that includes Technology' do
      result = Department.find_department('technology, business, surgery')
      expect(result).to eq(it)
    end

    it 'finds an existing department by normalized name that includes Quality' do
      result = Department.find_department('Quality')
      expect(result).to eq(quality)
    end

    it 'finds an existing department by normalized name that includes Science' do
      result = Department.find_department('science')
      expect(result).to eq(science)
    end

    it 'finds an existing department by normalized name that includes Talent' do
      result = Department.find_department('talent & people')
      expect(result).to eq(human_resources)
    end

    it 'finds an existing department by normalized name that includes Customer Support' do
      result = Department.find_department('customer relations')
      expect(result).to eq(customer_support)
    end

    it 'creates a new department if none exists' do
      expect do
        result = Department.find_department('New Department')
      end.to change(Department, :count).by(1)
    end

    it 'logs an error when creating a new department' do
      expect(Adjudication).to receive(:log_error).with(hash_including(error_details: /not found/))
      result = Department.find_department('Unmatched Department')
    end
  end
end
