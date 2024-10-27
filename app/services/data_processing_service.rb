require 'pycall/import'
include PyCall::Import

pyimport :data_processing, as: :dp

class DataProcessingService
  def self.process(data)
    puts "Debugging: dp = #{dp.inspect}"
    dp.process_data(data)  
  end
end
