require 'bundler/setup'
require 'simplecov'
require 'database_cleaner'
require 'faker'
require 'rack/test'
require 'rspec'
require 'factory_bot'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../core.rb', __FILE__
require File.expand_path '../helpers/request_helper.rb', __FILE__
Dir["./spec/shared/*.rb"].sort.each { |f| require f }

module RSpecMixin
  include Rack::Test::Methods
  def app() App end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include RequestHelper

  # config.factory_bot dir: 'spec/factories'

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
