ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'vcr'
require 'capybara/rails'
require 'minitest/mock'

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
end

class ActiveSupport::TestCase
  fixtures :all


  def load_data(filename)
    File.read("./test/data/#{filename}")
  end

  def load_json(name)
    JSON.parse( load_data(name + '.json') )
  end

end
