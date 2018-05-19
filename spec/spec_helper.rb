require 'bundler/setup'
require 'simplecov'
require 'database_cleaner'
require 'faker'
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../core.rb', __FILE__
require File.expand_path '../helpers/request_helper.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() App end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include RequestHelper

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
