# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'dotenv/load'

Bundler.require(*Rails.groups)

module Pharmdv3
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w[assets tasks])

    config.eager_load_paths << Rails.root.join('lib')
    # config.autoload_paths += %W[#{config.root}/app/mappers #{config.root}/app/services]
    # config.autoload_paths << Rails.root.join('lib')

    Dotenv::Rails.load if Rails.env.development? || Rails.env.test?

    ENV['GOOGLE_CREDENTIALS_PATH'] ||= Rails.root.join(
      Rails.application.credentials.dig(:google_sheets, :credentials_path)
    ).to_s
  end
end
