# frozen_string_literal: true

require 'rails_helper'
require 'utils/title_cleaner'

RSpec.describe Utils::TitleCleaner do
  describe '.clean_title' do
    it 'removes special characters and whitespace from the title' do
      title = 'Job@Title!!'
      result = described_class.clean_title(title)
      # puts result
      expect(result[:cleaned_title]).to eq('JobTitle')
    end

    it 'returns an empty string for nil input' do
      result = described_class.clean_title(nil)
      # puts result
      expect(result[:cleaned_title]).to eq('')
      expect(result[:modified_title]).to eq('')
    end

    it 'removes employment terms from the title' do
      title = 'Senior Software Engineer (Full Time)'
      result = described_class.clean_title(title)
      expect(result[:cleaned_title]).to eq('Software Engineer')
    end

    it 'removes seniority terms from the title' do
      title = 'Junior Data Scientist'
      result = described_class.clean_title(title)
      expect(result[:cleaned_title]).to eq('Data Scientist')
    end

    it 'handles titles with hyphens, commas, and slashes' do
      title = 'Lead - Developer / Designer, Architect'
      result = described_class.clean_title(title)
      # puts result
      expect(result[:cleaned_title]).to eq('Developer Designer Architect')
    end

    it 'removes "staff" unless the title contains "chief of staff"' do
      title = 'Administrative Staff Manager'
      result = described_class.clean_title(title)
      expect(result[:cleaned_title]).to eq('Administrative Manager')

      title = 'Chief of Staff'
      result = described_class.clean_title(title)
      expect(result[:cleaned_title]).to eq('Chief of Staff')
    end

    it 'removes known location names from the title' do
      allow(Location).to receive(:all).and_return([
                                                    OpenStruct.new(name: 'New York'),
                                                    OpenStruct.new(name: 'San Francisco')
                                                  ])

      title = 'Sales Manager - New York'
      result = described_class.clean_title(title)
      expect(result[:cleaned_title]).to eq('Sales Manager')
    end

    it 'removes roman numerals from the title' do
      title = 'Executive Officer III'
      result = described_class.clean_title(title)
      expect(result[:cleaned_title]).to eq('Executive Officer')
    end

    it 'appends "Machine Learning" if the original title includes it' do
      title = 'Engineer - Machine Learning'
      result = described_class.clean_title(title)
      # puts result
      expect(result[:cleaned_title]).to eq('Engineer Machine Learning')
    end

    it 'handles titles with multiple parts' do
      title = 'Environmental Health and Safety Manager'
      result = described_class.clean_title(title)
      expect(result[:cleaned_title]).to eq('Environmental Health and Safety Manager')
    end

    it 'cleans up unnecessary dots and extra spaces' do
      title = 'Lead Software Developer..... '
      result = described_class.clean_title(title)
      # puts result
      expect(result[:cleaned_title]).to eq('Software Developer')
    end

    it 'provides both cleaned and modified titles' do
      title = 'Junior Data Scientist, Analytics'
      result = described_class.clean_title(title)
      expect(result[:cleaned_title]).to eq('Data Scientist Analytics')
      expect(result[:modified_title]).to eq('Data Scientist of Analytics')
    end
  end
end
