# frozen_string_literal: true

# spec/lib/utils/title_cleaner_spec.rb

require 'rails_helper'
require 'utils/title_cleaner'

RSpec.describe Utils::TitleCleaner do
  describe '.clean' do
    it 'removes special characters from the title' do
      title = 'Job@Title!!'
      cleaned_title = described_class.clean(title)
      expect(cleaned_title).to eq('JobTitle')
    end

    it 'returns an empty string for nil input' do
      expect(described_class.clean(nil)).to eq('')
    end
  end
end
