# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Department, type: :model do
  describe '.clean_department_name' do
    it 'removes numbers and parentheses from the department name' do
      puts "\n------------------"
      puts 'Running Test: removes numbers and parentheses from the department name'
      result = Department.clean_department_name('Customer Service (403)')
      puts "Debug: clean_department_name result: #{result}"
      expect(result).to eq('Customer Service')
    end

    it 'removes hyphen prefixes and trims spaces' do
      puts "\n------------------"
      puts 'Running Test: removes hyphen prefixes and trims spaces'
      result = Department.clean_department_name('123 - Customer Service')
      puts "Debug: clean_department_name result: #{result}"
      expect(result).to eq('Customer Service')
    end

    it 'handles names with multiple parts' do
      puts "\n------------------"
      puts 'Running Test: handles names with multiple parts'
      result = Department.clean_department_name('Clinical - Preclinical')
      puts "Debug: clean_department_name result: #{result}"
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
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with HQ'
      result = Department.find_department('headquarters at blink health')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(executive)
    end

    it 'finds an existing department by normalized name that includes Sales' do
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with Sales'
      result = Department.find_department('Field Sales')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(sales)
    end

    it 'finds an existing department by normalized name that includes Clinical' do
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with Clinical'
      result = Department.find_department('clinical - nurses')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(clinical_team)
    end

    it 'finds an existing department by normalized name that includes Marketing' do
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with Marketing'
      result = Department.find_department('marketing - 123')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(marketing)
    end

    it 'finds an existing department by normalized name that includes Operations' do
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with Operations'
      result = Department.find_department('operations')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(operations)
    end

    it 'finds an existing department by normalized name that includes Data' do
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with Data'
      result = Department.find_department('BBIO - data')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(data_science)
    end

    it 'finds an existing department by normalized name that includes Technology' do
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with Technology'
      result = Department.find_department('technology, business, surgery')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(it)
    end

    it 'finds an existing department by normalized name that includes Quality' do
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with Quality'
      result = Department.find_department('Quality')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(quality)
    end

    it 'finds an existing department by normalized name that includes Science' do
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with Science'
      result = Department.find_department('science')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(science)
    end

    it 'finds an existing department by normalized name that includes Talent' do
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with Talent'
      result = Department.find_department('talent & people')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(human_resources)
    end

    it 'finds an existing department by normalized name that includes Customer Support' do
      puts "\n------------------"
      puts 'Running Test: finds an existing department by normalized name with Customer Support'
      result = Department.find_department('customer relations')
      puts "Debug: find_department result: #{result&.dept_name}"
      expect(result).to eq(customer_support)
    end

    it 'creates a new department if none exists' do
      puts "\n------------------"
      puts 'Running Test: creates a new department if none exists'
      expect do
        result = Department.find_department('New Department')
      end.to change(Department, :count).by(1)
    end

    it 'logs an error when creating a new department' do
      puts "\n------------------"
      puts 'Running Test: logs an error when creating a new department'
      expect(Adjudication).to receive(:log_error).with(hash_including(error_details: /not found/))
      result = Department.find_department('Unmatched Department')
    end
  end
end
