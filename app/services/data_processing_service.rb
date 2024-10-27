# frozen_string_literal: true

require 'pycall/import'
include PyCall::Import

pyimport :data_processing, as: :dp

class DataProcessingService
  def self.process(data)
    dp.process_data(data)
  end
end
