source 'https://rubygems.org'

ruby '2.5.7'

gem 'rails', '4.2.11'

gem 'pg'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'slim-rails'
gem 'bcrypt-ruby'
gem 'draper'
gem 'font-awesome-rails'
gem 'memoist'
gem 'lodash-rails'
# The latest foundation requires sass 3.4, but Rails 4.1.6 does not support it yet.
gem 'foundation-rails', '=5.4.3.1'
gem 'date_validator'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-shopify-oauth2', git: 'https://github.com/mcrowe/omniauth-shopify-oauth2.git'
gem 'httparty'
gem 'rack-timeout'
gem 'sucker_punch', '~> 1.0'
gem 'rack-cors', require: 'rack/cors'
gem 'faker'
gem 'addressable'
gem 'dotenv-rails'
gem 'angularjs-rails'
gem 'jquery-ui-rails'
gem 'active_model_serializers', github: 'rails-api/active_model_serializers', branch: '0-8-stable'
gem 'newrelic_rpm'
gem 'zeroclipboard-rails'
gem 'coupons', github: 'fnando/coupons'
gem 'paginate'

group :development do
  gem 'quiet_assets'
  gem 'annotate'
  gem 'spring'
  gem 'guard'
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
end

group :development, :test do
  gem 'byebug'
  gem 'webrick'
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'capybara'
  gem 'launchy'
  gem 'm', '~> 1.3.1'
end

group :production do
  gem 'rails_12factor'
  gem 'heroku-deflater'
  gem 'puma'
end

