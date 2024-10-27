# frozen_string_literal: true

require 'pycall/import'
include PyCall::Import

pyimport :data_processing, as: :dp

class DataProcessingService
  def self.predict_company_attributes(data)
    dp.predict_company_attributes(data)
  end
end
