# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'dotenv/load'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pharmdv3
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Add the `lib` folder to autoload paths, ignoring specific subdirectories
    config.autoload_lib(ignore: %w[assets tasks])

    # Ensure the `lib` folder is eager loaded in production
    config.eager_load_paths << Rails.root.join('lib')

    # Load .env file in development and test environments
    Dotenv::Rails.load if Rails.env.development? || Rails.env.test?

    # Set the Google Sheets credentials path as an environment variable
    ENV["GOOGLE_CREDENTIALS_PATH"] ||= Rails.root.join(
      Rails.application.credentials.dig(:google_sheets, :credentials_path)
    ).to_s
  end
end
