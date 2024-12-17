# lib/tasks/train_all_models.rake

namespace :ai do
    desc "Train all spaCy models sequentially using the TrainModelsService"
  
    task train_all_models: :environment do
      begin
        puts "Starting the AI model training process..."
        TrainModelsService.call
        puts "All models trained successfully!"
      rescue StandardError => e
        puts "An error occurred while training models: #{e.message}"
      end
    end
  end
  