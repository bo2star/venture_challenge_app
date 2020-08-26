require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VentureChallengeApp
  class Application < Rails::Application

    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper = false

    I18n.enforce_available_locales = false

    config.action_controller.include_all_helpers = false

    # Allow loading web-fonts from a cdn.
    config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :head, :options]
      end
    end

    # Log the user's IP address.
    config.log_tags = [:remote_ip]

    config.autoload_paths += %W(#{config.root}/app/domain)

    Coupons.configure do |config|
      config.authorizer = proc do |controller|
        controller.authenticate_or_request_with_http_basic do |user, password|
          user == 'ops' && password == ENV['OPS_PASSWORD']
        end
      end
    end
  end
end

require 'linkedin/authentication'
require 'shopify/authentication'
require 'shopify/shop'
require 'youtube/video'
require 'addressable/uri'
